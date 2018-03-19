module OAuth
  class AccessTokenRenderer < Crinder::Base(AccessToken)
    field token : String, as: access_token
    field token_type : String, value: "Bearer"
    field expires_in : String, value: ->{ object.expires_in.not_nil! - (Time.now - object.created_at.not_nil!).total_seconds }
    field scopes : String, as: scope
    field refresh_token : String, if: ->{ object.refresh_token }
  end
end
