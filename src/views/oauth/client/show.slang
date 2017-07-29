p = client.name
p = client.uid
p = client.secret
p = client.redirect_uri
p = client.scopes
p
  a.btn.btn-link href="/oauth/clients" back
  a.btn.btn-success href="/oauth/clients/#{ client.id }/edit" edit
  a.btn.btn-danger href="/oauth/clients/#{ client.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
