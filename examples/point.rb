class Point < TypedClass

  field :x, Integer
  field :y, Integer

  def to_label
    "[%s, %s]" % [x, y]
  end

end

puts Point.new(5, 10).to_label
# => [5, 10]

puts Point.new(500, 100).to_label
# => [500, 100]

begin
  Point.new(5)
rescue Exception => e
  # wrong number of arguments (1 for 2)
  puts e.to_s
end

begin
  Point.new(5, '10')
rescue Exception => e
  # Value is of type[String] - class[Integer] is required. value["10"]
  puts e.to_s
end
