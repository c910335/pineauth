doctype html
html
  head
    title OAuth Authorization Required
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    == csrf_metatag

    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    link rel="stylesheet" href="/stylesheets/main.css"
    css:
      .container { margin: 2em auto; }
      .h1 { margin-top: 15px; }
  body
    div.container
      == content

    script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"
    script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"
