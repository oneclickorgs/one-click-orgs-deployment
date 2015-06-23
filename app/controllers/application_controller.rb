require 'lib/one_click_orgs/setup'
require 'lib/unauthenticated'
require 'lib/not_found'
require 'lib/one_click_orgs/organisation_resolver'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :ensure_set_up
  before_filter :ensure_organisation_exists
  before_filter :ensure_authenticated
  before_filter :ensure_member_active_or_pending
  before_filter :ensure_member_inducted
  before_filter :prepare_notifications
  before_filter :load_analytics_events_from_session

  # CURRENT ORGANISATION

  # Returns the organisation corresponding to the subdomain that the current
  # request has been made on (or just returns the organisation if the app
  # is running in single organisation mode).
  def current_organisation
    unless @current_organisation
      if Setting[:single_organisation_mode]
        @current_organisation = Organisation.first
      else
        @current_organisation = Organisation.find_by_host(
          request.host_with_port
        )
      end
      install_organisation_resolver(@current_organisation)
    end
    @current_organisation
  end
  alias :co :current_organisation

  # USER LOGIN

  def current_user
    @current_user if user_logged_in?
  end

  def log_in(user)
    self.current_user = user
    current_user.update_attribute(:last_logged_in_at, Time.now.utc)
  end

  # Returns true if a user is logged in; false otherwise.
  def user_logged_in?
    current_user = @current_user
    current_user ||= session[:user] && co ? co.members.find_by_id(session[:user]) : false
    @current_user = current_user
    current_user.is_a?(Member)
  end

  # Stores the given user as the 'current user', thus marking them as logged in.
  def current_user=(user)
    session[:user] = (user.nil? || user.is_a?(Symbol)) ? nil : user.id
    @current_user = user
  end

  # ADMINISTRATOR LOGIN

  def current_administrator
    @current_administrator if administrator_logged_in?
  end

  def log_in_administrator(administrator)
    self.current_administrator = administrator
  end

  # Returns true if an administrator is logged in; false otherwise.
  def administrator_logged_in?
    current_administrator = @current_administrator
    current_administrator ||= session[:administrator] && Administrator.find_by_id(session[:administrator])
    @current_administrator = current_administrator
    current_administrator.is_a?(Administrator)
  end

  # Stores the given administrator as the 'current administrator', thus marking them as logged in.
  def current_administrator=(administrator)
    session[:administrator] = (administrator.nil? || administrator.is_a?(Symbol)) ? nil : administrator.id
    @current_administrator = administrator
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default = root_path)
    session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
    session[:return_to] = nil
  end

  # MAKING PDFS

  def generate_pdf(filename='Download', options={})
    options = {
      :header_right => "Printed on #{Time.now.utc.to_s(:long_date)}",
      :header_line => true
    }.with_indifferent_access.merge(options)

    organisation = options[:organisation] || co
    @organisation_name = organisation.name

    # If wkhtmltopdf is working...
    begin
      html = options[:html] || render_to_string(:layout => false)

      # Call PDFKit with any wkhtmltopdf --extended-help options
      kit = PDFKit.new(html, :page_size => 'A4',
        :header_right => options[:header_right],
        :header_left => options[:header_left],
        :footer_right => '[page]',
        :header_font_size => 8,
        :footer_font_size => 11,
        :header_line => options[:header_line],
        :header_spacing => 9,
        :footer_spacing => 9
      )

      if options[:stylesheet]
        kit.stylesheets << options[:stylesheet]
      end
      kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"

      send_data(kit.to_pdf, :filename => "#{@organisation_name} #{filename}.pdf",
        :type => 'application/pdf', :disposition => 'attachment')
        # disposition: choose between attachment/inline to force download

      return

    # Fail if it's not installed
    rescue PDFKit::NoExecutableError
      flash[:error] = "The software for generating PDFs (wkhtmltopdf) isn't installed. \
        Contact the maintainer of your One Click Orgs installation for help."
      redirect_to :back

    end
  end

  # NOTIFICATIONS

  def prepare_notifications
    return unless current_user

    # If you have a notification you want to show the user, put the
    # logic in here, and the template in shared/notifications.
    #
    # Call show_notification_once if you only want the user to
    # see your notification once ever (e.g. a 'welcome to the
    # system' notification).
    #
    # Call show_notification if it doesn't matter whether the user
    # has seen this notification before (e.g. a 'you have a new
    # message' notification).

    if co.is_a?(Association)
      if co.pending? && current_user.member_class.name == "Founder"
        show_notification_once(:convener_welcome)
      end

      fap = co.found_association_proposals.last
      # if the organisation is pending
      # and the voting is finished (fap.closed)
      # and a founding proposal exists
      # and is the proposal
      if co.pending? && fap && fap.closed? && !fap.accepted?
        show_notification_once(:founding_proposal_failed, fap.close_date)
      end

      # Only display founding_proposal_passed notification to
      # members who were founding members
      if co.active? && fap && current_user.created_at <= fap.creation_date
        show_notification_once(:founding_proposal_passed)
      end
    end
  end

  # Show a one-off notification to a user, to notify of
  # a specific event happening.
  #
  # With #show_notification_once, a notification of a given type (e.g. a 'convener_welcome' notification) will only be shown once
  # to a given user. If you want to show the notification regardless of whether the user has already seen it before,
  # use #show_notification instead.
  #
  # As an exception to this, you can pass the ignore_earlier_than parameter. If this user has seen this type of notification
  # earlier than the timestamp you pass, the notification will be shown again.
  #
  # @param [Symbol] notification the notification type, `:founding_proposal_passed` or `:founding_proposal_failed`
  # @param [optional, Timestamp] ignore seen-notifications earlier than this time
  # @return [String] notification the string relating to the kind of notification `founding_proposal_passed`.
  #
  # @example Show a notification a user once that their proposal failed, allowing us to render the partial 'founding_proposal_failed' in the view
  #   show_notification_once(:founding_proposal_failed)
  #
  def show_notification_once(notification, ignore_earlier_than = nil)
    return unless current_user
    return if current_user.has_seen_notification?(notification, ignore_earlier_than)
    show_notification(notification)
  end

  def show_notification(notification)
    @notification = notification
  end

  # ANALYTICS

  def track_analytics_event(event_name, options={})
    return unless Rails.env.production? && OneClickOrgs::GoogleAnalytics.active?
    if options[:now]
      @analytics_events ||= []
      @analytics_events.push(event_name)
    else
      session[:analytics_events] ||= []
      session[:analytics_events].push(event_name)
    end
  end

  def load_analytics_events_from_session
    return unless Rails.env.production? && OneClickOrgs::GoogleAnalytics.active?
    unless session[:analytics_events].blank?
      @analytics_events ||= []
      session[:analytics_events].dup.each do |event|
        @analytics_events.push(event)
        session[:analytics_events].delete(event)
      end
    end
  end

