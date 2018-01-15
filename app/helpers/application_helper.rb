module ApplicationHelper
  def authenticate_user!(opts={})
    opts[:scope] = :user
    warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
  end

  def user_signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= warden.authenticate(:scope => :user)
  end

  def user_session
    current_user && warden.session(:user)
  end

  def smaller_book_image(image_url='',size='small')
    if image_url.present?
      if size == 'small'
        image_url.gsub!('/.jpg/', '._SL110_.jpg')
      elsif size == 'medium'
        image_url.gsub!('/.jpg/', '._SL160_.jpg')
      elsif size == 'tiny'
        image_url.gsub!('/.jpg/', '._SL175_.jpg')
      end
      image_tag image_url, class: "responsive-img"
    else
      if size == 'small'
        size = 'medium'
      end

      image_path = "no_image_#{size}.jpg"
      image_tag image_path, size: '300x300'
    end
  end
end

