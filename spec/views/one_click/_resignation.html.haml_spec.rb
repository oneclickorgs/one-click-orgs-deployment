require 'rails_helper'

describe "one_click/_resignation" do

  before(:each) do
    # Define locals that we expect to be passed to our partial.
    def view.event; super; end

    @member_name = "Bob Smith"
    @event = {:object => mock_model(Resignation,
      :member => mock_model(Member,
        :name => @member_name
      )
    )}
    allow(view).to receive(:event).and_return(@event)
  end

  it "displays the name of the member" do
    render
    expect(rendered).to include(@member_name)
  end

  it "displays the word 'resigned'" do
    render
    expect(rendered).to include('resigned')
  end

end
