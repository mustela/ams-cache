class String
  def to_constant
    Object.const_get(self)
  end
end

class Symbol
  def to_constant
    to_s.classify.to_constant
  end
end
