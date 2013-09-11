class ExampleUser < TypedClass

  EMAIL_REGEXP = /^[\w\+-]+(\.[\w\+-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$/

  field :id, Integer
  field :email, String
  field :first_name, option(String)
  field :last_name, option(String)

  after_initialize do
    if email.strip.match(EMAIL_REGEXP).nil?
      raise "Invalid email address[%s]" % email
    end
  end

end

mike = ExampleUser.new(1, "mike@gilttest.com", :first_name => 'Michael', :last_name => 'Bryzek')
lisa = ExampleUser.new(2, "lisa@gilttest.com", :first_name => 'Lisa')

begin
  ExampleUser.new(3, "bademail")
rescue Exception => e
  # Invalid email address[bademail]
  puts e.to_s
end
