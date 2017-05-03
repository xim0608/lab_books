class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:slack]

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid).first

    unless user
      user = User.create(
        name: auth.info.name,
        email: auth.info.email,
        uid: auth.uid,
        password: Devise.friendly_token[0,20]
      )
    end
    return user
  end
end
