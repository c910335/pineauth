require "granite_orm/adapter/pg"

module OAuth
  class AccessToken < Granite::ORM
    adapter pg
    table_name oauth_access_tokens

    before_create generate_tokens

    # id : Int64 primary key is created for you
    field token : String
    field refresh_token : String
    field expires_in : Int32
    field scopes : String
    field user_id : Int64
    field client_id : Int64
    field revoked_at : Time
    timestamps

    def to_json(json : JSON::Builder)
      hash = {
        :access_token => token,
        :token_type   => "Bearer",
        :expires_in   => expires_in.not_nil! - (Time.now - created_at.not_nil!).total_seconds,
        :scope        => scopes,
      }
      hash[:refresh_token] = refresh_token if refresh_token
      hash.to_json(json)
    end

    private def generate_tokens
      @token = SecureRandom.urlsafe_base64(32)
      @expires_in = 7200
    end

    private def revoke
      @revoked_at = Time.now
      save
    end
  end
end
