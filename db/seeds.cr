require "amber"
require "../src/models/**"

user = User.new
user.email = "owner@example.com"
user.password = "password"
user.level = User::Level::Owner
user.save
