h1 New User

- if user.errors
  ul.errors
  - user.errors.each do |error|
    li = error

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
      label
        input type="hidden" name="published" value="false"
        - if user.owner
          input type="checkbox" name="owner" value="true" checked="true" Owner
        - else
          input type="checkbox" name="owner" value="true" Owner
  button.btn.btn-primary type="submit" Submit
  a.btn href="/users" back
