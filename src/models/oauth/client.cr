require "granite_orm/adapter/pg"

module OAuth
  class Client < Granite::ORM::Base
    adapter pg
    table_name oauth_clients

    before_create generate_id_and_secret

    # id : Int64 primary key is created for you
    field name : String
    field uid : String
    field secret : String
    field redirect_uri : String
    field scopes : String
    timestamps

    belongs_to! user
    has_many! authorized_applications, id: client_id

    def split_scopes
      if scopes = @scopes
        scopes.split
      else
        [] of String
      end
    end

    private def generate_id_and_secret
      @uid = Random::Secure.urlsafe_base64(32)
      @secret = Random::Secure.urlsafe_base64(32)
    end

    def self.authenticate(uid, secret)
      if (client = find_by :uid, uid) && client.secret == secret
        client
      end
    end
  end
end
