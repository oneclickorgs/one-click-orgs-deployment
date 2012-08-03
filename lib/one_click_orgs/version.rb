module OneClickOrgs
  VERSION = "2.0.0alpha1" unless defined?(::OneClickOrgs::VERSION)
  
  def self.version
    VERSION
  end

  def self.prerelease?
    !!version.match(/alpha/) || !!version.match(/beta/)
  end
end
