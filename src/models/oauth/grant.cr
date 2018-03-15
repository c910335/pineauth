module OAuth
  class Grant < Granite::ORM::Base
    adapter pg
    table_name oauth_grants

    before_create generate
    after_create sync

    # id : Int64 primary key is created for you
    field code : String
    field revoked_at : Time
    field scopes : String
    field expires_in : Int32
    timestamps

    belongs_to! user
    belongs_to! client

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
      unless @revoked_at
        @revoked_at = Time.now
        save
      end
    end

    private def generate
      @code = Random::Secure.urlsafe_base64(32)
      @expires_in = 60
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
