class RemoveTwoFactorColumnsFromUsers < ActiveRecord::Migration[8.1]
  def up
    remove_column :users, :otp_secret
    remove_column :users, :consumed_timestep
    remove_column :users, :otp_required_for_login
    remove_column :users, :otp_backup_codes
  end

  def down
    add_column :users, :otp_secret, :string
    add_column :users, :consumed_timestep, :integer
    add_column :users, :otp_required_for_login, :boolean, null: false, default: false
    add_column :users, :otp_backup_codes, :string, array: true, default: [], null: false
  end
end
