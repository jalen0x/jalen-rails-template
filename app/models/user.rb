class User < ApplicationRecord
  include Users::Authenticatable, Users::Profile, Users::SoftDelete
end
