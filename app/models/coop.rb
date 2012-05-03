class Coop < Organisation
  has_many :board_meetings, :foreign_key => 'organisation_id'
  has_many :general_meetings, :foreign_key => 'organisation_id'
  
  def create_default_member_classes
    member_classes.find_or_create_by_name('Member')
    member_classes.find_or_create_by_name('Founder Member')
    member_classes.find_or_create_by_name('Director')
  end
end
