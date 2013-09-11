require File.dirname(__FILE__) + '/../init'

describe "examples" do

  it "all examples run without error" do
    dir = File.join(File.dirname(__FILE__), '../../examples')
    Dir.glob("#{dir}/*.rb").sort.each do |file|
      eval(IO.read(file))
    end
  end

end

