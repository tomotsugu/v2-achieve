class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :blogs

  #第一段階「中間テーブルと関係を定義する」
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  #第三段階「相対的な参照関係を定義する」
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :tasks, dependent: :destroy
  has_many :submit_requests, dependent: :destroy

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


  #指定のユーザをフォローする
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  #フォローしているかどうかを確認する
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  #フォローし合っている人を取得する
  def friend
    followed_user_ids = "SELECT X.id FROM (SELECT users.* FROM users INNER JOIN relationships ON users.id = relationships.followed_id WHERE relationships.follower_id = :user_id ) X INNER JOIN (SELECT users.* FROM users INNER JOIN relationships ON users.id = relationships.follower_id WHERE relationships.followed_id = :user_id ) Y ON X.id = Y.id"
    User.where("id IN (#{followed_user_ids})", user_id: self.id)
  end
end
