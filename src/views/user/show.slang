p = user.email
p = user.name
p = user.password
p = user.level_name
a.btn.btn-link href="/users" back
form.inline-form action="/users/#{ user.id }" method="post"
  input type="hidden" name="_method" value="delete"
  == csrf_tag
  button.btn.btn-danger type="submit" onclick="return confirm('Are you sure?');" delete

