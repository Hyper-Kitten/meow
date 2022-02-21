require 'rails_helper'

RSpec.describe HyperKitten::Meow::User, type: :model do
  describe "email validation" do
    it "allows a valid email address" do
      user = build(:user, email: "a@a.com")

      expect(user).to be_valid
    end

    it "doesn't allow an invalid email address" do
      user = build(:user, email: "a@a")

      expect(user).to_not be_valid
    end
  end
end
