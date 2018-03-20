module OAuth
  class AccessToken < Granite::ORM::Base
    adapter pg
    table_name oauth_access_tokens

    before_create generate_tokens
    after_create sync

    # id : Int64 primary key is created for you
    field token : String
    field refresh_token : String
    field expires_in : Int32
    field scopes : String
    field revoked_at : Time
    timestamps

    belongs_to! user
    belongs_to! client

    def self.new_with_refresh_token(**args)
      token = new(**args)
      token.refresh_token = Random::Secure.urlsafe_base64(32)
      token
    end

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

    private def sync
      unless authorized_application = AuthorizedApplication.find_by(client_id: client_id, user_id: user_id)
        authorized_application = AuthorizedApplication.new
        authorized_application.client_id = client_id
        authorized_application.user_id = user_id
      end
      authorized_application.scopes = (authorized_application.split_scopes | split_scopes).join(" ")
      authorized_application.save
    end
  end
end
