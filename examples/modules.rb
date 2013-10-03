module Foo

  module Bar

    class FirstClass < TypedClass

      field :id, Integer

    end

  end

  module Baz

    class SecondClass < TypedClass

      field :id, Integer

    end

  end

  module Bar


    class FirstClass < TypedClass

      field :id, Integer
      field :name, String

    end

  end

end

Foo::Bar::FirstClass.new(1, 'mark')
Foo::Baz::SecondClass.new(1)
