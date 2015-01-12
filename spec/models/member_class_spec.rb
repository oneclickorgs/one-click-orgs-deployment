require 'spec_helper'

describe MemberClass do
  describe "permissions" do
    before(:each) do
      @organisation = Organisation.make!
      @member_class = @organisation.member_classes.make!(:name => 'Clown')
    end
    
    describe "checking permissions" do
      it "returns false when the permission clause does not exist" do
        expect(@member_class.has_permission(:whatever)).to be false
      end
      
      it "looks up the correct permissions clause" do
        @organisation.clauses.create(:name => 'permission_clown_cartwheel', :boolean_value => true)
        
        expect(@member_class.has_permission(:cartwheel)).to be true
      end
    end
    
    describe "setting permissions" do
      it "sets the correct permissions clause" do
        @member_class.set_permission!(:juggle, true)
        expect(@organisation.clauses.get_boolean(:permission_clown_juggle)).to be true
      end
    end
    
    describe "destroying" do
      it "destroys related permissions clauses when it is destroyed" do
        @member_class.set_permission!(:cartwheel, true)
        @member_class.set_permission!(:lion_tame, false)
        
        expect(@organisation.clauses.where(:name => 'permission_clown_cartwheel')).not_to be_empty
        expect(@organisation.clauses.where(:name => 'permission_clown_lion_tame')).not_to be_empty
        
        @member_class.destroy
        
        expect(@organisation.clauses.where(:name => 'permission_clown_cartwheel')).to be_empty
        expect(@organisation.clauses.where(:name => 'permission_clown_lion_tame')).to be_empty
      end
    end
  end
end
