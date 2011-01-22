module OneClickOrgs
  class Setup
    def self.complete?
      (Setting[:base_domain].present? && Setting[:signup_domain].present?) || Setting[:single_organisation_mode] == 'true'
    end
  end
end
