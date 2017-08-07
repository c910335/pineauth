p = user.email
p = user.password
p = user.level_name
p
  a.btn.btn-link href="/users" back
  a.btn.btn-success href="/users/#{ user.id }/edit" edit
  a.btn.btn-danger href="/users/#{ user.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
