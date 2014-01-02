require 'spec_helper'

describe OcoMailer do
  
  class SpecMailer < OcoMailer
    def notification(organisation_name="One Click Orgs")
      create_mail(organisation_name, 'bob@example.com', "Example subject")
    end
  end
  
  it "quotes and escapes the 'From:' display name if necessary" do
    mail = SpecMailer.notification('Bad Company Name"')
    mail['From'].to_s.should == '"Bad Company Name\\"" <no-reply@oneclickorgs.com>'
  end
  
end
