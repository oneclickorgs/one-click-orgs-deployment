class Company < Organisation
  has_many :meetings, :foreign_key => 'organisation_id'
  
  def create_default_member_classes
    member_classes.find_or_create_by_name('Director')
  end
end
