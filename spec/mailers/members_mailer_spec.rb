require 'rails_helper'

describe MembersMailer do
  before :each do
    default_association_constitution
    default_organisation
    
    @member = @organisation.members.make!
    @new_password = "foo"
  end
  
  describe "password_reset" do
    before do
      @member.update_attribute(:password_reset_code, 'abcdef')
      @mail = MembersMailer.password_reset(@member)
    end
      
    it "should include welcome phrase in email text" do    
      expect(@mail.body).to match(/Dear #{@member.name}/)
    end
  
    it "should include reset password link in email text" do
      expect(@mail.body).to match(Regexp.new("http://#{@organisation.subdomain}.oneclickorgs.com/r/abcdef"))
    end
  end
  
  describe "welcome_new_member" do
    before do
      @member.update_attribute(:invitation_code, "abcdef")
      @mail = MembersMailer.welcome_new_member(@member)
    end
    
    it "should include welcome phrase in email text" do          
      expect(@mail.body).to match(/Dear #{@member.name}/)
    end
  
    it "should include invitation link in email text" do
      expect(@mail.body).to match(Regexp.new("http://#{@organisation.subdomain}.oneclickorgs.com/i/abcdef"))
    end
  end
  
  describe "notify_resignation" do
    before(:each) do
      @recipient = @organisation.members.make!
      @resignee = @organisation.members.make!
      
      @mail = MembersMailer.notify_resignation(@recipient, @resignee)
    end
    
    it "addresses the email to the recipient" do
      expect(@mail.to).to eq([@recipient.email])
    end
    
    it "includes the name of the resignee in the subject" do
      expect(@mail.subject).to match(Regexp.new(@resignee.name))
    end
    
    it "includes the name of the resignee in the body" do
      expect(@mail.body).to match(Regexp.new(@resignee.name))
    end
  end
end
