class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable,
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

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
