module ModelSpecHelper
  def stub_app_setup
    allow(Setting).to receive(:[]).with(:single_organisation_mode).and_return(nil)
    allow(Setting).to receive(:[]).with(:base_domain).and_return('oneclickorgs.com')
    allow(Setting).to receive(:[]).with(:signup_domain).and_return('create.oneclickorgs.com')
    allow(Setting).to receive(:[]).with(:association_enabled).and_return('true')
    allow(Setting).to receive(:[]).with(:company_enabled).and_return('true')
    allow(Setting).to receive(:[]).with(:coop_enabled).and_return('true')
  end
end
