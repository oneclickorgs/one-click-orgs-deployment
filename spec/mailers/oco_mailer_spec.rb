# encoding: UTF-8

require 'spec_helper'

describe OcoMailer do
  
  class SpecMailer < OcoMailer
    def notification(organisation_name="My Organisation")
      create_mail(organisation_name, 'bob@example.com', "Example subject")
    end
  end

  it "sets the 'From' name to 'One Click Orgs'" do
    mail = SpecMailer.notification
    mail['From'].to_s.should include('One Click Orgs')
  end

  it "includes the organisation name in the subject" do
    mail = SpecMailer.notification
    mail['Subject'].to_s.should == '[My Organisation] Example subject'
  end
  
  it "cleans the organisation name in the subject if necessary" do
    mail = SpecMailer.notification("Bad Company Name\r\n 団体")
    mail['Subject'].to_s.should == '[Bad Company Name   ] Example subject'
  end
  
end
