module LoginSupport

  def login_set_user_seed(create_records, do_logout = false)
    @test_user = FactoryGirl.create(:user)
    test_log_in(@test_user)

    if create_records.include?(:customer)
      [0..5].each do
        c = FactoryGirl.create(:customer)
        if create_records.include?(:company_avatar)
          #### prepare attachment
          att = Paperclip::Attachment.new(:avatar, @customer, {
              default_url: '/images/:style/missing.png',
              path: ":rails_root/public/system/:attachment/:id/:style/:filename",
              url: "/system/:attachment/:id/:style/:filename"
          });
          c.company_avatar = CompanyAvatar.create(:avatar => att)
        end
        if create_records.include?(:contact)
          [0..5].times do
            c.contacts.create(:name => 'Contact', :city => 'Vienna', :street => 'street', :zip => '1210', :country => 'AUT')
          end
        end
        c.save!
      end
    end

    @test_customer = Customer.last
    if do_logout
      test_log_out(@test_user)
    end
  end

end