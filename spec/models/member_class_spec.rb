require 'spec_helper'

describe MemberClass do
  describe "permissions" do
    before(:each) do
      @organisation = Organisation.make
      @member_class = @organisation.member_classes.make(:name => 'Clown')
    end
    
    describe "checking permissions" do
      it "returns false when the permission clause does not exist" do
        @member_class.has_permission(:whatever).should be_false
      end
      
      it "looks up the correct permissions clause" do
        @organisation.clauses.create(:name => 'permission_clown_cartwheel', :boolean_value => true)
        
        @member_class.has_permission(:cartwheel).should be_true
      end
    end
    
    describe "setting permissions" do
      it "sets the correct permissions clause" do
        @member_class.set_permission!(:juggle, true)
        @organisation.clauses.get_boolean(:permission_clown_juggle).should be_true
      end
    end
    
    describe "destroying" do
      it "destroys related permissions clauses when it is destroyed" do
        @member_class.set_permission!(:cartwheel, true)
        @member_class.set_permission!(:lion_tame, false)
        
        @organisation.clauses.where(:name => 'permission_clown_cartwheel').should_not be_empty
        @organisation.clauses.where(:name => 'permission_clown_lion_tame').should_not be_empty
        
        @member_class.destroy
        
        @organisation.clauses.where(:name => 'permission_clown_cartwheel').should be_empty
        @organisation.clauses.where(:name => 'permission_clown_lion_tame').should be_empty
      end
    end
  end
end
