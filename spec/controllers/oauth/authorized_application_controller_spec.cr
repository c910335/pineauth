require "../spec_helper"

def create_subject
  subject = OAuth::Client.new
  subject.name = "test"
  subject.save
  subject
end

describe AuthorizedApplicationController do
  Spec.before_each do
    OAuth::Client.clear
  end

  describe "index" do
    it "renders all the authorized applications" do
      subject = create_subject
      get "/oauth/authorized_applications"
      response.body.should contain "test"
    end
  end

  describe "show" do
    it "renders a single authorized application" do
      subject = create_subject
      get "/oauth/authorized_applications/#{subject.id}"
      response.body.should contain "test"
    end
  end

  describe "delete" do
    it "deletes a authorized application" do
      subject = create_subject
      delete "/oauth/authorized_applications/#{subject.id}"
      result = OAuth::Client.find subject.id
      result.should eq nil
    end
  end
end
