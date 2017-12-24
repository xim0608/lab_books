print("started to set users")
admin_users = User.where(is_admin: true)
if admin_users.blank?
  User.create(email: ENV['INITIAL_USER_EMAIL'], password: ENV['INITIAL_USER_PASS'], is_admin: true)
end
