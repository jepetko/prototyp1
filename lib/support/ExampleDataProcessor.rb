require_relative 'FakedExampleGenerator'
require_relative 'CSVExampleGenerator'


class ExampleDataProcessor


  def self.populate(files = nil)
    if files.nil?
      extend FakedExampleGenerator
      self.create_users
      self.create_customers
    else
      extend CSVExampleGenerator
      self.create_users(files[:users]) if !files[:users].nil?
      self.create_customers(files[:customers]) if !files[:customers].nil?
    end
  end

end