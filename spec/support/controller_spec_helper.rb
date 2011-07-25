module ControllerSpecHelper
  def stub_app_setup
    controller.stub!(:ensure_set_up)
    Setting.stub!(:[]).with(:single_organisation_mode).and_return(nil)
    Setting.stub!(:[]).with(:base_domain).and_return('oneclickorgs.com')
    Setting.stub!(:[]).with(:signup_domain).and_return('create.oneclickorgs.com')
  end
end
