require 'one_click_orgs/user_authentication'

class Administrator < ActiveRecord::Base
  include OneClickOrgs::UserAuthentication
end
