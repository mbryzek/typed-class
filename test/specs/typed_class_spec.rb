require File.dirname(__FILE__) + '/../init'

describe TypedClass do

  describe "only required attributes" do

    class TestUserWithRequiredAttributes < TypedClass
      field :user_id, Integer
      field :email, String
    end

    it "basic attributes work" do
      user = TestUserWithRequiredAttributes.new(5, "test@gilt.com")
      user.user_id.should == 5
      user.email.should == "test@gilt.com"
    end

    it "enforces type" do
      lambda {
        TestUserWithRequiredAttributes.new('5', "test@gilt.com")
      }.should raise_error(RuntimeError, 'Value is of type[String] - class[Integer] is required. value["5"]')

      lambda {
        TestUserWithRequiredAttributes.new(5, 1)
      }.should raise_error(RuntimeError, 'Value is of type[Fixnum] - class[String] is required. value[1]')

    end
  end

  describe "only optional attributes" do

    class TestUserWithOptionalAttributes < TypedClass
      field :user_id, option(Integer)
      field :email, option(String)
    end

    it "basic attributes work" do
      user = TestUserWithOptionalAttributes.new(:user_id => 5)
      user.user_id.should == 5
      user.email.should be_nil

      user = TestUserWithOptionalAttributes.new(:email => 'test@gilt.com')
      user.user_id.should be_nil
      user.email.should == 'test@gilt.com'

      user = TestUserWithOptionalAttributes.new(:user_id => 5, :email => 'test@gilt.com')
      user.user_id.should == 5
      user.email.should == 'test@gilt.com'
    end

    it "enforces type" do
      lambda {
        TestUserWithOptionalAttributes.new(:user_id => '5')
      }.should raise_error(RuntimeError, 'Value is of type[String] - class[Integer] is required. value["5"]')
    end
  end

  it "supports a class with no attributes" do
    klass = TestUtil.define_class("")
    klass.new
  end

  describe "defaults" do

    it "available on optional fields" do
      klass = TestUtil.define_class("field :age, option(Integer), :default => 5")
      person = klass.new
      person.age.should == 5

      person = klass.new(:age => 10)
      person.age.should == 10
    end

    it "can be an object itself" do
      klass = TestUtil.define_class("field :friends, option(Array), :default => ['Joey']")
      person = klass.new
      person.friends.should == ['Joey']

      person = klass.new(:friends => ['Sam'])
      person.friends.should == ['Sam']
    end

    it "raises error if specified for a required field" do
      lambda {
        TestUtil.define_class("field :email, String, :default => 'hi'")
      }.should raise_error(RuntimeError)
    end

  end

  it "redefining a class preserves last definition" do
    klass1 = TestUtil.define_class("field :user_id, Integer")
    klass1.new(5).user_id.should == 5

    klass2 = TestUtil.define_class("field :user_id, Integer", :name => klass1.name)
    klass2.new(5).user_id.should == 5

    klass3 = TestUtil.define_class("field :user_id, option(Integer)", :name => klass1.name)
    klass3.new.user_id.should be_nil
    klass3.new(:user_id => 12).user_id.should == 12

    klass4 = TestUtil.define_class("field :user_id, option(Integer), :default => 5", :name => klass1.name)
    klass4.new.user_id.should == 5
    klass4.new(:user_id => 12).user_id.should == 12
  end

  describe "Custom types" do

    module MyModule

      class Boolean

        attr_reader :value

        def initialize(input)
          if input.nil? || !input
            @value = false
          else
            @value = true
          end
        end

      end

    end

    it "allows our own defined type" do
      klass = TestUtil.define_class("field :is_registered, MyModule::Boolean")
      klass.new(MyModule::Boolean.new(true)).is_registered.value.should be_true
      klass.new(MyModule::Boolean.new(false)).is_registered.value.should be_false
    end

    it "allows our own defined type as an option" do
      klass = TestUtil.define_class("field :is_registered, option(MyModule::Boolean)")
      klass.new(:is_registered => MyModule::Boolean.new(true)).is_registered.value.should be_true
      klass.new(:is_registered => MyModule::Boolean.new(false)).is_registered.value.should be_false
    end

    it "allows our own defined type as an option with default" do
      klass = TestUtil.define_class("field :is_registered, option(MyModule::Boolean), :default => MyModule::Boolean.new(true)")
      klass.new.is_registered.value.should be_true
      klass.new(:is_registered => MyModule::Boolean.new(false)).is_registered.value.should be_false
    end

  end

  it "after_initialize" do
    DATA = []

    class TestClassForAfterInitialize < TypedClass
      field :age, Integer
      after_initialize do
        DATA << 1
      end
    end

    DATA.should == []
    TestClassForAfterInitialize.new(5)
    DATA.should == [1]
  end

  it "handles FalseClass" do
    klass = TestUtil.define_class("field :is_registered, FalseClass")
    klass.new(false).is_registered.should be_false

    lambda {
      klass.new(true)
    }.should raise_error(RuntimeError, "Value is of type[TrueClass] - class[FalseClass] is required. value[true]")

    lambda {
      klass.new(nil)
    }.should raise_error(RuntimeError, "Value cannot be nil")
  end

  it "handles TrueClass" do
    klass = TestUtil.define_class("field :is_registered, TrueClass")
    klass.new(true).is_registered.should be_true

    lambda {
      klass.new(false)
    }.should raise_error(RuntimeError, "Value is of type[FalseClass] - class[TrueClass] is required. value[false]")

    lambda {
      klass.new(nil)
    }.should raise_error(RuntimeError, "Value cannot be nil")
  end

  it "do not support inheritance" do
    klass = TestUtil.define_class("field :id, Integer")

    begin
      eval("class ChildClass < #{klass}; end")
      fail("no exception thrown")
    rescue Exception => e
      e.to_s.match(/Class must extend TypedClass directly/).should_not be_nil
    end
  end

end
