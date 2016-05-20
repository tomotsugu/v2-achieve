class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :blogs
  
  mount_uploader :avatar, AvatarUploader

  # attr_accessor :avatar_cache
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first

    unless user
      user = User.new(
          # name:      auth.extra.raw_info.name,
          provider:  auth.provider,
          uid:       auth.uid,
          email:     auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
          image_url: auth.info.image,
          password:  Devise.friendly_token[0, 20]
      )
      # user.skip_confirmation!
      user.save
    end
    user
  end
  
  def self.create_unique_string 
    SecureRandom.uuid 
  end
end
