Given(/^a company has been added$/) do
  @organisation = @company = Company.make!
  @company.directors.make!(member_class: @company.member_classes.find_by_name('Director'))
end

Given(/^the company has directors$/) do
  if @company.directors.count < 2
    @company.directors.make!(2, :member_class => @company.member_classes.find_by_name('Director'))
  end
end
