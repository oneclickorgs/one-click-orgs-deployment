# encoding: UTF-8

require 'rails_helper'

describe "documents" do

  describe "Coop Rules" do
    let(:constitution) {coop.constitution}
    let(:coop) {Coop.make!}

    it "includes the Board composition subrule for a membership with class with at least one member on the Board" do
      coop.employee_members = true
      coop.max_employee_directors = 2

      expect(constitution.document.to_html).to include("Not more than 2 Employee Members")
    end

    it "hides the Board composition subrule for a membership class with 0 members on the Board" do
      coop.user_members = true
      coop.max_user_directors = 0

      expect(constitution.document.to_html).to_not include("Not more than 0 User Members")
    end
  end

end