protected

  # BEFORE FILTER DEFINITIONS

  def ensure_set_up
    unless OneClickOrgs::Setup.complete?
      redirect_to(:controller => 'setup')
    end
  end

  def ensure_organisation_exists
    unless current_organisation
      redirect_to(new_organisation_url(host_and_port(Setting[:signup_domain])))
    end
  end

  def ensure_authenticated
    if user_logged_in?
      true
    else
      raise Unauthenticated
    end
  end

  def ensure_member_active_or_pending
    if current_user && current_user.inactive?
      session[:user] = nil
      raise Unauthenticated
    end
  end

  def ensure_member_inducted
    case co
    when Association
      redirect_to_welcome_member if co.active? && current_user && !current_user.inducted?
    end
  end

  def ensure_administrator_authenticated
    if administrator_logged_in?
      true
    else
      raise UnauthenticatedAdministrator
    end
  end

  def ensure_administration_subdomain
    if request.host_with_port == Setting[:signup_domain]
      true
    else
      redirect_to(new_organisation_url(host_and_port(Setting[:signup_domain])))
    end
  end

  def redirect_to_welcome_member
    redirect_to(:controller => 'welcome', :action => 'index')
  end

  def find_constitution
    @constitution = co.constitution
  end

  def host_and_port(domain)
    host, port = domain.split(':')
    if port
      {:host => host, :port => port}
    else
      {:host => host}
    end
  end

  # EXCEPTION HANDLING

  rescue_from NotFound, :with => :render_404
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  def render_404
    render :file => "#{Rails.root}/public/404", :status => 404, :layout => false
  end

  rescue_from Unauthenticated, :with => :handle_unauthenticated
  def handle_unauthenticated
    store_location
    redirect_to login_path
  end

  rescue_from UnauthenticatedAdministrator, :with => :handle_unauthenticated_administrator
  def handle_unauthenticated_administrator
    store_location
    redirect_to admin_login_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_path
  end

  # ORGANISATION RESOLVER

  # Configures the controller's view context to use an
  # OrganisationResolver based on the given organisation's class when
  # resolving (looking up) template paths.
  def install_organisation_resolver(organisation)
    view_paths.dup.each do |view_path|
      prepend_view_path(
        OneClickOrgs::OrganisationResolver.new(
          view_path.to_path,
          organisation.class
        )
      )
    end
  end
end
