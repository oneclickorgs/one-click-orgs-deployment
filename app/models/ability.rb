# Translates the permissions associated with a member class into fine-grained
# permissions for the CRUD actions on each model. Also consolidates checks
# related to the current status of the organisation.
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if user.has_permission(:vote)
      can :create, Vote
      can :vote_on, Proposal do |proposal|
        user.eligible_to_vote?(proposal)
      end
    end

    can :update, Member, :id => user.id

    case user.organisation
    when Association
      if user.has_permission(:freeform_proposal)
        can :create, Proposal if !user.organisation.proposed?
      end

      if user.has_permission(:membership_proposal)
        can :create, AddMemberProposal if user.organisation.active?
        can :create, ChangeMemberClassProposal
        can :create, EjectMemberProposal
        can :create, FoundingMember if user.has_permission(:founder) && user.organisation.pending?
      end

      if user.has_permission(:constitution_proposal)
        can :update, Constitution if user.organisation.pending? && user.has_permission(:founder)
        can :create, ConstitutionProposalBundle if user.organisation.active?
      end

      if user.has_permission(:found_association_proposal)
        can :create, FoundAssociationProposal if user.organisation.pending?
      end
    when Company
      if user.has_permission(:freeform_proposal)
        can :create, Proposal
      end

      if user.has_permission(:director)
        can :create, Director
      end

      if user.has_permission(:meeting)
        can :read, Meeting
        can :create, Meeting
      end
    when Coop
      if user.has_permission(:resolution)
        can :create, Resolution
        can :edit, ResolutionProposal
      end

      if user.has_permission(:board_resolution)
        can :create, BoardResolution
      end

      if user.has_permission(:board_meeting)
        can :read, BoardMeeting
      end

      if user.has_permission(:resolution_proposal)
        can :create, ResolutionProposal
      end

      if user.has_permission(:meeting)
        can :create, Meeting
        can :update, Meeting
      end

      if user.organisation.pending?
        can :update, Constitution
      end

      if user.has_permission(:organisation) || user.organisation.pending?
        can :update, Coop do |coop|
          user.organisation == coop
        end
      end

      if user.has_permission(:founder_member) || user.organisation.pending?
        can :create, FounderMember
      end

      if user.has_permission(:directorship) || user.organisation.pending?
        can :create, Directorship
        can :edit, Directorship
      end

      if user.has_permission(:officership) || user.organisation.pending?
        can :create, Officership
        can :edit, Officership

        can :create, Office
      end

      if user.has_permission(:share_account)
        can :read, ShareAccount
      end

      if user.has_permission(:share_transaction)
        can :read, ShareTransaction
        can :update, ShareTransaction
      end

      can :update, Member do |member|
        user.has_permission(:member) || user == member
      end

      can :read, GeneralMeeting

      can :create, ConstitutionProposalBundle

      can :create, ShareApplication
      can :create, ShareWithdrawal
    end
  end
end
