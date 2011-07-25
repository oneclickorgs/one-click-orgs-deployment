class Company < Organisation
  def create_default_member_classes
    member_classes.find_or_create_by_name('Director')
  end
end
