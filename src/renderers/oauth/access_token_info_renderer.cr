module OAuth
  class AccessTokenInfoRenderer < Crinder::Base(AccessToken)
    field user, with: UserRenderer
    field split_scopes : Array, as: scopes
    field expires_in : Float, value: ->{ object.expires_in.not_nil! - (Time.now - object.created_at.not_nil!).total_seconds }
    field client, with: ClientRenderer
    field created_at : String, value: ->{ Time::Format::ISO_8601_DATE_TIME.format(object.created_at.not_nil!) }

    class UserRenderer < Crinder::Base(User)
      field id : Int, value: ->{ object.id }
      field email : String
      field name : String
    end

    class ClientRenderer < Crinder::Base(Client)
      field uid : String, as: id
    end
  end
end
