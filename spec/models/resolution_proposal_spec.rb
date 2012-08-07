require 'spec_helper'

describe ResolutionProposal do
  
  describe "automatic title" do
    it "automatically sets the title based on the description" do
      @resolution_proposal = ResolutionProposal.make(:title => nil, :description => "A description of the resolution")
      @resolution_proposal.save!
      @resolution_proposal.title.should be_present
    end
  end
  
  describe "notification email" do
    before(:each) do
      @coop = Coop.make!
      @secretary = @coop.members.make!(:secretary)
      @resolution_proposal = @coop.resolution_proposals.make
    end
    
    it "is sent to the Secretary" do
      @resolution_proposal.members_to_notify.should == [@secretary]
    end
    
    it "is customised for resolution proposals" do
      @resolution_proposal.notification_email_action.should == :notify_resolution_proposal
    end
  end
  
  describe "enacting" do
    before(:each) do
      @resolution = mock_model(Resolution,
        :proposer= => nil,
        :description= => nil,
        :organisation= => nil,
        :title= => nil,
        :save! => true
      )
    end

    context "for a generic Resolution" do
      before(:each) do
        @resolution_proposal = ResolutionProposal.make!

        Resolution.stub(:new).and_return(@resolution)
      end

      it "builds a new resolution" do
        Resolution.should_receive(:new).and_return(@resolution)
        @resolution_proposal.enact!
      end

      it "sets the new resolution's proposer to the existing proposer" do
        @resolution.should_receive(:proposer=).with(@resolution_proposal.proposer)
        @resolution_proposal.enact!
      end

      it "sets the new resolution's description" do
        @resolution.should_receive(:description=).with(@resolution_proposal.description)
        @resolution_proposal.enact!
      end

      it "saves the new resolution" do
        @resolution.should_receive(:save!)
        @resolution_proposal.enact!
      end

      context "when asked to create a draft resolution" do
        before(:each) do
          @resolution_proposal.create_draft_resolution = true
        end

        it "sets the draft attribute on the new resolution" do
          @resolution.should_receive(:draft=).with(true)
          @resolution_proposal.enact!
        end
      end
    end

    context "with resolution parameters" do
      before(:each) do
        @resolution_proposal = ResolutionProposal.make!
        @resolution_proposal.resolution_parameters = {:name => 'organisation_name', :value => "The Tea IPS"}
        @resolution_proposal.resolution_class = 'ChangeTextResolution'
        @resolution_proposal.save!

        @resolution.stub(:name=)
        @resolution.stub(:value=)

        ChangeTextResolution.stub(:new).and_return(@resolution)
      end

      it "passes the resolution parameters to the new resolution" do
        @resolution.should_receive(:name=).with('organisation_name')
        @resolution.should_receive(:value=).with('The Tea IPS')
        @resolution_proposal.enact!
      end

      context "with a resolution class" do
        it "builds a resolution of the class specified in the parameters" do
          ChangeTextResolution.should_receive(:new).and_return(@resolution)
          @resolution_proposal.enact!
        end
      end
    end
  end

  describe "#new_resolution" do
    before(:each) do
      @resolution_proposal = ResolutionProposal.make!
      @resolution_proposal.enact!
    end

    it "returns the new resolution" do
      @resolution_proposal.new_resolution.should be_a(Resolution)
    end
  end

  it "does not cast an automatic support vote for the proposer" do
    ResolutionProposal.new.automatic_proposer_support_vote?.should be_false
  end

  describe "tasks" do
    describe "upon creation" do
      it "creates a task for the secretary" do
        resolution_proposal = ResolutionProposal.make

        secretary = mock_model(Member, :has_permission => false)
        resolution_proposal.organisation.stub(:secretary).and_return(secretary)

        tasks_association = mock("tasks association")
        secretary.stub(:tasks).and_return(tasks_association)

        tasks_association.should_receive(:create).with(hash_including(:subject => resolution_proposal))

        resolution_proposal.save!
      end
    end
  end

  describe "attributes" do
    let(:resolution_proposal) {ResolutionProposal.make}

    it "has a 'resolution_class' attribute" do
      expect{resolution_proposal.resolution_class = 'ChangeBooleanResolution'}.to_not raise_error
      resolution_proposal.save!
      resolution_proposal.reload
      resolution_proposal.resolution_class.should == 'ChangeBooleanResolution'
    end

    it "has a 'resolution_parameters' attribute" do
      expect{resolution_proposal.resolution_parameters = {:name => 'objectives', :value => 'Win'}}.to_not raise_error
      resolution_proposal.save!
      resolution_proposal.reload
      resolution_proposal.resolution_parameters.should == {'name' => 'objectives', 'value' => 'Win'}
    end
  end

end
