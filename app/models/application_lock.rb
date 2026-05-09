class ApplicationLock < ApplicationRecord
  has_secure_password :pin, validations: false

  belongs_to :user

  validates :user_id, uniqueness: true
  validates :pin_digest, presence: true

  def self.normalize_pin(pin) = pin.to_s.strip

  def pin=(value)
    super(self.class.normalize_pin(value))
  end

  def authenticate_pin(value)
    super(self.class.normalize_pin(value))
  end

  def as_json(_options = {})
    {
      enabled: true,
      created_at: created_at.iso8601(3)
    }
  end
end
