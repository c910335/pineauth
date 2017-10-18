div.row
  div.col-sm-12
    h2 Authorized Applications
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Name
        th Scopes
        th Actions
    tbody
    - clients.each do |client|
      tr
        td = client.name
        td = client.scopes
        td
          span
            a.btn.btn-primary.btn-xs href="/oauth/authorized_applications/#{ client.id }" read
            form.inline-form action="/oauth/authorized_applications/#{ client.id }" method="post"
              input type="hidden" name="_method" value="delete"
              == csrf_tag
              button.btn.btn-danger.btn-xs type="submit" onclick="return confirm('Are you sure?');" delete
