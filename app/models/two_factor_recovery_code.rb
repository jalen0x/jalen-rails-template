class TwoFactorRecoveryCode < ApplicationRecord
  has_secure_password :code, validations: false

  belongs_to :user

  validates :code_digest, presence: true

  scope :unused, -> { where(used_at: nil) }

  def self.normalize(raw_code) = raw_code.to_s.strip.downcase.delete("-")

  def code=(value)
    super(self.class.normalize(value))
  end

  def authenticate_code(value)
    super(self.class.normalize(value))
  end

  def used? = used_at.present?

  def consume!(raw_code)
    return false if raw_code.blank?
    return false unless persisted?

    # Row lock so two concurrent challenges can't both consume the same code.
    with_lock do
      return false if used?
      return false unless authenticate_code(raw_code)

      update!(used_at: Time.current)
    end
  end
end
