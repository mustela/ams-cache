class UserSerializer < AbstractSerializer
  cache key: 'moco'
  attributes :first_name, :last_name

  has_many :memberships
  has_many :organizations
end
