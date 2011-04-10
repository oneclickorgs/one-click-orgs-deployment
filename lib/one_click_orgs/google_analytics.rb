module OneClickOrgs
  class GoogleAnalytics
    cattr_accessor :id
    cattr_accessor :domain
    
    def self.active?
      id && domain
    end
  end
end
