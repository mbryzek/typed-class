class Pagination < TypedClass

  field :limit, option(Integer), :default => 25
  field :offset, option(Integer), :default => 0

end

puts Pagination.new.inspect
puts Pagination.new(:limit => 10, :offset => 2).inspect
