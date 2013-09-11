module TestUtil

  module GeneratedTestClasses; end;

  @@counter = 0

  # Internal test helper. Takes a string and creates an instance of a
  # class that extends TypedClass. Returns the class object
  def TestUtil.define_class(body, opts={})
    name = TypedClassInternal::Util.assert_class_or_nil(opts.delete(:name), String)
    TypedClassInternal::Util.assert_empty_opts(opts)

    if name.nil?
      @@counter += 1
      name = "TestUtil::GeneratedTestClasses::Test#{@@counter}"
    end

    s = "class #{name} < TypedClass\n"
    s << "  " + body
    s << "\nend"

    eval(s)
    eval(name)
  end

end
