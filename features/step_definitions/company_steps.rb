def make_company
  @organisation = @company = Company.make!
  @company.directors.make!(member_class: @company.member_classes.find_by_name('Director'))
end

Given(/^a company has been added$/) do
  make_company
end

Given(/^there is a company$/) do
  make_company
end

Given(/^the company has directors$/) do
  if @company.directors.count < 2
    @company.directors.make!(2, :member_class => @company.member_classes.find_by_name('Director'))
  end
end
