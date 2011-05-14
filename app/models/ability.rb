# Translates the permissions associated with a member class into fine-grained
# permissions for the CRUD actions on each model. Also consolidates checks
# related to the current status of the organisation.
class Ability
  include CanCan::Ability
  
  def initialize(user)
    return unless user
    
    can :update, Member, :id => user.id
    
    if user.has_permission(:membership_proposal)
      can :create, AddMemberProposal if user.organisation.active?
      can :create, ChangeMemberClassProposal
      can :create, EjectMemberProposal
      can :create, FoundingMember if user.has_permission(:direct_edit) && user.organisation.pending? # FIXME having direct_edit permission is just a side-effect of being the Founder, which is the real check
    end
    
    if user.has_permission(:constitution_proposal)
      can :update, Constitution if user.organisation.pending? && user.has_permission(:direct_edit)
      can :create, ConstitutionProposalBundle if user.organisation.active?
    end
    
    if user.has_permission(:found_organisation_proposal)
      can :create, FoundOrganisationProposal if user.organisation.pending?
    end
    
    if user.has_permission(:freeform_proposal)
      can :create, Proposal if !user.organisation.proposed?
    end
    
    if user.has_permission(:vote)
      can :create, Vote
      can :vote_on, Proposal do |proposal|
        user.eligible_to_vote?(proposal)
      end
    end
  end
end
