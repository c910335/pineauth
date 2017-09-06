require "../spec_helper"
require "../../../src/models/oauth/authorized_application.cr"

describe OAuth::AuthorizedApplication do
  Spec.before_each do
    OAuth::AuthorizedApplication.clear
  end
end
