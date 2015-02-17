require 'rails_helper'

describe Organisation do
  before(:each) do
    @organisation = Organisation.make!(:name => 'abc', :subdomain => 'fromage')
    Setting[:base_domain] = 'oneclickorgs.com'
  end
  
  describe "associations" do
    it "has many resignations" do
      @resignation = Resignation.make!
      @member = Member.make!
      
      @organisation.members << @member
      @member.resignations << @resignation
      
      expect(@organisation.resignations).to include(@resignation)
    end
  end
  
  describe "validation" do
    it "should not allow multiple organisations with the same subdomain" do
      @first = Organisation.make!(:name => 'abc', :subdomain => "apples")

      expect do
        @second = Organisation.make!(:name => 'def', :subdomain => "apples")
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it "does not allow subdomains with invalid characters" do
      @organisation.subdomain = "abcdef-190"
      expect(@organisation).to be_valid
      
      # Null byte
      @organisation.subdomain = "\0abcdef-190"
      expect(@organisation).not_to be_valid
      expect(@organisation.errors[:subdomain]).to be_present
    end
  end
  
  describe "text fields" do
    before(:each) do
      @organisation.name = 'The Cheese Collective' # actually stored as 'organisation_name'
      @organisation.save!
      @organisation.reload
    end
    
    it "should get the name of the organisation" do
      expect(@organisation.name).to eq("The Cheese Collective")
    end

    it "should change the name of the organisation" do
      expect {
        @organisation.name = "The Yoghurt Yurt"
        @organisation.save!
        @organisation.reload
      }.to change(Clause, :count).by(1)
      expect(@organisation.name).to eq("The Yoghurt Yurt")
    end
  end
  
  describe "domain" do
    it "should return the root URL for this organisation" do
      expect(@organisation.domain).to eq("http://fromage.oneclickorgs.com")
    end
    
    context "with only_host option true" do
      it "should remove the http://" do
        expect(@organisation.domain(:only_host => true)).to eq("fromage.oneclickorgs.com")
      end
    end
    
    context "in single-organisation mode" do
      before(:each) do
        Setting[:single_organisation_mode] = "true"
      end
      
      it "returns the base domain" do
        expect(@organisation.domain).to eq("http://oneclickorgs.com")
      end
    end
  end

  it "has a 'constitution_clause_names' method" do
    expect{Organisation.new.constitution_clause_names}.to_not raise_error
  end
  
end
