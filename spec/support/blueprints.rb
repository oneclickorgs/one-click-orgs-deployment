require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.name               { Faker::Name.name }
Sham.email              { Faker::Internet.email }
Sham.password           { Faker::Name.first_name }
Sham.first_name         { Faker::Name.first_name }
Sham.last_name          { Faker::Name.last_name }
Sham.subdomain          { Faker::Internet.domain_word }
Sham.objectives         { Faker::Company.bs }
Sham.organisation_name  { Faker::Company.name }
Sham.minutes            { Faker::Lorem.paragraph }

MemberClass.blueprint do
  name "Director"
  organisation
end

MemberClass.blueprint(:founder) do
  name "Founder"
end

Member.blueprint do
  email
  first_name
  last_name
  created_at {Time.now.utc - 1.day}
  password "password"
  password_confirmation "password"
  state 'active'
  inducted_at {Time.now.utc - 23.hours}
  member_class {MemberClass.make}
end

Member.blueprint(:founder) do
  member_class {MemberClass.make(:founder)}
end

Member.blueprint(:pending) do
  inducted_at nil
  state 'pending'
end

Proposal.blueprint do
  title "a proposal title"
  state "open"
  proposer {Member.make(:organisation => organisation)}
end

AddMemberProposal.blueprint do
  title "a proposal title"
  state 'open'
  parameters {{:first_name => Sham.first_name, :last_name => Sham.last_name, :email => Sham.email}}
end

FoundAssociationProposal.blueprint do
  title "Proposal to Found org"
  description "Found org"
  state "open"
  proposer {Member.make}
end

ChangeVotingPeriodProposal.blueprint do
end

ChangeTextProposal.blueprint do
end

EjectMemberProposal.blueprint do
end

Decision.blueprint do
  proposal {Proposal.make}
end

Clause.blueprint do
  name 'objectives'
  text_value 'consuming doughnuts'
  started_at {Time.now - 1.day}
end

Setting.blueprint do
  key 'base_domain'
  value 'oneclickorgs.com'
end

Organisation.blueprint do
  name { Sham.organisation_name }
  subdomain
end

Association.blueprint do
  objectives
end

Company.blueprint do
end

Meeting.blueprint do
  organisation { Company.make }
  happened_on { 1.day.ago }
  minutes { Sham.minutes }
end

MeetingParticipation.blueprint do
end

Comment.blueprint do
end

Director.blueprint do
  certification '1'
end

Comment.blueprint do
end
