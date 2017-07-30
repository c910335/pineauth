require "../spec_helper"
require "../../../src/models/oauth/grant.cr"

describe OAuth::Grant do
  Spec.before_each do
    OAuth::Grant.clear
  end
end
