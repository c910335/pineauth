module OAuth
  class AuthorizedApplication < Granite::ORM::Base
    adapter pg
    table_name oauth_authorized_applications

    before_destroy clear_grants

    # id : Int64 primary key is created for you
    field revoked_at : Time
    field scopes : String
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

    def clear_grants
      Grant.where(client_id: client_id, user_id: user_id).each &.destroy
      AccessToken.where(client_id: client_id, user_id: user_id, revoked_at: nil).each &.revoke
    end
  end
end
