Given /^a company has been added$/ do
  @organisation = @company = Company.make
end

Given /^the company has directors$/ do
  @company.directors.make_n(2, :member_class => @company.member_classes.find_by_name('Director'))
end
