require 'spec_helper'

describe 'directors/coop/index' do

  let(:task) {mock_model(Task, :to_partial_name => 'task_election_view_result')}

  before(:each) do
    @directors = [
      mock_model(Member, :to_param => '4',
        :gravatar_url => nil,
        :name => "Lisa Baker",
        :directorship => @directorship = mock_model(Directorship, :to_param => '5', :elected_on => 1.week.ago)
      )
    ]
    assign(:directors, @directors)

    @offices = [
      mock_model(Office, :title => 'Treasurer',
        :officer => mock_model(Member, :name => "John Smith"),
        :officership => @officership = mock_model(Officership, :to_param => '3', :elected_on => 1.week.ago)
      )
    ]
    assign(:offices, @offices)

    assign(:tasks, [task])
    stub_template('tasks/_task_election_view_result' => 'task template')

    view.stub(:can?).and_return(false)
  end

  it "displays a list of director-related tasks for the current user" do
    render
    rendered.should render_template('tasks/_task_election_view_result')
  end

  it "renders a list of the offices" do
    render
    rendered.should have_selector('.offices') do |offices|
      offices.should have_selector('.treasurer', :content => 'John Smith')
    end
  end

  context "when user can edit the Officerships" do
    before(:each) do
      view.stub(:can?).with(:edit, @officership).and_return(true)
    end

    it "renders a 'Step down' button for each officer" do
      render
      rendered.should have_selector('.treasurer') do |treasurer|
        treasurer.should have_selector(:input, 'data-url' => '/officerships/3/edit')
      end
    end
  end

  context "when user can edit the Directorships" do
    before(:each) do
      view.stub(:can?).with(:edit, @directorship).and_return(true)
    end

    it "renders a 'Retire' button for each director" do
      render
      rendered.should have_selector(:input, 'data-url' => '/directorships/5/edit')
    end
  end


  context "when user can create a Director" do
    before(:each) do
      view.stub(:can?).with(:create, Directorship).and_return(true)
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
