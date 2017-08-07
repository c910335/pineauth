require "../spec_helper"

def create_subject
  subject = OAuth::Client.new
  subject.name = "test"
  subject.save
  subject
end

describe OAuth::ClientController do
  Spec.before_each do
    OAuth::Client.clear
  end

  describe "index" do
    pending "renders all the oauth clients" do
      subject = create_subject
      get "/oauth/clients"
      response.body.should contain "test"
    end
  end

  describe "show" do
    pending "renders a single oauth client" do
      subject = create_subject
      get "/oauth/clients/#{subject.id}"
      response.body.should contain "test"
    end
  end

  describe "new" do
    pending "render new template" do
      get "/oauth/clients/new"
      response.body.should contain "New OAuth::Client"
    end
  end

  describe "create" do
    pending "creates a oauth client" do
      post "/oauth/clients", body: "name=testing"
      subject_list = OAuth::Client.all
      subject_list.size.should eq 1
    end
  end

  describe "edit" do
    pending "renders edit template" do
      subject = create_subject
      get "/oauth/clients/#{subject.id}/edit"
      response.body.should contain "Edit OAuth::Client"
    end
  end

  describe "update" do
    pending "updates a oauth client" do
      subject = create_subject
      patch "/oauth/clients/#{subject.id}", body: "name=test2"
      result = OAuth::Client.find(subject.id).not_nil!
      result.name.should eq "test2"
    end
  end

  describe "delete" do
    pending "deletes a oauth client" do
      subject = create_subject
      delete "/oauth/clients/#{subject.id}"
      result = OAuth::Client.find subject.id
      result.should eq nil
    end
  end
end
