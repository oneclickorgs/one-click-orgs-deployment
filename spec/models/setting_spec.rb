require 'rails_helper'

describe Setting do
  before(:each) do
    Setting.make!(:key => "base_domain", :value => "oneclickorgs.com")
  end
  
  describe "when getting" do
    it "should return the value for an existing key" do
      expect(Setting[:base_domain]).to eq("oneclickorgs.com")
    end
    
    it "should return nil for a non-existent key" do
      expect(Setting[:kwyjibo]).to be_nil
    end
  end
  
  describe "when setting" do
    it "should create a new setting for a new key" do
      expect{Setting[:new_key] = "new_value"}.to change(Setting, :count).by(1)
      expect(Setting[:new_key]).to eq("new_value")
    end
    
    it "should update an existing setting for an existing key" do
      expect{Setting[:base_domain] = "google.com"}.not_to change(Setting, :count)
      expect(Setting[:base_domain]).to eq("google.com")
    end
  end
end
