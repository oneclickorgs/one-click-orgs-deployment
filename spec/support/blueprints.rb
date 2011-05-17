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
  active true
  inducted_at {Time.now.utc - 23.hours}
  member_class {MemberClass.make}
end

Member.blueprint(:founder) do
  member_class {MemberClass.make(:founder)}
end

Member.blueprint(:pending) do
  inducted_at nil
end

Proposal.blueprint do
  title "a proposal title"
  # Every object inherits Kernel.open, so just calling 'open' doesn't work.
  # This line hacks into Machinist to manually set the 'open' attribute.
  self.send(:assign_attribute, :open, 1)
  proposer {Member.make}
end

AddMemberProposal.blueprint do
  title "a proposal title"
  self.send(:assign_attribute, :open, 1)
  proposer {Member.make}
  parameters {{:first_name => Sham.first_name, :last_name => Sham.last_name, :email => Sham.email}}
end

FoundOrganisationProposal.blueprint do
  title "Proposal to Found org"
  description "Found org"
  self.send(:assign_attribute, :open, 1)
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
  objectives
  subdomain
end
