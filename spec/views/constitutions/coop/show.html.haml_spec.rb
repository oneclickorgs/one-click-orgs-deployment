require 'spec_helper'

describe 'constitutions/coop/show' do

  let(:organisation) {mock_model(Coop,
    :name => "The Friendly Co-op"
  )}
  let(:constitution) {mock("constitution",
    :name => "The Friendly Co-op",
    :registered_office_address => "1 High Road",
    :objectives => "be friendly.",
    :user_members => true,
    :employee_members => true,
    :supporter_members => true,
    :producer_members => true,
    :consumer_members => true,
    :single_shareholding => false,
    :max_user_directors => 5,
    :max_employee_directors => 5,
    :max_supporter_directors => 5,
    :max_producer_directors => 5,
    :max_consumer_directors => 5,
    :common_ownership => false,
    :meeting_notice_period => 14.days,
    :quorum_number => 3,
    :quorum_percentage => 25
  )}

  before(:each) do
    view.stub(:co).and_return(organisation)
    assign(:constitution, constitution)
  end

  it "renders a button link to edit the constitution" do
    render
    rendered.should have_selector(:input, 'data-url' => '/constitution/edit', :value => "Amend the Rules")
  end

end
