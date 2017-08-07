require "granite_orm/adapter/pg"
require "crypto/bcrypt/password"

class User < Granite::ORM
  enum Level
    User
    Developer
    Owner
  end

  adapter pg

  # id : Int64 primary key is created for you
  field email : String
  field encrypted_password : String
  field level : Int64
  timestamps

  {% for name in %w{user developer owner} %}
    def {{name.id}}?
      level.not_nil! >= Level::{{name.camelcase.id}}.value
    end
  {% end %}

  def level_name
    Level.new(level.not_nil!.to_i).to_s
  end

  def password
    if encrypted_password = @encrypted_password
      Crypto::Bcrypt::Password.new(encrypted_password)
    else
      ""
    end
  end

  def password=(password : String)
    @encrypted_password = Crypto::Bcrypt::Password.create(password).to_s
  end

  def self.authenticate(email : String, password : String)
    user = User.find_by :email, email
    if user && user.password == password
      user
    else
      nil
    end
  end
end
