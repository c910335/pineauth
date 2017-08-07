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

  describe "index" do
    pending "renders all the users" do
      subject = create_subject
      get "/users"
      response.body.should contain "test"
    end
  end

  describe "show" do
    pending "renders a single user" do
      subject = create_subject
      get "/users/#{subject.id}"
      response.body.should contain "test"
    end
  end

  describe "new" do
    pending "render new template" do
      get "/users/new"
      response.body.should contain "New User"
    end
  end

  describe "create" do
    pending "creates a user" do
      post "/users", body: "email=testing"
      subject_list = User.all
      subject_list.size.should eq 1
    end
  end

  describe "edit" do
    pending "renders edit template" do
      subject = create_subject
      get "/users/#{subject.id}/edit"
      response.body.should contain "Edit User"
    end
  end

  describe "update" do
    pending "updates a user" do
      subject = create_subject
      patch "/users/#{subject.id}", body: "email=test2"
      result = User.find(subject.id).not_nil!
      result.email.should eq "test2"
    end
  end

  describe "delete" do
    pending "deletes a user" do
      subject = create_subject
      delete "/users/#{subject.id}"
      result = User.find subject.id
      result.should eq nil
    end
  end
end
