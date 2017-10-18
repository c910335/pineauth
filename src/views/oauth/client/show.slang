p = client.name
p = client.uid
p = client.secret
p = client.redirect_uri
p = client.scopes
a.btn.btn-link href="/oauth/clients" back
a.btn.btn-success href="/oauth/clients/#{ client.id }/edit" edit
form.inline-form action="/oauth/clients/#{ client.id }" method="post"
  input type="hidden" name="_method" value="delete"
  == csrf_tag
  button.btn.btn-danger type="submit" onclick="return confirm('Are you sure?');" delete
a.btn.btn-info href="/oauth/authorize?response_type=code&scope=#{ client.scopes }&client_id=#{ client.uid }&redirect_uri=#{ client.redirect_uri }" authorize
