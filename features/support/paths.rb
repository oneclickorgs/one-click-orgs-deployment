module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /^the setup page$/
      '/setup'
    when /^the new association page$/
      '/associations/new'
    when /^the new co-op page$/
      '/coops/new'
    when /^the welcome page$/
      '/welcome'
    when /^the voting and proposals page$/
      '/'
    when /^my member page$/
      member_path(@user)
    when /^my account page$/
      edit_member_path(@user)
    when /^the proposal page$/
      @proposal ||= Proposal.last
      proposal_path(@proposal)
    when /^the member page for "(.*)"$/
      @member = @organisation.members.find_by_email($1)
      member_path(@member)
    when /^a member's page$/
      @member = @organisation.members.active.last
      member_path(@member)
    when /^the member's profile page$/
      @member ||= @organisation.members.active.last
      member_path(@member)
    when /^the amendments page$/
      edit_constitution_path
    when /^the members page$/
      members_path
    when /^the new company page$/
      new_company_path
    when /^the Votes & Minutes page$/
      '/'
    when /^the page for the minutes$/
      @meeting ||= @organisation.meeting.last
      meeting_path(@meeting)
    when /^the Directors page$/
      case @organisation
      when Company
        members_path
      when Coop
        directors_path
      end
    when /^the (D|d)ashboard( page)?$/
      '/'
    when /^the Resolutions page$/
      proposals_path
    when /^the "Convene a General Meeting" page$/
      new_general_meeting_path
    when /^the Meetings page$/
      meetings_path
    when /^the Members page$/
      members_path
    when /^another member's profile page$/
      @member = (@organisation.members - [@user]).first
      member_path(@member)
    when /^another director's profile page$/
      @director = (@organisation.members - [@user]).first
      member_path(@director)
    when /^convene a General Meeting$/
      new_general_meeting_path
    when /^the (R|r)ules page$/
      constitution_path
    when /^convene an AGM$/
      new_general_meeting_path
    when /^the (D|d)ashboard(| page) for the (new|draft) co-op$/
      root_path
    when /^the Amendments page$/
      edit_constitution_path
    when /^the co-op review page$/
      admin_coops_path
    when /^the Shares page$/
      '/shares'
    when /^the Checklist page$/
      '/checklist'
    when /^the Proposals page$/
      '/proposals'
    when /^the Board page$/
      '/board'
    when /^edit the registration form$/
      edit_registration_form_path
    when /^the checklist$/
      checklist_path
    when /^the admin view of a proposed co-op$/
      @coop ||= (@coops.present? ? @coops[0] : Coop.proposed.first)
      admin_coop_path(@coop)
    when /^the admin view of a draft co-op$/
      @coop ||= (@coops.present? ? @coops[0] : Coop.pending.first)
      admin_coop_path(@coop)
    when /^the admin view of an active co-op$/
      @coop ||= (@coops.present? ? @coops[0] : Coop.active.first)
      admin_coop_path(@coop)
    when /^edit the registration details$/
      edit_registration_form_path
    when /^Documents$/
      documents_path
    when /^the administrator's users page$/
      admin_members_path
    when /^the domain setup page$/
      '/setup/domains'
    when /^the organisation types page$/
      '/setup/organisation_types'
    when /^the co\-op intro page$/
      intro_coops_path
    when /^create a new resolution$/
      new_resolution_path
    when /^minute the (General Meeting|meeting)$/
      edit_general_meeting_path(@general_meeting)
    when /^the administrator setup page$/
      '/setup/administrator'
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
