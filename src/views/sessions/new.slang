form action="/sign_in" method="post"
  == csrf_tag
  div.form-group
    label for="email" E-mail
    input#email.form-control type="email" name="email" placeholder="E-mail"
  div.form-group
    label for="password" Password
    input#password.form-control type="password" name="password" placeholder="Password"
  button.btn.btn-primary type="submit" Sign in
  a.btn href="/" Cancel
