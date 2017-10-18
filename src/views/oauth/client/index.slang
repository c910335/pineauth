div.row
  div.col-sm-11
    h2 Clients
  div.col-sm-1
    a.btn.btn-success href="/oauth/clients/new" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Name
        th Id
        th Secret
        th Redirect Uri
        th Scopes
        th Actions
    tbody
    - clients.each do |client|
      tr
        td = client.name
        td = client.uid
        td = client.secret
        td = client.redirect_uri
        td = client.scopes
        td
          span
            a.btn.btn-primary.btn-xs href="/oauth/clients/#{ client.id }" read
            a.btn.btn-success.btn-xs href="/oauth/clients/#{ client.id }/edit" edit
            form.inline-form action="/oauth/clients/#{ client.id }" method="post"
              input type="hidden" name="_method" value="delete"
              == csrf_tag
              button.btn.btn-danger.btn-xs type="submit" onclick="return confirm('Are you sure?');" delete
