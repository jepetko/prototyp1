module CustomersHelper

  def get_avatar_img(customer, type)
    unless customer.nil?
      if not customer.company_avatar.nil?
        return image_tag customer.company_avatar.avatar.url(type)
      end
    end
    ''
  end

end
