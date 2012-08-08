class DirectorshipMailerObserver < ActiveRecord::Observer
  observe :directorship

  def after_create(directorship)
    welcome_new_director(directorship)
  end

protected

  def welcome_new_director(directorship)
    return unless directorship.organisation && directorship.director

    DirectorshipMailer.welcome_new_director(directorship).deliver
  end
end
