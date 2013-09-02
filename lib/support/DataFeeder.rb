module DataFeeder

  def create(clazz,hash)
    puts "Creating object of class #{clazz}"
    Object.const_get(clazz).create! hash
  end

  def get_avatar_file
    "#{Rails.root}/lib/assets/images/logo_#{Random.rand(1..25)}.png"
  end

  def add_avatar(customer)
    file_name = get_avatar_file
    customer.company_avatar = CompanyAvatar.new
    customer.company_avatar.avatar = File.new(file_name)
    customer.save!
  end

  def create_customer(hash)
    customer = hash.select do |key|
      [:name, :street, :zip, :city, :country, :latlon].include?(key)
    end
    self.create 'Customer', customer
  end

  def create_user(hash)
    user = hash.select do |key|
      [:name, :email, :password, :password_confirmation].include?(key)
    end
    self.create 'User', user
  end

end