class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :displayname, :username
  # attr_accessible :title, :body

  def self.find_or_create_by_ldap(uid, hash)
    User.where(username: uid).first_or_create! do |u|
      u.email = hash[:email]
      u.password = generate_random_password
    end.tap do |u|
      u.update_attributes!(hash)
    end
  end

  private
  def self.generate_random_password
      Digest::SHA1.hexdigest(Time.now.to_s)
  end

end
