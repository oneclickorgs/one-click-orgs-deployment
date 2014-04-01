module ModelSpecHelper
  def stub_app_setup
    Setting.stub(:[]).with(:single_organisation_mode).and_return(nil)
    Setting.stub(:[]).with(:base_domain).and_return('oneclickorgs.com')
    Setting.stub(:[]).with(:signup_domain).and_return('create.oneclickorgs.com')
    Setting.stub(:[]).with(:association_enabled).and_return('true')
    Setting.stub(:[]).with(:company_enabled).and_return('true')
    Setting.stub(:[]).with(:coop_enabled).and_return('true')
  end
end
