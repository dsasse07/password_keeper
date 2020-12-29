require 'pry'
class User
  
  attr_accessor :name, :type
  before_initialize: do 
    if self.type == "admin"
      User::Admin.new
    elsif self.type == "limited"
      User::Limited.new
    end







  class Limited
    def hello
      puts "hello, I am limited"
    end
  end

  class Admin < Limited
    def super_hello
      puts "I am an admin"
    end

    def make_new_admin 
    end
  end
  
end

binding.pry
0