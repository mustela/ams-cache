class OrganizationSerializer < AbstractSerializer
  attributes :name

  has_many :memberships
end
