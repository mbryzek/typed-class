module TypedClassInternal

  module Util

    # Throws an error if opts is not empty. Useful when parsing
    # arguments to a function
    def Util.assert_empty_opts(opts)
      Util.check_state(opts.empty?,
                       "Invalid opts: %s\n%s" % [opts.keys.inspect, opts.inspect])
    end

    def Util.assert_class(value, klass)
      Util.check_not_nil(value, "Value cannot be nil")
      Util.check_not_nil(klass, "Klass cannot be nil")
      Util.check_state(value.is_a?(klass),
                       "Value is of type[#{value.class}] - class[#{klass}] is required. value[#{value.inspect}]")
      value
    end

    def Util.assert_class_or_nil(value, klass)
      if !value.nil?
        Util.assert_class(value, klass)
      end
      value
    end

    def Util.check_state(expression, error_message=nil)
      if expression.nil? || !expression
        raise error_message || "check_state failed"
      end
      nil
    end

    def Util.check_not_nil(reference, error_message=nil)
      if reference.nil?
        raise error_message || "argument cannot be nil"
      end
      reference
    end

    def Util.check_not_blank(reference, error_message=nil)
      if reference.to_s.empty?
        raise error_message || "argument cannot be blank"
      end
      reference
    end

  end

end
