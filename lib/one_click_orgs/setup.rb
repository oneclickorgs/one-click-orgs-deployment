module OneClickOrgs
  class Setup
    def self.complete?
      domains_set? && organisation_types_set?
    end

  private

    def self.domains_set?
      (Setting[:base_domain].present? && Setting[:signup_domain].present?) ||
        Setting[:single_organisation_mode] == 'true'
    end

    def self.organisation_types_set?
      Setting[:association_enabled] == 'true' ||
        Setting[:company_enabled] == 'true' ||
        Setting[:coop_enabled] == 'true'
    end
  end
end
