div.row
  div.col-sm-12
    h2 Authorized Clients
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
            a.btn.btn-primary.btn-xs href="/oauth/authorized_clients/#{ client.id }" read
            a.btn.btn-danger.btn-xs href="/oauth/authorized_clients/#{ client.id }?_method=delete" onclick="return confirm('Are you sure?');" delete

