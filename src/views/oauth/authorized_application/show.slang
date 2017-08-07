p = client.name
p = client.scopes
p
  a.btn.btn-link href="/oauth/authorized_applications" back
  a.btn.btn-danger href="/oauth/authorized_applications/#{ client.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
