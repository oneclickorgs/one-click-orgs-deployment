require "spec_helper"

describe CoopMailer do

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

end
