require 'spec_helper'

describe 'directors/coop/index' do

  before(:each) do
    @directors = []
    assign(:directors, @directors)

    @offices = [
      mock_model(Office, :title => 'Treasurer',
        :officer => mock_model(Member, :name => "John Smith")
      )
    ]
    assign(:offices, @offices)
  end

  it "renders a list of the offices" do
    render
    rendered.should have_selector('.offices') do |offices|
      offices.should have_selector('.treasurer', :content => 'John Smith')
    end
  end

  context "when user can create a Director" do
    before(:each) do
      # TODO This should be checking on ability to create a Director, not a Directorship.
      view.stub(:can?).with(:create, Director).and_return(true)
    end

    it "renders an 'Appoint new Director' button" do
      render
      rendered.should have_selector(:input, 'data-url' => '/directorships/new', :value => "Appoint new Director")
    end
  end

  context "when user can create an Officership" do
    before(:each) do
      view.stub(:can?).with(:create, Officership).and_return(true)
    end

    it "renders an 'Appoint a new Officer' button" do
      render
      rendered.should have_selector(:input, 'data-url' => '/officerships/new', :value => "Appoint a new Officer")
    end
  end

end
