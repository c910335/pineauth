require "granite_orm/adapter/pg"

module OAuth
  class AuthorizedApplication < Granite::ORM
    adapter pg

    # id : Int64 primary key is created for you
    field revoked_at : Time
    field scopes : String
    field user_id : Int64
    field client_id : Int64
    timestamps

    belongs_to user
    belongs_to client

    def split_scopes
      if scopes = @scopes
        scopes.split
      else
        [] of String
      end
    end
  end
end
