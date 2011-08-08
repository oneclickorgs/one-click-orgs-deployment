module OneClickOrgs
  VERSION = "1.2.1" unless defined?(::OneClickOrgs::VERSION)
  
  def self.version
    if VERSION =~ /^0/
      VERSION + " (beta)"
    else
      VERSION
    end
  end
end
