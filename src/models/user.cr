require "granite_orm/adapter/pg"
require "crypto/bcrypt/password"

class User < Granite::ORM
  adapter pg

  # id : Int64 primary key is created for you
  field email : String
  field encrypted_password : String
  field owner : Bool
  timestamps

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
