require_relative 'FakedExampleGenerator'

class ExampleDataProcessor

  include FakedExampleGenerator

  def hello
    puts self.methods.grep /customer/
  end

end

p = ExampleDataProcessor.new
p.hello