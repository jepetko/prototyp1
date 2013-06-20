class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  ##################################
  #omniauth integration
  attr_accessible :provider, :uid

  #facebook integration
  devise :omniauthable, :omniauth_providers => [:facebook, :linkedin]

=begin
   2.) 2nd step: when coming back from the provider, the object auth is filled with lots of data, e.g.
  If there is already such a user this one is returned. Otherwise a user is created.
  --- !ruby/hash:OmniAuth::AuthHash
    provider: facebook
    uid: 'xxxx'
    info: !ruby/hash:OmniAuth::AuthHash::InfoHash
    nickname: humpty.dumpty
    email: humpty.dumpty@gmail.com
    name: Humpty Dumpty
    first_name: Humpty
    last_name: Dumpty
    image: http://graph.facebook.com/xxxx/picture?type=square
    urls: !ruby/hash:OmniAuth::AuthHash
    Facebook: http://www.facebook.com/katarina.golbang
    location: Vienna, Austria
    verified: true
    credentials: !ruby/hash:OmniAuth::AuthHash
    token: CAAB6gPa0CncBACM8nB2ZCNn5wwBLpk9Y2DJznyu074nDXCZBBWoISGOeQYFvrtCon2uZCPViQVwMRDXCn0ZBdvFZASTOHatoEPTiWopnC41GPN4RBBXXZCWXGYkOVJho0MOMp3B4S6akZBlOZCcpuZCJ
    expires_at: 1376906116
    expires: true
    extra: !ruby/hash:OmniAuth::AuthHash
    raw_info: !ruby/hash:OmniAuth::AuthHash
    id: '100006192394040'
    name: Humpty Dumpty
    first_name: Humpty
    last_name: Dumpty
    link: http://www.facebook.com/humpty.dumpty
    username: humpty.dumpty
    hometown: !ruby/hash:OmniAuth::AuthHash
    id: '111165112241092'
    name: Vienna, Austria
    location: !ruby/hash:OmniAuth::AuthHash
    id: '111165112241092'
    name: Vienna, Austria
    education:
        - !ruby/hash:OmniAuth::AuthHash
    school: !ruby/hash:OmniAuth::AuthHash
    id: '147250285303853'
    name: school
    type: College
    gender: female
    email: dumpty.h@gmail.com
    timezone: 2
    locale: en_US
    verified: true
    updated_time: '2013-06-19T08:32:20+0000'
=end
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
      )
    end
    user
  end

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
      )
    end
    user
  end

  #### 1.) first step: lookup whether there are data stored in the session. If not DEVISE will redirect the user
  #### to the provider.
=begin
  def self.new_with_session(params, session)
    super.tap do |user|
      supported_providers = User.omniauth_providers
      supported_providers.each do |provider|
        if data = session["devise.#{provider}_data"] && session["devise.#{provider}_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
          break
        end
      end
    end
  end
  ##################################
=end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
