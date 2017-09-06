-- +micrate Up
CREATE TABLE oauth_authorized_applications (
  id BIGSERIAL PRIMARY KEY,
  revoked_at TIMESTAMP,
  scopes VARCHAR,
  user_id BIGINT,
  client_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX index_oauth_authorized_applications_on_user_id ON "oauth_authorized_applications" USING btree ("user_id");
CREATE INDEX index_oauth_authorized_applications_on_client_id ON "oauth_authorized_applications" USING btree ("client_id");
ALTER TABLE "oauth_authorized_applications" ADD CONSTRAINT oauth_authorized_applications_user_id_fk FOREIGN KEY ("user_id") REFERENCES "users" ("id")
ALTER TABLE "oauth_authorized_applications" ADD CONSTRAINT oauth_authorized_applications_client_id_fk FOREIGN KEY ("client_id") REFERENCES "oauth_clients" ("id")

-- +micrate Down
DROP TABLE IF EXISTS oauth_authorized_applications;
