require 'spec_helper'

describe 'directorships/external' do

  let(:directorship) {mock_model(Directorship,
    :director => director,
    :director_attributes= => nil
  ).as_new_record}

  let(:director) {mock_model(Member, :member_class_id => 999).as_new_record}

  before(:each) do
    assign(:directorship, directorship)
  end

  it "renders a 'first name' field" do
    render
    rendered.should have_selector(:input, :name => "directorship[director_attributes][first_name]")
  end

  it "renders a 'last name' field" do
    render
    rendered.should have_selector(:input, :name => "directorship[director_attributes][last_name]")
  end

  it "renders an 'email' field" do
    render
    rendered.should have_selector(:input, :name => "directorship[director_attributes][email]")
  end

  it "renders a hidden field for the director's member_class_id" do
    render
    rendered.should have_selector(:input, :name => "directorship[director_attributes][member_class_id]", :value => "999")
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
