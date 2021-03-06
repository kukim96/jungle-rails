require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(first_name: "Daniel", last_name: "Kim", email: "kukim96@gmail.com", password: "supersecret", password_confirmation: "supersecret")
  }
  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end

    it "is not valid if password and password_confirmation don't match each other" do
      subject.password_confirmation = "superdupersecret"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Password confirmation doesn't match Password"
    end

    it "is not valid when email isn't unique (not case sensitive)" do
      same_as_subject = User.create(first_name: "Daniel", last_name: "Kim", email: "KUKIM96@gmail.com", password: "supersecret", password_confirmation: "supersecret")
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Email has already been taken"
    end

    it "is not valid without first name" do
      subject.first_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "First name can't be blank"
    end

    it "is not valid without last name" do
      subject.last_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Last name can't be blank"
    end

    it "is not valid without email" do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Email can't be blank"
    end

    it "is not valid without password" do 
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Password can't be blank"
    end

    it "is not valid without password confirmation" do
      subject.password_confirmation = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages). to include "Password confirmation can't be blank"
    end

    it "is not valid when password is shorter than 8 characters" do
      subject.password = "1234567"
      subject.password_confirmation = "1234567"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Password is too short (minimum is 8 characters)"
    end

    it "is valid when password is exactly 8 characters" do
      subject.password = "12345678"
      subject.password_confirmation = "12345678"
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end
  end

  describe '.authenticate_with_credentials' do
    it "authenticates when credentials are valid" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, subject.password)
      expect(auth).to eq subject
    end

    it "doesn't authenticate when email is incorrect" do
      subject.save!
      auth = User.authenticate_with_credentials("incorrect@gmail.com", subject.password)
      expect(auth).to eq nil
    end

    it "doesn't authenticate when password is incorrect" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, "supersecrett")
      expect(auth).to eq nil
    end

    it "authenticates when email is correct but has whitespaces surrounding it" do
      subject.save!
      auth = User.authenticate_with_credentials("   " + subject.email + "   ", subject.password)
      expect(auth).to eq subject
    end

    it "authenticates when email is correct but has wrong case" do
      subject.save!
      auth = User.authenticate_with_credentials("KUKIM96@GMAIL.COm", subject.password)
      expect(auth).to eq subject
    end
  end
end