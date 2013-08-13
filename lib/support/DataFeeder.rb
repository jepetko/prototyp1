module DataFeeder

  @proc = Proc.new do |clazz,hash|
    puts "Creating object of class #{clazz}"
    Object.const_get(clazz).create! hash
  end

  def create_customer(args)
    customer = args.select do |key, value|
      [:name, :street, :zip, :city, :country].include?(key)
    end
    @proc.call 'Customer', customer
  end

  def create_user(args)
    user = args.select do |key,value|
      [:name, :email, :password, :password_confirmation].include?(key)
    end
    @proc.call 'User', user
  end

end