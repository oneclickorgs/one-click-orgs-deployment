class Task < ActiveRecord::Base
  attr_accessible :subject

  belongs_to :subject, :polymorphic => true

  def to_partial_name
    partial_name  = "task_"
    partial_name += subject.class.name.underscore
    if action.present?
      partial_name += "_#{action.to_s}"
    end
    partial_name
  end
end
