require 'rails_helper'

describe "one_click/dashboard" do

  context "when current organisation is a company" do
    before(:each) do
      @organisation = mock_model(Company, :name => "Grapes Ltd")
      assign(:current_organisation, @organisation)
      allow(view).to receive(:current_organisation).and_return(@organisation)
      allow(view).to receive(:co).and_return(@organisation)
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

      assign(:proposals, [])

      allow(view).to receive(:can?).with(:create, Proposal).and_return(false)
    end

    describe "new meeting form" do
      it "renders a form-reveal button 'Record minutes'" do
        render
        expect(rendered).to have_selector("input[type='button'][value='Record minutes'][class='button-form-show']")
      end

      it "renders a new meeting form" do
        render
        expect(rendered).to have_selector("form[action='/meetings']") do |form|
          expect(form).to have_selector("select[name='meeting[happened_on(1i)]']")
          expect(form).to have_selector("select[name='meeting[happened_on(2i)]']")
          expect(form).to have_selector("select[name='meeting[happened_on(3i)]']")

          expect(form).to have_selector("input[type='checkbox'][name='meeting[participant_ids][1]', :value => '1']")
          expect(form).to have_selector("input[type='checkbox'][name='meeting[participant_ids][2]', :value => '1']")
          expect(form).to have_selector("input[type='checkbox'][name='meeting[participant_ids][3]', :value => '1']")

          expect(form).to have_selector("textarea[name='meeting[minutes]']")

          expect(form).to have_selector("input[type='submit']")
        end
      end
    end

    describe "timeline" do
      it "renders a timeline" do
        render
        expect(rendered).to have_selector('table.timeline')
      end

      it "renders a meeting event" do
        render
        expect(rendered).to have_selector('table.timeline td', :text => "Old discussions")
      end
    end

  end

  context "when the current organisation is a co-op" do
    before(:each) do
      @coop = mock_model(Coop)
      install_organisation_resolver(@coop)

      assign(:timeline, [])

      allow(view).to receive(:can?).and_return(false)

      view.stub_chain(:co, :elections, :where).and_return([])
    end

    it "renders" do
      render
    end
  end
end
