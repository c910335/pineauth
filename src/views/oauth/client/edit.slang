h1 Edit Client

- if client.errors
  ul.errors
  - client.errors.each do |error|
    li = error

form action="/oauth/clients/#{ client.id.to_s }" method="post"
  input type="hidden" name="_method" value="patch"
  div.form-group
    label for="uid" Id
    p#uid = client.uid
  div.form-group
    label for="secret" Secret
    p#secret = client.secret
  div.form-group
    label for="name" Name
    input#name.form-control type="text" name="name" placeholder="Name" value="#{ client.name }"
  div.form-group
    label for="redirect_uri" Redirect Uri
    textarea#redirect_uri.form-control rows="10" name="redirect_uri" placeholder="Redirect Uri" =  client.redirect_uri
  div.form-group
    label for="scopes" Scopes
    input#scopes.form-control type="text" name="scopes" placeholder="Scopes" value="#{ client.scopes }"
  button.btn.btn-primary type="submit" Submit
  a.btn.btn-link href="/oauth/clients" back
