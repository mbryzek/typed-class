require File.dirname(__FILE__) + '/../init'

describe "constructs clean code" do

  it "for single required attributes" do
    target = <<-eos
  attr_reader :user_id
  def initialize(user_id)
    @user_id = ::TypedClassInternal::Util.assert_class(user_id, Integer)
  end
eos

    klass = TestUtil.define_class("field :user_id, Integer")
    attr = TypedClassInternal::Attribute.new(:user_id, Integer)

    metadata = TypedClassInternal::Metadata.new(klass)
    metadata.add_attribute(attr)

    TypedClass.constructor_string(metadata).should == target
  end

  it "for single optional attributes with defaults" do
    klass = TestUtil.define_class("field :age, option(Integer), :default => 5")

    target = <<-eos
  attr_reader :age
  def initialize(opts={})
    ::TypedClassInternal::InstanceChecks.opts_must_be_a_hash(opts)

    @age = ::TypedClassInternal::Util.assert_class_or_nil(opts.delete(:age), Integer) || ::TypedClass.get_default(#{klass.name}, :age)
    ::TypedClassInternal::Util.assert_empty_opts(opts)
  end
eos

    attr = TypedClassInternal::Attribute.new(:age, Integer, :default => 5)
    metadata = TypedClassInternal::Metadata.new(klass)
    metadata.add_attribute(attr)

    TypedClass.constructor_string(metadata).should == target
  end

end
