class MemberClass < ActiveRecord::Base
  attr_accessible :name, :description
  
  belongs_to :organisation
  has_many :members

  validates_presence_of :name
  
  def has_permission(type)
    organisation.clauses.get_boolean(get_permission_name(type)) || false
  end
  alias_method :has_permission?, :has_permission

  def set_permission!(type, value)
    organisation.clauses.set_boolean!(get_permission_name(type), value)
  end

  def destroy
    super
    # Delete clauses that codify this member class's abilities
    # (if we modelled member classes as relation we could simply cascade...)
    clauses = organisation.clauses.where('name LIKE :name', { :name => get_permission_name('%') })
    clauses.each { |c| c.destroy }
  end
  
private
  
  def get_permission_name(type)
    "permission_#{self.name.underscore}_#{type.to_s.underscore}"
  end
end
