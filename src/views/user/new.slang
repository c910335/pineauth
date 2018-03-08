h1 New User

- if user.errors
  ul.errors
  - user.errors.each do |error|
    li = error.to_s

form action="/users" method="post"
  == csrf_tag
  div.form-group
    label for="email" E-mail
    input#email.form-control type="email" name="email" placeholder="Email" value="#{ user.email }"
  div.form-group
    label for="password" Password
    input.form-control type="password" name="password" placeholder="Password"
	div.form-group                                                                                                                  
    label for="confirm-password" Confirm Password                                                                                 
    input#confirm-password.form-control type="password" name="confirm_password" placeholder="Confirm Password"
  div.form-group
    div.checkbox
      label for="level" Level
      select#level.form-control name="level"
        option value="0" User
        option value="1" Developer
        option value="2" Owner
  button.btn.btn-primary type="submit" Submit
  a.btn href="/users" back
