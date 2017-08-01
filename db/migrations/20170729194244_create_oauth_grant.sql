-- +micrate Up
CREATE TABLE oauth_grants (
  id BIGSERIAL PRIMARY KEY,
  code VARCHAR,
  scopes VARCHAR,
  expires_in INT,
  user_id BIGINT,
  client_id BIGINT,
  revoked_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX index_oauth_grants_on_code ON "oauth_grants" USING btree ("code");
CREATE INDEX index_oauth_grants_on_user_id ON "oauth_grants" USING btree ("user_id");
CREATE INDEX index_oauth_grants_on_client_id ON "oauth_grants" USING btree ("client_id");
ALTER TABLE "oauth_grants" ADD CONSTRAINT oauth_grants_user_id_fk FOREIGN KEY ("user_id") REFERENCES "users" ("id")
ALTER TABLE "oauth_grants" ADD CONSTRAINT oauth_grants_client_id_fk FOREIGN KEY ("client_id") REFERENCES "oauth_clients" ("id")

-- +micrate Down
DROP TABLE IF EXISTS oauth_grants;
