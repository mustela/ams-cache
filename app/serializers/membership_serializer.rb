class MembershipSerializer < AbstractSerializer
  attributes :owner, :user_id, :organization_id

  has_one :user
  has_one :organization
end
