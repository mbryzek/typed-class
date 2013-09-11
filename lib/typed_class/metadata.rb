module TypedClassInternal

  class Metadata

    attr_reader :klass, :attributes, :after_initialize

    def initialize(klass)
      @klass = Util.assert_class(klass, Class)

      @attributes = []
      @after_initialize = []
      @defaults = {}
    end

    def add_attribute(attribute)
      Util.assert_class(attribute, TypedClassInternal::Attribute)

      # We have to delete the attribute. In Ruby, the class can always
      # be re-opened in which case it is possible to redefine a given
      # field.
      @attributes.delete_if { |a| a.name == attribute.name }

      @attributes << attribute
      if attribute.default
        @defaults[attribute.name] = attribute.default
      end
    end

    def add_after_initialize(block)
      @after_initialize << block
    end

    def get_default(attr_name)
      Util.assert_class(attr_name, Symbol)
      @defaults[attr_name]
    end

    def klass_name
      @klass.to_s
    end

  end

end
