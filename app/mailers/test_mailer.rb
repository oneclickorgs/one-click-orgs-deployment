class TestMailer < OcoMailer
  def test_email(address, token=nil)
    mail(:to => address, :subject => "Test email", :from => "<notifications@oneclickorgs.com>") do |format|
      format.text { render :text => "testing: #{Time.now}\ntoken: #{token}" }
    end
  end
end
