class Organisation < ActiveRecord::Base
  attr_accessible :subdomain, :name, :objectives, :assets
  
  has_many :clauses
  
  has_many :members
  has_many :resignations, :through => :members
  
  has_many :proposals
  
  has_many :change_boolean_proposals
  has_many :change_text_proposals
  
  has_many :decisions, :through => :proposals
  
  has_many :member_classes
  
  validates_presence_of :name
  validates_uniqueness_of :subdomain
  validates_format_of :subdomain, :with => /\A[a-zA-z0-9\-]*\Z/
  
  after_create :create_default_member_classes
  after_create :set_default_voting_systems
  after_create :set_default_voting_period

  # Given a full hostname, e.g. "myorganisation.oneclickorgs.com",
  # and assuming the installation's base domain is "oneclickorgs.com",
  # returns the organisation corresponding to the subdomain
  # "myorganisation".
  def self.find_by_host(host)
    subdomain = host.sub(Regexp.new("\.#{Setting[:base_domain]}$"), '')
    where(:subdomain => subdomain).first
  end
  
  def constitution
    @constitution ||= Constitution.new(self)
  end
  
  def name
    @name ||= clauses.get_text('organisation_name')
  end
  
  def name=(name)
    clauses.build(:name => 'organisation_name', :text_value => name)
    @name = name
  end
  
  def voting_period
    clauses.get_integer('voting_period')
  end
  
  # Returns the base URL for this instance of OCO.
  # Pass the :only_host => true option to just get the host name.
  def domain(options={})
    raw_domain = host
    if options[:only_host]
      raw_domain
    else
      "http://#{raw_domain}"
    end
  end
  
  def host
    if Setting[:single_organisation_mode] == 'true'
      Setting[:base_domain]
    else
      [subdomain, Setting[:base_domain]].join('.')
    end
  end
  
  def member_eligible_to_vote?(member, proposal)
    raise NotImplementedError
  end
  
  def member_count_for_proposal(proposal)
    raise NotImplementedError
  end
  
  def welcome_email_action
    raise NotImplementedError
  end
  
  def default_member_class
    member_classes.first
  end
  
  def create_default_member_classes
  end
  
  def set_default_voting_systems
  end
  
  def set_default_voting_period
  end
end
