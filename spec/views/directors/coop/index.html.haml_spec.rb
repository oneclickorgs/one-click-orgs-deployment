require 'spec_helper'

describe 'directors/coop/index' do

  before(:each) do
    @directors = []
    assign(:directors, @directors)
  end

  context "when user can create a Director" do
    before(:each) do
      view.stub(:can?).with(:create, Director).and_return(true)
    end

    it "renders an 'Appoint new Director' button" do
      render
      rendered.should have_selector(:input, 'data-url' => '/directorships/new', :value => "Appoint new Director")
    end
  end

end
