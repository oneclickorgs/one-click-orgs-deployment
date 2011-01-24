class AdminController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:test_email]
  skip_before_filter :ensure_authenticated, :only => [:test_email]
  skip_before_filter :prepare_notifications, :only => [:test_email]

  def test_email
    if params[:address].blank?
      render :text => "ERROR", :status => 400
    else
      TestMailer.test_email(params[:address], params[:token]).deliver
      render :text => "OK"
    end
  end
end

