require File.dirname(__FILE__) + '/../init'

describe "we have good error messages" do

  it "Validates option hash" do
    klass = TestUtil.define_class("field :age, option(Integer)")
    lambda {
      klass.new(5)
    }.should raise_error(RuntimeError, 'Expected a hash of name/value pairs but got an argument of type[Fixnum]')
  end

  it "Simple type error" do
    klass = TestUtil.define_class("field :age, Integer")
    lambda {
      klass.new("5")
    }.should raise_error(RuntimeError, 'Value is of type[String] - class[Integer] is required. value["5"]')
  end

end
