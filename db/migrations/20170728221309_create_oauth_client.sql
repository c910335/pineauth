-- +micrate Up
CREATE TABLE oauth_clients (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR,
  uid VARCHAR,
  secret VARCHAR,
  redirect_uri TEXT,
  scopes VARCHAR,
  user_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX index_oauth_clients_on_uid ON "oauth_clients" USING btree ("uid");
CREATE INDEX index_oauth_clients_on_user_id ON "oauth_clients" USING btree ("user_id");
ALTER TABLE "oauth_clients" ADD CONSTRAINT oauth_clients_user_id_fk FOREIGN KEY ("user_id") REFERENCES "users" ("id")

-- +micrate Down
DROP TABLE IF EXISTS oauth_clients;
