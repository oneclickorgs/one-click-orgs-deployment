class OrganisationsController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  skip_before_filter :ensure_member_active
  #skip_before_filter :ensure_organisation_active
  skip_before_filter :ensure_member_inducted
  
  before_filter :ensure_no_overwrite_in_single_organisation_mode
  
  layout "setup"
  
  def new
    
    @organisation = Organisation.new
    @founder = @organisation.members.first || @organisation.members.new
    
    # Require acceptance of the terms and conditions
    @founder.terms_and_conditions = false
    
    #@single_organisation_mode = Setting[:single_organisation_mode]
  end
  
  def create
    @organisation = Organisation.new(params[:organisation])
    @founder = Member.new(params[:founder])
    
    errors = []
    
    # validate
    if !@founder.valid?
      errors << "Please complete your account details: #{@founder.errors.full_messages.to_sentence}."
    end
    if @founder.password != params[:founder][:password_confirmation]
      errors << "Your password and password confirmation do not match."
    end
    if !@organisation.valid?
      errors << "Please complete the details of your organisation: #{@organisation.errors.full_messages.to_sentence}."
    end   

    # validation succeeded -> store
    if errors.size == 0
      @organisation.members << @founder
      if !@organisation.save
        errors << "Cannot create your organisation: #{@organisation.errors.full_messages.to_sentence}."
      end
    
      @founder.member_class = @organisation.member_classes.find_by_name('Founder')
      if !@founder.save
        errors << "Cannot create your account: #{@founder.errors.full_messages.to_sentence}."
      end
      @organisation.pending!
    end
    
    # display errors
    if errors.size > 0
      flash[:error] = errors.join("\n") # don't want to insert <br>s here
      render :action => 'new'
      return
    end

    # continue
    self.current_user = @founder

    MembersMailer.welcome_founder(@founder).deliver # send welcome email    
    current_user.update_attribute(:last_logged_in_at, Time.now.utc) # update login datetime
    
    track_analytics_event('EntersPendingStage')

    if Setting[:single_organisation_mode]
      redirect_to(:controller => 'one_click', :action => 'constitution')
    else
      redirect_to(constitution_url(host_and_port(@organisation.host)))
    end
  end

protected
  # In single organisation mode, you need a guard to
  # stop being able to overwrite information about an
  # organisation once it's first been created.
  def ensure_no_overwrite_in_single_organisation_mode
    if Setting[:single_organisation_mode] == "true" && Organisation.count > 0
      redirect_to root_path
    end
  end
end
