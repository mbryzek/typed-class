# To use, extend TypedClass directly
class MyClass < TypedClass

end

# But you cannot extend a subclass of TypedClass
# This is because it becomes unclear how to properly and fully
# initialize the object, and rather than deal with this situation, we
# just detect it and raise an immediate error.
begin
  class AnotherClass < MyClass
  end
rescue Exception => e
  # Class must extend TypedClass directly
  puts e.to_s
end
