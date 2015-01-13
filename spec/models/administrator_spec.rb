require 'rails_helper'

describe Administrator do

  describe 'mass-assignment' do
    it 'is allowed for email' do
      expect{Administrator.new(email: 'admin@example.com')}.to_not raise_error
    end

    it 'is allowed for password' do
      expect{Administrator.new(password: 'password')}.to_not raise_error
    end

    it 'is allowed for password_confirmation' do
      expect{Administrator.new(password_confirmation: 'password')}.to_not raise_error
    end
  end

end
