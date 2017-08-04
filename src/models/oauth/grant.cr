require "granite_orm/adapter/pg"

module OAuth
  class Grant < Granite::ORM
    adapter pg

    before_create generate

    # id : Int64 primary key is created for you
    field code : String
    field revoked_at : Time
    field scopes : String
    field expires_in : Int32
    field user_id : Int64
    field client_id : Int64
    timestamps

    def split_scopes
      if scopes = @scopes
        scopes.split
      else
        [] of String
      end
    end

    def authorize(client : Client)
      if revoked_at
        false
      elsif created_at.not_nil! + expires_in.not_nil!.seconds < Time.now
        revoke
        false
      else
        client_id == client.id
      end
    end

    def revoke
      @revoked_at = Time.now
      save
    end

    private def generate
      @code = SecureRandom.urlsafe_base64(32)
      @expires_in = 60
    end
  end
end
