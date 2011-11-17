require 'spec_helper'

describe 'member_sessions/new' do
  
  it "turns autocomplete off for the login form" do
    render
    rendered.should have_selector("form[action='/member_session'][autocomplete='off']")
  end
  
end
