# TypedClass

## Intended Audience

Ruby developers who prefer a few tools that provide strong type
checking. This is particularly useful if you are working in a larger
ruby codebase.

## Purpose

TypedClass provides a strongly typed class for ruby. The classes are
very simple to define and provide immutable classes with convenient
constructors and very strong type validation for values.

Note that TypedClasses can only inherit from the class TypedClass. See
examples/inheritance.rb for more information.

## Installation

  gem install typed_class
  require 'typed_class'

## Simple Example

    class User < TypedClass

      field :user_id, Integer
      field :email, String

    end

    user = User.new(123, "mb@gilt.com")
    puts "Hello user_id[%s] with email[%s]" % [user.user_id, user.email]

    => Hello user_id[123] with email[mb@gilt.com]

## Example with optional fields and defaults

    class User < TypedClass

      field :user_id, Integer
      field :email, String
      field :name, option(String)
      field :gender, option(String), :default => 'Unknown'

    end

    user = User.new(123, "mb@gilt.com", :name => "Mike")
    puts user.inspect
    => #<User:0x10266be28 @name="Mike", @user_id=123, @email="mb@gilt.com", @gender="Unknown">

## Example with post instance initialization

    class User < TypedClass

      field :user_id, Integer
      field :email, String

      after_initialize do
        puts "Hello user_id[%s] email[%s]" % [user_id, email]
        if email == ""
          raise "Email cannot be blank"
        end
      end

    end

    User.new(123, "mb@gilt.com")
    => Hello user_id[123] email[mb@gilt.com]
    => #<User:0x1026030f8 @name=nil, @user_id=123, @email="mb@gilt.com", @gender="Unknown">

## More Examples

More examples can be found in the examples directory.

## License

Copyright 2013 Gilt Groupe, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
