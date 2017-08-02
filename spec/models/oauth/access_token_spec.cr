require "../spec_helper"
require "../../../src/models/oauth/access_token.cr"

describe OAuth::AccessToken do
  Spec.before_each do
    OAuth::AccessToken.clear
  end
end
