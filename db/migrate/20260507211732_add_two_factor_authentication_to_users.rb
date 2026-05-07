# frozen_string_literal: true

class AddTwoFactorAuthenticationToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :otp_secret, :string
    add_column :users, :consumed_timestep, :integer
    add_column :users, :otp_required_for_login, :boolean, null: false, default: false
    add_column :users, :otp_backup_codes, :string, array: true, default: [], null: false
  end
end
