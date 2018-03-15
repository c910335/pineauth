module OAuth
  class AccessToken < Granite::ORM::Base
    adapter pg
    table_name oauth_access_tokens

    before_create generate_tokens

    # id : Int64 primary key is created for you
    field token : String
    field refresh_token : String
    field expires_in : Int32
    field scopes : String
    field revoked_at : Time
    timestamps

    belongs_to! user
    belongs_to! client

    def accessible?
      if revoked_at
        false
      elsif created_at.not_nil! + expires_in.not_nil!.seconds < Time.now
        revoke
        false
      elsif user?
        true
      else
        false
      end
    end

    def split_scopes
      if scopes = @scopes
        scopes.split
      else
        [] of String
      end
    end

    def revoke
      unless @revoked_at
        @revoked_at = Time.now
        save
      end
    end

    private def generate_tokens
      @token = Random::Secure.urlsafe_base64(32)
      @expires_in = 7200
    end
  end
end
