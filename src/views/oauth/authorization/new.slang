div.panel.panel-info
  div.panel-heading
    h1 Authorization required
  div.panel-body
    p Authorize
      strong.text-info = client.name.to_s
      |?
    p This application will be able to:
      ul
        - scopes.each do |scope|
          li = scope
  div.panel-footer
    div.row
      div.col-sm-12.col-md-6
        form action="/oauth/authorize" method="post"
          == csrf_tag
          input type="hidden" name="client_id" value="#{client.uid}"
          input type="hidden" name="redirect_uri" value="#{redirect_uri}"
          - if state
            input type="hidden" name="state" value="#{state}"
          input type="hidden" name="response_type" value="#{response_type}"
          input type="hidden" name="scope" value="#{scopes_string}"
          button.btn.btn-success.btn-block type="submit" Authorize
      div.col-sm-12.col-md-6
        form action="/oauth/authorize" method="post"
          input type="hidden" name="_method" value="delete"
          == csrf_tag
          input type="hidden" name="client_id" value="#{client.uid}"
          input type="hidden" name="redirect_uri" value="#{redirect_uri}"
          - if state
            input type="hidden" name="state" value="#{state}"
          input type="hidden" name="response_type" value="#{response_type}"
          input type="hidden" name="scope" value="#{scopes_string}"
          button.btn.btn-danger.btn-block type="submit" Deny
