require "./spec_helper"

def create_subject
  subject = User.new
  subject.email = "test"
  subject.save
  subject
end

describe UserController do
  Spec.before_each do
    User.clear
  end

  describe UserController::Index do
    it "renders all the users" do
      subject = create_subject
      get "/users"
      response.body.should contain "test"
    end
  end

  describe UserController::Show do
    it "renders a single user" do
      subject = create_subject
      get "/users/#{subject.id}"
      response.body.should contain "test"
    end
  end

  describe UserController::New do
    it "render new template" do
      get "/users/new"
      response.body.should contain "New User"
    end
  end

  describe UserController::Create do
    it "creates a user" do
      post "/users", body: "email=testing"
      subject_list = User.all
      subject_list.size.should eq 1
    end
  end

  describe UserController::Edit do
    it "renders edit template" do
      subject = create_subject
      get "/users/#{subject.id}/edit"
      response.body.should contain "Edit User"
    end
  end

  describe UserController::Update do
    it "updates a user" do
      subject = create_subject
      patch "/users/#{subject.id}", body: "email=test2"
      result = User.find(subject.id).not_nil!
      result.email.should eq "test2"
    end
  end

  describe UserController::Delete do
    it "deletes a user" do
      subject = create_subject
      delete "/users/#{subject.id}"
      result = User.find subject.id
      result.should eq nil
    end
  end
end
