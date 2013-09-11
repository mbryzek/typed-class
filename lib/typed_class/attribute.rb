module TypedClassInternal

  class Attribute

    attr_reader :name, :klass, :default

    def initialize(name, klass, opts={})
      @name = Util.assert_class(name, Symbol)
      @klass = Util.assert_class(klass, Class)
      @optional = opts.delete(:optional)
      @default = Util.assert_class_or_nil(opts.delete(:default), @klass)

      if !@default.nil?
        Util.check_state(@optional.nil? || @optional,
                         "Attribute for klass[%s] with name[%s] has a default - it MUST be optional[%s]" % [@klass, @name, @optional])
        @optional = true
      end
      if @optional.nil?
        @optional = false
      end
      Util.assert_empty_opts(opts)
    end

    def optional?
      @optional
    end

  end

end
