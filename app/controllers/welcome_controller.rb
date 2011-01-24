class WelcomeController < ApplicationController
  skip_before_filter :ensure_member_inducted
  skip_before_filter :prepare_notifications

  def index
    @organisation_name = co.name
    prepare_constitution_view
  end

  def induct_member
    member = current_user
    member.inducted!
    member.save
    redirect_to root_path
  end

  def cancel_membership
    @organisation_name = co.name
  end
end
