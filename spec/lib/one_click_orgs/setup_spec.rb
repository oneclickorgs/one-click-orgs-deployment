require 'spec_helper'

describe OneClickOrgs::Setup do

  describe '#complete?' do
    it 'returns false if no organisation type is selected' do
      Setting[:base_domain] = 'example.com'
      Setting[:signup_domain] = 'create.example.com'
      expect(OneClickOrgs::Setup.complete?).to be false
    end
  end

end
