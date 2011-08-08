class Association < Organisation
  state_machine :initial => :pending do
    event :propose do
      transition :pending => :proposed
    end
    
    event :found do
      transition :proposed => :active
    end
    
    event :fail do
      transition :proposed => :pending
    end
    
    after_transition :proposed => :active, :do => :destroy_pending_state_member_classes
  end
  
  # Need to add the subclasses individually so that we can do things like:
  #   co.add_member_proposals.create(...)
  # to create a properly-scoped AddMemberProposal.
  has_many :add_member_proposals            , :foreign_key => 'organisation_id'
  has_many :change_member_class_proposals   , :foreign_key => 'organisation_id'
  has_many :change_voting_period_proposals  , :foreign_key => 'organisation_id'
  has_many :change_voting_system_proposals  , :foreign_key => 'organisation_id'
  has_many :eject_member_proposals          , :foreign_key => 'organisation_id'
  has_many :found_association_proposals     , :foreign_key => 'organisation_id'
  
  validates_presence_of :objectives
  
  def objectives
    @objectives ||= clauses.get_text('organisation_objectives')
  end
  
  def objectives=(objectives)
    clauses.build(:name => 'organisation_objectives', :text_value => objectives)
    @objectives = objectives
  end
  
  def assets
    @assets ||= clauses.get_boolean('assets')
  end
  
  def assets=(assets)
    clauses.build(:name => 'assets', :boolean_value => assets)
    @assets = assets
  end
  
  def convener
    members.first
  end
  
  # Delete Founder and Founding Member member classes
  def destroy_pending_state_member_classes
    member_classes.find_by_name('Founder').destroy
    member_classes.find_by_name('Founding Member').destroy
  end
  
  def can_hold_founding_vote?
    pending? && members.count >= 3
  end
  
  def member_eligible_to_vote?(member, proposal)
    return true if proposed?
    member.inducted? && proposal.creation_date >= member.inducted_at
  end
  
  def create_default_member_classes
    members = member_classes.find_or_create_by_name('Member')
    members.set_permission!(:constitution_proposal, true)
    members.set_permission!(:membership_proposal, true)
    members.set_permission!(:freeform_proposal, true)
    members.set_permission!(:vote, true)
    members.save
    
    founder = member_classes.find_or_create_by_name('Founder')
    founder.set_permission!(:founder, true)
    founder.set_permission!(:constitution_proposal, true)
    founder.set_permission!(:membership_proposal, true)
    founder.set_permission!(:freeform_proposal, true)
    founder.set_permission!(:found_association_proposal, true)
    founder.set_permission!(:vote, true)
    founder.save

    founding_member = member_classes.find_or_create_by_name('Founding Member')
    founding_member.set_permission!(:founder, false)
    founding_member.set_permission!(:constitution_proposal, false)
    founding_member.set_permission!(:membership_proposal, false)
    founding_member.set_permission!(:freeform_proposal, false)
    founding_member.set_permission!(:found_association_proposal, false)
    founding_member.set_permission!(:vote, true)
    founding_member.save
  end
  
  def set_default_voting_systems
    constitution.set_voting_system(:general, 'RelativeMajority')
    constitution.set_voting_system(:membership, 'Veto')
    constitution.set_voting_system(:constitution, 'AbsoluteTwoThirdsMajority')
  end
  
  def set_default_voting_period
    constitution.set_voting_period(259200)
  end
  
  # FAKE ASSOCIATIONS
  
  def founding_members
    members.founding_members(self)
  end
  
  def build_founding_member(attributes={})
    FoundingMember.new({
      :organisation => self,
      :member_class => member_classes.find_by_name("Founding Member")
    }.merge(attributes))
  end
  
  def build_constitution_proposal_bundle(attributes={})
    ConstitutionProposalBundle.new({
      :organisation => self
    }.merge(attributes))
  end
end
