require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "is valid with valid attributes" do
      user = User.create(first_name: "Daniel", last_name: "Kim", email: "kukim96@gmail.com", password: "supersecret", password_confirmation: "supersecret")
      expect(user).to be_valid
      expect(user.errors.full_messages).to be_empty
    end

    it "is not valid if password and password_confirmation don't match each other" do
      user = User.create(first_name: "Lighthouse", last_name: "Labs", email: "lighthouselabs@gmail.com", password: "testpw", password_confirmation: "testpw1")
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include "Password confirmation doesn't match Password"
    end

    it "is not valid when email isn't unique (not case sensitive)" do
      user = User.create(first_name: "Hello", last_name: "World", email: "helloworld@gmail.com", password: "secretpw1", password_confirmation: "secretpw1")
      same_user = User.create(first_name: "Hello", last_name: "World", email: "HelloWorld@gmail.com", password: "secretpw1", password_confirmation: "secretpw1")
      expect(same_user).to_not be_valid
      expect(same_user.errors.full_messages).to include "Email has already been taken"
    end
  end
end