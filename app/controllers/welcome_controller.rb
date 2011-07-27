class WelcomeController < ApplicationController
  skip_before_filter :ensure_member_inducted
  skip_before_filter :prepare_notifications
  
  layout 'welcome'

  def index
    @organisation_name = co.name
    find_constitution
  end

  def induct_member
    member = current_user
    member.induct!
    
    if current_user == co.members.first
      track_analytics_event('FounderAcceptsConstitution')
    end
    
    redirect_to root_path
  end

  def cancel_membership
    @organisation_name = co.name
  end
end
