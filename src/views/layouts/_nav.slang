ul.nav.navbar-nav
  - active = context.request.path == "/" ? "active" : ""
  a class="nav-item #{active}" href="/" Home
  - if owner?
    - active = context.request.path == "/users" ? "active" : ""
    a class="nav-item #{active}" href="/users" Users
  - if developer?
    - active = context.request.path == "/oauth/clients" ? "active" : ""
    a class="nav-item #{active}" href="/oauth/clients" Clients
  - if user?
    - active = context.request.path == "/oauth/authorized_applications" ? "active" : ""
    a class="nav-item #{active}" href="/oauth/authorized_applications" Authorized Applications
ul.nav.navbar-nav.navbar-right
  - if current_user?
    li.dropdown
      a.dropdown-toggle data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"
        == current_user.email
        span.caret
      ul.dropdown-menu
        li
          a href="/users/#{ current_user.id }/edit" Change password
        li
          form action="/sign_out" method="post"
            == csrf_tag
            input type="hidden" name="_method" value="delete"
            button.btn-dm type="submit" Sign out
  - else
    a.nav-item href="/sign_in" Sign in
