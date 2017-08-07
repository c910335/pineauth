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

    property! user : User

    def accessible?
      if revoked_at
        false
      elsif created_at.not_nil! + expires_in.not_nil!.seconds < Time.now
        revoke
        false
      elsif @user = User.find user_id
        true
      else
        false
      end
    end

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

    def to_info_json
      {
        user: {
          id:    user.id,
          email: user.email,
        },
        scopes:     split_scopes,
        expires_in: expires_in.not_nil! - (Time.now - created_at.not_nil!).total_seconds,
        client:     {
          id: client_id,
        },
        created_at: created_at.not_nil!,
      }.to_json
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
      @token = SecureRandom.urlsafe_base64(32)
      @expires_in = 7200
    end
  end
end
