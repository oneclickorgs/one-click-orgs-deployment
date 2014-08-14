require 'spec_helper'

describe GeneralMeetingProposal do

  it 'uses the TenPercentOrOneHundred voting system' do
    expect(GeneralMeetingProposal.make.voting_system).to eq(VotingSystems::TenPercentOrOneHundred)
  end

  it 'sets a default title' do
    @general_meeting_proposal = GeneralMeetingProposal.make(title: '')
    @general_meeting_proposal.save!
    expect(@general_meeting_proposal.title).to be_present
  end

  describe 'enacting' do
    it 'sets a task for the Secretary' do
      general_meeting_proposal = GeneralMeetingProposal.make!
      general_meeting_proposal.organisation.members.make!(:secretary) unless general_meeting_proposal.organisation.secretary

      secretary = general_meeting_proposal.organisation.secretary

      expect{general_meeting_proposal.enact!}.to change{secretary.tasks.count}.by(1)
    end
  end

end
