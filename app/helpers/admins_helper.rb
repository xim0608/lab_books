module AdminsHelper
  def name_with_nickname(user)
    "#{user.nickname} - <small>#{user.name}</small>".html_safe
  end
end
