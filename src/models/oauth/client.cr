require "granite_orm/adapter/pg"

module OAuth
  class Client < Granite::ORM 
    adapter pg

    before_create generate_id_and_secret

    # id : Int64 primary key is created for you
    field name : String
    field uid : String
    field secret : String
    field redirect_uri : String
    field scopes : String
    field user_id : Int64
    timestamps

    private def generate_id_and_secret
      @uid = SecureRandom.urlsafe_base64(32)
      @secret = SecureRandom.urlsafe_base64(32)
    end
  end
end
