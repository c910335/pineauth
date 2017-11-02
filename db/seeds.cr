require "amber"
require "../config/initializers/*"
require "../src/models/**"

unless User.first
  user = User.new
  user.email = "owner@example.com"
  user.password = "password"
  user.level = User::Level::Owner
  user.save
end
