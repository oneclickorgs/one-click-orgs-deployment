module ModelSpecHelper
  def stub_app_setup
    Setting.stub!(:[]).with(:single_organisation_mode).and_return(nil)
    Setting.stub!(:[]).with(:base_domain).and_return('oneclickorgs.com')
    Setting.stub!(:[]).with(:signup_domain).and_return('create.oneclickorgs.com')
  end
end
