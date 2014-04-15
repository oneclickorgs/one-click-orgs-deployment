require 'one_click_orgs/user_authentication'

class Administrator < ActiveRecord::Base
  include OneClickOrgs::UserAuthentication

  attr_accessible :email, :password, :password_confirmation
end
