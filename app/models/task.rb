class Task < ActiveRecord::Base
  attr_accessible :subject, :action, :starts_on

  belongs_to :subject, :polymorphic => true

  scope :current, lambda {
    where(["(starts_on IS NULL OR starts_on <= :today) AND completed_at IS NULL", {:today => Date.today}])
  }

  def to_partial_name
    partial_name  = "task_"
    partial_name += subject.class.name.underscore
    if action.present?
      partial_name += "_#{action.to_s}"
    end
    partial_name
  end
end
