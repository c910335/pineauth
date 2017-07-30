require "granite_orm/adapter/pg"

module OAuth
  class Grant < Granite::ORM
    adapter pg

    before_save generate

    # id : Int64 primary key is created for you
    field code : String
    field revoked_at : Time
    field scopes : String
    field user_id : Int64
    field client_id : Int64
    timestamps

    private def generate
      @code = SecureRandom.urlsafe_base64(32)
      @revoked_at = Time.now + 1.minute
    end
  end
end
