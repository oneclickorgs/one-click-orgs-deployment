require "spec_helper"

describe CoopMailer do

  let(:administrator) {mock_model(Administrator)}

  before(:each) do
    set_up_app
  end

  describe "notify_founded" do
    let(:mail) {CoopMailer.notify_founded(member, coop)}

    let(:coop) {Coop.make!}
    let(:member) {coop.members.make!}

    it "has an appropriate subject" do
      mail.subject.should include(coop.name)
      mail.subject.should include('registration')
    end

    it "includes a link to the coop in the email body" do
      mail.body.should include("http://#{coop.subdomain}.oneclickorgs.com/")
    end
  end

  describe "notify_creation" do
    let(:mail) {CoopMailer.notify_creation(administrator, coop)}
    let(:coop) {mock_model(Coop, :name => 'The Co-op', :domain => 'coop')}

    it "mentions the Coop's name in the subject" do
      mail.subject.should include(coop.name)
    end

    it "contains a link to the admin coops page" do
      mail.body.should include("http://signup.oneclickorgs.com/admin/coops")
    end
  end

  describe "notify_proposed" do
    let(:mail) {CoopMailer.notify_proposed(administrator, coop)}
    let(:coop) {mock_model(Coop, :domain => 'coop', :name => 'The Co-op')}

    it "mentions the Coop's name in the subject" do
      mail.subject.should include(coop.name)
    end

    it "contains a link to the admin coops page" do
      mail.body.should include("http://signup.oneclickorgs.com/admin/coops")
    end
  end

end
