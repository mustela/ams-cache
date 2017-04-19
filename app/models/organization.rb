class Organization < ApplicationRecord
  default_scope { order(name: :asc) }

  with_options inverse_of: :organization, dependent: :destroy do
    has_many :memberships
  end
  has_many :users, through: :memberships
end
