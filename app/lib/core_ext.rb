class Hash
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      public_send(*a, &b) if respond_to?(a.first)
    end
  end
  
  def slice(*keys)
    select{|k| keys.member?(k)}
  end
end
