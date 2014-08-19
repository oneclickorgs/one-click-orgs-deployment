require 'spec_helper'

describe Constitution do

  describe "updated_at" do
    let(:constitution) { Constitution.new(organisation) }
    let(:organisation) { mock_model(Organisation, constitution_clause_names: [:organisation_name, :organisation_objectives], clauses: clauses_association) }
    let(:clauses_association) { double('clauses association')}

    it "returns the start_date of the most recently started constitution clause" do
      allow(clauses_association).to receive(:get_current).with(:organisation_name).and_return(mock_model(Clause, started_at: Time.new(2014, 2, 1)))
      allow(clauses_association).to receive(:get_current).with(:organisation_objectives).and_return(mock_model(Clause, started_at: Time.new(2014, 1, 1)))

      expect(constitution.updated_at).to eq(Time.new(2014, 2, 1))
    end
  end

  describe "for an Association" do
    before(:each) do
      @organisation = Association.make!(:name => 'abc', :objectives => 'def')
    end

    describe 'voting systems' do
      before do
        #avoid using the db in specs?
        @organisation.clauses.set_text!('general_voting_system', 'RelativeMajority')
      end

      describe "getting voting systems" do
        it "should get the voting system" do
          @organisation.constitution.voting_system(:general).should ==(VotingSystems::RelativeMajority)
        end

        it "should raise ArgumentError if invalid voting system is specified" do
          lambda { @organisation.constitution.voting_system(:invalid) }.should raise_error(ArgumentError)
        end
      end

      describe "changing the voting system" do
        it "should change the voting system" do
          @organisation.constitution.change_voting_system(:general, 'Unanimous')
          @organisation.constitution.voting_system(:general).should ==(VotingSystems::Unanimous)
        end

        it "should keep track of the previous voting system after changing it" do
          lambda {
            @organisation.constitution.change_voting_system(:general, 'Unanimous')
          }.should change { @organisation.clauses.where(:name => 'general_voting_system').count }.by(1)
          @organisation.clauses.where(:name => 'general_voting_system').order('id ASC')[-2].text_value.should == ('RelativeMajority')
        end

        it "should raise ArgumentError when invalid system is specified" do
          lambda { @organisation.constitution.change_voting_system(:general, nil) }.should raise_error(ArgumentError)
          lambda { @organisation.constitution.change_voting_system(:general, 'Invalid') }.should raise_error(ArgumentError)
        end
      end
    end

    describe "voting period" do
      before(:each) do
        @organisation.clauses.set_integer!('voting_period', 1000)
      end

      it "should get the current voting period" do
        @organisation.constitution.voting_period.should be_an(Integer)
        @organisation.constitution.voting_period.should >(0)
        @organisation.constitution.voting_period.should ==(1000)
      end

      it "should change the current voting period" do
        lambda { @organisation.constitution.change_voting_period(86400 * 2) }.should change(@organisation.constitution, :voting_period).from(1000).to(86400*2)
      end
    end
  end

  describe "for a Coop" do
    before(:each) do
      @organisation = Coop.make!
      @constitution = @organisation.constitution
    end

    describe "meeting notice period" do
      it "can be read" do
        @organisation.should_receive(:meeting_notice_period).and_return(14)
        @constitution.meeting_notice_period.should be_present
      end

      it "can be set" do
        @organisation.should_receive(:meeting_notice_period=).with(14)
        @constitution.meeting_notice_period = 14
      end
    end

    describe "quorum number" do
      it "can be read" do
        @organisation.should_receive(:quorum_number).and_return(3)
        @constitution.quorum_number.should be_present
      end

      it "can be set" do
        @organisation.should_receive(:quorum_number=).with(5)
        @constitution.quorum_number = 5
      end
    end

    describe "quorum percentage" do
      it "can be read" do
        @organisation.should_receive(:quorum_percentage).and_return(25)
        @constitution.quorum_percentage.should be_present
      end

      it "can be set" do
        @organisation.should_receive(:quorum_percentage=).with(15)
        @constitution.quorum_percentage = 15
      end
    end

    describe "document" do
      it 'uses the custom document template if it is set' do
        document_template = Rticles::Document.from_yaml(File.open(File.join(Rails.root, 'spec', 'fixtures', 'alternative_rules.yml')))
        document_template.update_attribute(:title, 'alternative_rules')

        @constitution.document_template = document_template
        @organisation.save!

        document = @constitution.document

        expect(document).to eq(document_template)
      end

      it "sets the 'meeting_notice_period' insertion" do
        document = @constitution.document
        document.insertions[:meeting_notice_period].should == 14
      end

      it "formats the registered office address into one line" do
        @constitution.stub(:registered_office_address).and_return("1 High Street\nLondon\nN1 1AA")
        document = @constitution.document
        expect(document.insertions[:registered_office_address]).to eq("1 High Street, London, N1 1AA")
      end

      it "sets multiple_board_classes to true if there is more than one board class selected" do
        @constitution.stub(:user_members).and_return(true)
        @constitution.stub(:employee_members).and_return(true)
        document = @constitution.document
        expect(document.choices[:multiple_board_classes]).to be_true
      end

      it "sets multiple_board_classes to false if only one board class is selected" do
        @constitution.stub(:user_members).and_return(true)
        @constitution.stub(:employee_members).and_return(false)
        @constitution.stub(:supporter_members).and_return(false)
        @constitution.stub(:producer_members).and_return(false)
        @constitution.stub(:consumer_members).and_return(false)
        document = @constitution.document
        expect(document.choices[:multiple_board_classes]).to be_false
      end
    end

    describe 'document_template' do
      let(:document) { Rticles::Document.first }

      it 'can be set' do
        expect{ @constitution.document_template = document }.to_not raise_error
      end

      it 'saves' do
        @constitution.document_template = document
        @organisation.save!
        @organisation.reload
        expect(Constitution.new(@organisation).document_template).to eq(document)
      end
    end
  end
end
