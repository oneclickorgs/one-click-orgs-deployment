require 'machinist/active_record'
require 'faker'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

MemberClass.blueprint do
  name { "Director" }
  organisation
end

MemberClass.blueprint(:founder) do
  name { "Founder" }
end

Member.blueprint do
  email { Faker::Internet.email }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  created_at { Time.now.utc - 1.day }
  password { "password" }
  password_confirmation { "password" }
  state { 'active' }
  inducted_at { Time.now.utc - 23.hours }
  member_class { MemberClass.make }
end

Member.blueprint(:founder) do
  member_class { MemberClass.make(:founder) }
end

Member.blueprint(:secretary) do
  member_class { object.organisation.member_classes.find_by_name!('Secretary') }
  directorships { [object.organisation.directorships.make(:elected_on => 1.month.ago)] }
end

Member.blueprint(:director) do
  member_class { object.organisation.member_classes.find_by_name!('Director') }
  directorships { [object.organisation.directorships.make(:elected_on => 1.month.ago)] }
end

Member.blueprint(:external_director) do
  member_class { object.organisation.member_classes.find_by_name!('External Director') }
  directorships { [object.organisation.directorships.make(:elected_on => 1.month.ago)] }
end

Member.blueprint(:member) do
  member_class { object.organisation.member_classes.find_by_name!('Member') }
end

Member.blueprint(:pending) do
  inducted_at { nil }
  state { 'pending' }
end

Member.blueprint(:founder_member) do
  member_class { object.organisation.member_classes.find_by_name!('Founder Member') }
end

Proposal.blueprint do
  title { "a proposal title" }
  state { "open" }
  proposer { Member.make(:organisation => object.organisation) }
end

Proposal.blueprint(:draft) do
  state { 'draft' }
end

AddMemberProposal.blueprint do
  title { "a proposal title" }
  state { 'open' }
  parameters { {
    :first_name => Faker::Name.first_name,
    :last_name => Faker::Name.last_name,
    :email => Faker::Internet.email
  } }
end

FoundAssociationProposal.blueprint do
  title { "Proposal to Found org" }
  description { "Found org" }
  state { "open" }
  proposer { Member.make }
end

FoundAssociationProposal.blueprint(:accepted) do
  state { 'accepted' }
  decision { Decision.make }
end

ChangeVotingPeriodProposal.blueprint do
end

ChangeTextProposal.blueprint do
end

EjectMemberProposal.blueprint do
end

ResolutionProposal.blueprint do
  organisation { Coop.make }
  description { 'The description of the suggested resolution.'}
end

Resolution.blueprint do
  organisation { Coop.make }
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
end

Resolution.blueprint(:draft) do
  state {'draft'}
end

BoardResolution.blueprint do
  organisation { Coop.make }
end

ChangeMeetingNoticePeriodResolution.blueprint do
end

ChangeQuorumResolution.blueprint do
end

ChangeTextResolution.blueprint do
end

Decision.blueprint do
  proposal { Proposal.make }
end

Clause.blueprint do
  name { 'objectives' }
  text_value { 'consuming doughnuts' }
  started_at { Time.now - 1.day }
end

Setting.blueprint do
  key { 'base_domain' }
  value { 'oneclickorgs.com' }
end

Organisation.blueprint do
  name { Faker::Company.name }
  subdomain { Faker::Internet.domain_word + sn }
end

Association.blueprint do
  objectives { Faker::Company.bs }
end

Association.blueprint(:pending) do
  state { 'pending' }
end

Company.blueprint do
end

Coop.blueprint do
  state { 'active' }
end

Coop.blueprint(:pending) do
  state { 'pending' }
end

Coop.blueprint(:proposed) do
  state { 'proposed' }
end

Meeting.blueprint do
  organisation { Company.make }
  happened_on { 1.day.ago }
  minutes { Faker::Lorem.paragraph }
end

BoardMeeting.blueprint do
end

BoardMeeting.blueprint(:past) do
  happened_on { 3.days.ago }
end

GeneralMeeting.blueprint do
  organisation { Coop.make }
end

GeneralMeeting.blueprint(:past) do
  happened_on { 3.days.ago }
end

GeneralMeeting.blueprint(:upcoming) do
  happened_on { 2.weeks.from_now }
end

AnnualGeneralMeeting.blueprint do
end

AnnualGeneralMeeting.blueprint(:past) do
  happened_on { 3.days.ago }
end

MeetingParticipation.blueprint do
end

Comment.blueprint do
end

Director.blueprint do
  certification { '1' }
  age_certification { '1' }
end

Comment.blueprint do
end

Resignation.blueprint do
end

Officership.blueprint do
  elected_on { 1.month.ago }
end

Office.blueprint do
  title { Faker::Name.title }
end

Election.blueprint do
  seats { 3 }
end

Nomination.blueprint do
end

Ballot.blueprint do
end

Task.blueprint do
end

Directorship.blueprint do
end

Administrator.blueprint do
  email { Faker::Internet.email }
  password { 'password' }
  password_confirmation { 'password' }
end

ShareAccount.blueprint do
end

ShareTransaction.blueprint do
  from_account
  to_account
  amount { 1 }
end

AgendaItem.blueprint do
end

Vote.blueprint do
  member
  self.send(:assign_attribute, :for, true)
end

TerminateDirectorshipResolution.blueprint do
  title {nil}
end
