class User < ApplicationRecord
  with_options inverse_of: :user, dependent: :destroy do
    has_many :memberships
  end
  has_many :organizations, through: :memberships
end
