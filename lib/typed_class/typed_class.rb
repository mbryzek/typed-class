class TypedClass

  @@map = {}

  def after_initialize
    metadata = @@map[self.class.to_s.to_sym]
    ::TypedClassInternal::Util.check_state(metadata, "No metadata for class[%s]" % self.class)
    metadata.after_initialize.each do |block|
      instance_eval(&block)
    end
  end

  def TypedClass.inherited(child)
    ::TypedClassInternal::Util.assert_class(child, Class)
    ::TypedClassInternal::Util.check_state(child.superclass == TypedClass,
                                               "Class must extend TypedClass directly")

    @@metadata = @@map[child.to_s.to_sym]
    if @@metadata.nil?
      @@map[child.to_s.to_sym] = @@metadata = TypedClassInternal::Metadata.new(child)
    end
  end

  def TypedClass.after_initialize(&block)
    ::TypedClassInternal::Util.check_not_nil(@@metadata, "metadata not defined")
    @@metadata.add_after_initialize(block)
    TypedClass.rewrite_constructor(@@metadata)
  end

  def TypedClass.field(attr_name, attr_klass, opts={})
    metadata = @@map[self.to_s.to_sym]
    ::TypedClassInternal::Util.check_state(metadata, "No metadata for klass[%s]" % self)
    ::TypedClassInternal::Util.assert_class(attr_name, Symbol)
    default = opts.delete(:default)
    ::TypedClassInternal::Util.assert_empty_opts(opts)

    if attr_klass.is_a?(Class)
      klass = attr_klass
      optional = false
    else
      ::TypedClassInternal::Util.assert_class(attr_klass, ::TypedClassInternal::Option)
      klass = attr_klass.klass
      optional = true
    end

    if default
      ::TypedClassInternal::Util.assert_class(default, klass)
    end
    ::TypedClassInternal::Util.check_state(default.nil? || optional,
                                               "Required fields cannot have defaults. Class[%s] Field[%s] Default[%s]" % [klass.name, attr_name, default])

    attr = ::TypedClassInternal::Attribute.new(attr_name, klass, :default => default, :optional => optional)
    metadata.add_attribute(attr)
    TypedClass.rewrite_constructor(metadata)
  end

  def TypedClass.get_default(klass, attr_name)
    ::TypedClassInternal::Util.assert_class(klass, Class)
    ::TypedClassInternal::Util.assert_class(attr_name, Symbol)
    metadata = @@map[klass.to_s.to_sym]
    ::TypedClassInternal::Util.check_state(metadata, "No metadata for klass[%s]" % klass)
    metadata.get_default(attr_name)
  end

  def TypedClass.option(klass)
    ::TypedClassInternal::Option.new(klass)
  end

  def TypedClass.rewrite_constructor(metadata)
    s = TypedClass.constructor_string(metadata)
    metadata.klass.class_eval s
  end

  def TypedClass.constructor_string(metadata)
    ::TypedClassInternal::Util.assert_class(metadata, ::TypedClassInternal::Metadata)

    required_params = []
    init_body = ""
    have_options = false

    metadata.attributes.each do |attr|
      if attr.optional?
        have_options = true
        init_body << "    @%s = ::TypedClassInternal::Util.assert_class_or_nil(opts.delete(:%s), %s)" % [attr.name, attr.name, attr.klass.to_s]
      else
        required_params << attr.name.to_s
        init_body << "    @%s = ::TypedClassInternal::Util.assert_class(%s, %s)" % [attr.name, attr.name, attr.klass.to_s]
      end

      if metadata.get_default(attr.name)
        init_body << " || ::TypedClass.get_default(%s, :%s)" % [metadata.klass.to_s, attr.name]
      end
      init_body << "\n"
    end

    s = ""
    if !metadata.attributes.empty?
      s = "  attr_reader :%s\n" % [metadata.attributes.map(&:name).join(", :")]
    end

    s << "  def initialize(%s" % [required_params.join(", ")]
    if have_options
      if !required_params.empty?
        s << ", "
      end
      s << "opts={}"
      init_body << "    ::TypedClassInternal::Util.assert_empty_opts(opts)\n"

      assertion = "    ::TypedClassInternal::InstanceChecks.opts_must_be_a_hash(opts)\n"

      init_body = "%s\n%s" % [assertion, init_body]
    end
    s << ")\n"

    s << init_body

    if !metadata.after_initialize.empty?
      s << "    after_initialize\n"
    end

    s << "  end\n"

    s
  end

end
