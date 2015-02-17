module ControllerSpecHelper
  def stub_app_setup
    allow(controller).to receive(:ensure_set_up)
    allow(Setting).to receive(:[]).with(:single_organisation_mode).and_return(nil)
    allow(Setting).to receive(:[]).with(:base_domain).and_return('oneclickorgs.com')
    allow(Setting).to receive(:[]).with(:signup_domain).and_return('create.oneclickorgs.com')
    allow(Setting).to receive(:[]).with(:association_enabled).and_return('true')
    allow(Setting).to receive(:[]).with(:company_enabled).and_return('true')
    allow(Setting).to receive(:[]).with(:coop_enabled).and_return('true')
  end
  
  def stub_coop
    @coop = @organisation = mock_model(Coop)
    allow(Organisation).to receive(:find_by_host).and_return(@coop)
  end
  
  def stub_company
    @company = @organisation = mock_model(Company)
    allow(Organisation).to receive(:find_by_host).and_return(@company)
  end
  
  def stub_association
    @association = @organisation = mock_model(Association,
      :active? => true,
      :pending? => false,
      :proposed? => false,
      :found_association_proposals => []
    )
    allow(Organisation).to receive(:find_by_host).and_return(@association)
  end
  
  def stub_login
    @user = mock_model(Member, :inactive? => false, :inducted? => true)
    allow(controller).to receive(:current_user).and_return(@user)
    allow(controller).to receive(:user_logged_in?).and_return(true)
  end

  def stub_administrator_login
    @administrator = mock_model(Administrator)
    allow(controller).to receive(:current_administrator).and_return(@administrator)
    allow(controller).to receive(:administrator_logged_in?).and_return(true)

    allow(controller).to receive(:ensure_administration_subdomain).and_return(true)
  end

  def stub_generate_pdf
    @pdfkit = double('PDFKit instance', :stylesheets => [], :to_pdf => nil)
    allow(PDFKit).to receive(:new).and_return(@pdfkit)
  end

  def expect_controller_to_generate_pdf
    expect(@pdfkit).to receive(:to_pdf)
  end
end
