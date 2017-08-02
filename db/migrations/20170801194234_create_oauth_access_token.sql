-- +micrate Up
CREATE TABLE oauth_access_tokens (
  id BIGSERIAL PRIMARY KEY,
  token VARCHAR,
  refresh_token VARCHAR,
  expires_in INT,
  scopes VARCHAR,
  user_id BIGINT,
  client_id BIGINT,
  revoked_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX index_oauth_access_tokens_on_token ON "oauth_access_tokens" USING btree ("token");
CREATE INDEX index_oauth_access_tokens_on_refresh_token ON "oauth_access_tokens" USING btree ("refresh_token");
CREATE INDEX index_oauth_access_tokens_on_user_id ON "oauth_access_tokens" USING btree ("user_id");
CREATE INDEX index_oauth_access_tokens_on_client_id ON "oauth_access_tokens" USING btree ("client_id");
ALTER TABLE "oauth_access_tokens" ADD CONSTRAINT oauth_access_tokens_user_id_fk FOREIGN KEY ("user_id") REFERENCES "users" ("id")
ALTER TABLE "oauth_access_tokens" ADD CONSTRAINT oauth_access_tokens_client_id_fk FOREIGN KEY ("client_id") REFERENCES "oauth_clients" ("id")

-- +micrate Down
DROP TABLE IF EXISTS oauth_access_tokens;
