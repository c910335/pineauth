doctype html
html
  head
    title Pineauth using Amber
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    == csrf_metatag

    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    link rel="stylesheet" href="/stylesheets/main.css"

  body
    div.masthead
      div.container-fluid
        nav.nav
          == render_template "layouts/_nav.slang"
    div.container-fluid
      div.row
      - flash.each do |key, value|
        div class="alert alert-#{ key } alert-dismissible" role="alert"
          button.close type="button" data-dismiss="alert" aria-label="Close"
            span aria-hidden="true" ×
          p = flash[key]
      div.row
        div.col-sm-12.main
          == content

    script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"
    script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"
    script src="/javascripts/main.js"


