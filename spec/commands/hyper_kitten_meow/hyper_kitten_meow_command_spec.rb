require 'rails_helper'
require "commands/hyper_kitten_meow_command"

RSpec.describe Command::HyperKittenMeowCommand do
  before(:each) do
    allow($stdout).to receive(:print)
    allow($stdout).to receive(:puts)
  end

  describe '#create_user' do
    it 'generates a new user when the proper options are provided' do
      allow(subject).
        to receive(:ask).with("What is your name?").and_return("Johnny")
      allow(subject).
        to receive(:ask).with("What is your email address?").
        and_return("johnny@appleseed.com")
      allow(subject).
        to receive(:ask).with("Please choose a password.", echo: false).
        and_return("1234567")
      allow(subject).
        to receive(:ask).with("Please confirm your password.", echo: false).
        and_return("1234567")

      subject.create_user
      user = HyperKittenMeow::User.last

      expect(user.name). to eq('Johnny')
      expect(user.email). to eq('johnny@appleseed.com')
    end

    it 'generates a useful error message when incorrectly used' do
        allow(subject).
          to receive(:ask).with("What is your name?").and_return("Johnny")
        allow(subject).
          to receive(:ask).with("What is your email address?").
          and_return("bademail")
        allow(subject).
          to receive(:ask).with("Please choose a password.", echo: false).
          and_return("1234567")
        allow(subject).
          to receive(:ask).with("Please confirm your password.", echo: false).
          and_return("1234567")

        expect { subject.create_user }.
          to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#list_users' do
    it 'lists all the current users' do
      user = create(:user, name: "Johnny")

      subject.list_users

      expect($stdout).to have_received(:puts).with(/Johnny/)
    end
  end

  describe '#delete_user' do
    it 'deletes a user by email' do
      create(:user, name: 'Johnny', email: 'johnny@appleseed.com')

      subject.delete_user('johnny@appleseed.com')

      expect(HyperKittenMeow::User.all).to be_empty
      expect($stdout).to have_received(:print).with(/Johnny/)
    end
  end
end
