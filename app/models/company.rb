class Company < Organisation
  has_many :meetings, :foreign_key => 'organisation_id'
  
  def create_default_member_classes
    member_classes.find_or_create_by_name('Director')
  end
  
  def set_default_voting_systems
    constitution.set_voting_system(:general, 'RelativeMajority')
  end
  
  def set_default_voting_period
    constitution.set_voting_period(604800)
  end
  
  def build_director(attributes={})
    Director.new({
      :organisation => self,
      :member_class => member_classes.find_by_name("Director"),
      :state => 'active'
    }.merge(attributes))
  end
end
