div.row
  div.col-sm-11
    h2 Users
  div.col-sm-1
    a.btn.btn-success href="/users/new" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Email
        th Owner
        th Actions
    tbody
    - users.each do |user|
      tr
        td = user.email
        td = user.owner
        td
          span
            a.btn.btn-primary.btn-xs href="/users/#{ user.id }" read
            a.btn.btn-danger.btn-xs href="/users/#{ user.id }?_method=delete" onclick="return confirm('Are you sure?');" delete

