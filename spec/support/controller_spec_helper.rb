module ControllerSpecHelper
  def stub_app_setup
    controller.stub(:ensure_set_up)
    Setting.stub(:[]).with(:single_organisation_mode).and_return(nil)
    Setting.stub(:[]).with(:base_domain).and_return('oneclickorgs.com')
    Setting.stub(:[]).with(:signup_domain).and_return('create.oneclickorgs.com')
  end
  
  def stub_coop
    @coop = @organisation = mock_model(Coop)
    Organisation.stub!(:find_by_host).and_return(@coop)
  end
  
  def stub_company
    @company = @organisation = mock_model(Company)
    Organisation.stub(:find_by_host).and_return(@company)
  end
  
  def stub_association
    @association = @organisation = mock_model(Association,
      :active? => true,
      :pending? => false,
      :proposed? => false,
      :found_association_proposals => []
    )
    Organisation.stub(:find_by_host).and_return(@association)
  end
  
  def stub_login
    @user = mock_model(Member, :inactive? => false, :inducted? => true)
    controller.stub(:current_user).and_return(@user)
    controller.stub(:user_logged_in?).and_return(true)
  end

  def stub_administrator_login
    @administrator = mock_model(Administrator)
    controller.stub!(:current_administrator).and_return(@administrator)
    controller.stub!(:administrator_logged_in?).and_return(true)

    controller.stub!(:ensure_administration_subdomain).and_return(true)
  end
end
