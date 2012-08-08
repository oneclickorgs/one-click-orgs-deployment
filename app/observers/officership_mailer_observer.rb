class OfficershipMailerObserver < ActiveRecord::Observer
  observe :officership

  def after_create(officership)
    welcome_new_officer(officership)
  end

protected

  def welcome_new_officer(officership)
    return unless officership.officer && officership.office

    OfficershipMailer.welcome_new_officer(officership).deliver
  end
end
