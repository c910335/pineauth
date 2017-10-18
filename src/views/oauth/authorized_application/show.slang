p = client.name
p = client.scopes
a.btn.btn-link href="/oauth/authorized_applications" back
form.inline-form action="/oauth/authorized_applications/#{ client.id }" method="post"
  input type="hidden" name="_method" value="delete"
  == csrf_tag
  button.btn.btn-danger type="submit" onclick="return confirm('Are you sure?');" delete
