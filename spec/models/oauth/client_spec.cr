require "../spec_helper"
require "../../../src/models/oauth/client.cr"

describe OAuth::Client do
  Spec.before_each do
    OAuth::Client.clear
  end
end
