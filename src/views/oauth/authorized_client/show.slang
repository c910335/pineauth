p = client.name
p = client.scopes
p
  a.btn.btn-link href="/oauth/authorized_clients" back
  a.btn.btn-danger href="/oauth/authorized_clients/#{ client.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
