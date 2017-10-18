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
    - authorized_applications.each do |authorized_application|
      tr
        td = authorized_application.client.name
        td = authorized_application.scopes
        td
          span
            a.btn.btn-primary.btn-xs href="/oauth/authorized_applications/#{ authorized_application.id }" read
            form.inline-form action="/oauth/authorized_applications/#{ authorized_application.id }" method="post"
              input type="hidden" name="_method" value="delete"
              == csrf_tag
              button.btn.btn-danger.btn-xs type="submit" onclick="return confirm('Are you sure?');" delete
