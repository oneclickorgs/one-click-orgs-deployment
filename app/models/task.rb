class Task < ActiveRecord::Base
  SHARES_RELATED = ['ShareTransaction']
  DIRECTORS_RELATED = ['Election']
  MEMBERS_RELATED = ['Member']

  attr_accessible :subject, :action, :starts_on

  belongs_to :subject, :polymorphic => true

  scope :current, lambda {
    where(["(starts_on IS NULL OR starts_on <= :today) AND completed_at IS NULL", {:today => Date.today}])
  }

  scope :shares_related, where(:subject_type => SHARES_RELATED)
  scope :directors_related, where(:subject_type => DIRECTORS_RELATED)
  scope :members_related, where(:subject_type => MEMBERS_RELATED)

  scope :members_or_shares_related, where(:subject_type => (SHARES_RELATED + MEMBERS_RELATED))

  scope :undismissed, where('dismissed_at is null')

  def to_partial_name
    return nil unless subject

    partial_name  = "task_"
    partial_name += subject.class.name.underscore
    if action.present?
      partial_name += "_#{action.to_s}"
    end
    partial_name
  end

  def complete!
    update_attribute(:completed_at, Time.now.utc)
  end

  def dismiss!
    update_attribute(:dismissed_at, Time.now.utc)
  end
end
