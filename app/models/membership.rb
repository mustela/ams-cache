class Membership < ApplicationRecord
  with_options inverse_of: :memberships do
    belongs_to :organization
    belongs_to :user
  end
end
