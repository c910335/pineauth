h1 Edit User

- if user.errors
  ul.errors
  - user.errors.each do |error|
    li = error.to_s

- action = (user.id ? "/users/" + user.id.to_s : "/users")
form action="/users/#{ user.id }" method="post"
  == csrf_tag
  input type="hidden" name="_method" value="patch"
  p
    == user.email
  div.form-group
    label for="password" Password
    input#password.form-control type="password" name="old_password" placeholder="Password"
  div.form-group
    label for="new-password" New Password
    input#new-password.form-control type="password" name="password" placeholder="New Password"
  div.form-group
    label for="confirm-password" Confirm Password
    input#confirm-password.form-control type="password" name="confirm_password" placeholder="Confirm Password"
  button.btn.btn-primary type="submit" Submit
  a.btn href="/" Cancel
