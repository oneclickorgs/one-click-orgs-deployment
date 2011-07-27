require 'spec_helper'

describe "one_click/dashboard" do
  
  context "when current organisation is a company" do
    before(:each) do
      @organisation = mock_model(Company)
      assign(:current_organisation, @organisation)
      view.stub!(:current_organisation).and_return(@organisation)
      view.stub!(:co).and_return(@organisation)
      install_organisation_resolver(@organisation)
      
      @meeting = mock_model(Meeting,
        :happened_on => nil,
        :minutes => nil
      ).as_new_record
      assign(:meeting, @meeting)
      
      @directors = [
        mock_model(Member, :id => 1, :name => "A"),
        mock_model(Member, :id => 2, :name => "B"),
        mock_model(Member, :id => 3, :name => "C")
      ]
      assign(:directors, @directors)
      
      @timeline = [
        {
          :timestamp => 3.days.ago,
          :object => mock_model(Meeting,
            :minutes => "Old discussions",
            :happened_on => 4.days.ago
          ),
          :kind => :meeting
        }
      ]
      assign(:timeline, @timeline)
    end

    describe "new meeting form" do
      it "renders a form-reveal button 'Record minutes'" do
        render
        rendered.should have_selector(:input, :type => 'button', :value => 'Record minutes', :class => 'button-form-show')
      end

      it "renders a new meeting form" do
        render
        rendered.should have_selector(:form, :action => '/meetings') do |form|
          form.should have_selector(:select, :name => 'meeting[happened_on(1i)]')
          form.should have_selector(:select, :name => 'meeting[happened_on(2i)]')
          form.should have_selector(:select, :name => 'meeting[happened_on(3i)]')

          form.should have_selector(:input, :type => 'checkbox', :name => 'meeting[participant_ids][1]', :value => '1')
          form.should have_selector(:input, :type => 'checkbox', :name => 'meeting[participant_ids][2]', :value => '1')
          form.should have_selector(:input, :type => 'checkbox', :name => 'meeting[participant_ids][3]', :value => '1')

          form.should have_selector(:textarea, :name => 'meeting[minutes]')

          form.should have_selector(:input, :type => 'submit')
        end
      end
    end

    describe "timeline" do
      it "renders a timeline" do
        render
        rendered.should have_selector('table.timeline')
      end

      it "renders a meeting event" do
        render
        rendered.should have_selector('table.timeline td', :content => "Old discussions")
      end
    end

  end
  
end
