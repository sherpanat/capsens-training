require 'rails_helper'
require 'dry/transaction'
require_relative '../../../app/transactions/users/create_transaction'

RSpec.describe "User::CreateTransaction", type: :transaction do
  context "Create a user" do
    it "should create a user if valid attributes given" do
      ::Users::CreateTransaction.call(valid_user_attributes)
      expect(User.last).to be_an_instance_of User
    end

    it "should not create a user if invalid attributes given" do
      create(:user, email: 'nathan.patreau@capsens.fr')
      user_count = User.count
      ::Users::CreateTransaction.call(invalid_user_attributes)
      new_user_count = User.count
      expect(new_user_count).to eq user_count
      # expect(User.last).to be nil
    end

    it "create a user" do

    end
  end

  context "Send welcome mail" do
  end

  def valid_user_attributes
    {
      first_name: 'Nathan',
      last_name: 'Patreau',
      email: 'nathan.patreau@capsens.fr',
      birthdate: '08/09/1998',
      password: '12345678'
    }
  end

  def invalid_user_attributes
    {
      last_name: 'Patreau',
      email: 'nathan.patreau@capsens.fr',
      birthdate: '08/09/1998',
      password: '12345678'
    }
  end
end
