class RemoveTwoFactorColumnsFromUsers < ActiveRecord::Migration[8.1]
  def up
    refuse_if_legacy_users_still_enrolled!

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

  private

  # devise-two-factor stored the OTP secret encrypted with Rails' key generator,
  # which the new two_factor_authentications table cannot decrypt. If any user
  # still relies on the legacy flow we refuse the migration so the maintainer
  # makes a conscious decision instead of silently disabling 2FA for them.
  def refuse_if_legacy_users_still_enrolled!
    return unless column_exists?(:users, :otp_required_for_login)

    legacy_count = ActiveRecord::Base.connection.select_value(
      "SELECT COUNT(*) FROM users WHERE otp_required_for_login = TRUE"
    ).to_i
    return if legacy_count.zero?
    return if ENV["FORCE_DROP_LEGACY_TWO_FACTOR"] == "true"

    raise <<~MESSAGE
      Refusing to drop legacy 2FA columns: #{legacy_count} user(s) still have
      otp_required_for_login = TRUE. Their TOTP secrets cannot be carried into
      the new two_factor_authentications table.

      Resolve before re-running:
        (a) Force-reset those users (set otp_required_for_login = FALSE and
            clear otp_secret / otp_backup_codes) and ask them to re-enrol
            after this migration, or
        (b) Re-run with FORCE_DROP_LEGACY_TWO_FACTOR=true to drop the columns
            anyway and silently disable 2FA for those users.
    MESSAGE
  end
end
