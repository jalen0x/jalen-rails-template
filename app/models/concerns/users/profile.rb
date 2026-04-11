module Users::Profile
  extend ActiveSupport::Concern

  included do
    has_person_name
    has_one_attached :avatar
  end
end
