class AbstractSerializer < ActiveModel::Serializer
  cache key: self.class.name, expires_in: 60.minutes

  attributes :id
end
