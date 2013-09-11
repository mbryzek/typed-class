require File.dirname(__FILE__) + '/../init'

describe "readme" do

  class CodeBlock < TypedClass

    field :class_name, String
    field :code, String

  end

  def parse_readme
    file = File.join(File.dirname(__FILE__), '../../README.md')
    blocks = []
    class_name = nil
    block = nil

    IO.readlines(file).each do |l|
      if class_name
        block << l
      end

      if l.match(/^    /)
        if class_name
          if l.match(/^    end\s*/)
            blocks << CodeBlock.new(class_name, block)
            class_name = block = nil
          end
        elsif md = l.match(/^    class\s+(\w+)/)
          class_name = md[1]
          in_class = true
          block = l
        end
      end
    end

    blocks
  end

  it "can be parsed" do
    parse_readme.size.should == 3
  end

  it "examples generate valid classes" do
    parse_readme.each do |block|
      eval(block.code)
      eval(block.class_name)
    end
  end

  it "can create a user" do
    parse_readme.each do |block|
      eval(block.code)
    end
    u = User.new(1, "test@gilt.com")
    u.user_id.should == 1
    u.email.should == "test@gilt.com"
  end

end
