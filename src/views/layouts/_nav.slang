ul.nav.navbar-nav
  - active = context.request.path == "/" ? "active" : ""
  a class="nav-item #{active}" href="/" Home
  - if owner?
    - active = context.request.path == "/users" ? "active" : ""
    a class="nav-item #{active}" href="/users" Users
ul.nav.navbar-nav.navbar-right
  - if user = current_user
    li.dropdown
      a.dropdown-toggle data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"
        == user.email
        span.caret
      ul.dropdown-menu
        li
          a href="/users/#{ user.id }/edit" Change password
        li
          form action="/sign_out" method="post"
            == csrf_tag
            input type="hidden" name="_method" value="delete"
            button.btn-dm type="submit" Sign out
  - else
    a.nav-item href="/sign_in" Sign in
