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
ALTER TABLE "oauth_clients" ADD CONSTRAINT oauth_clients_user_id_fk FOREIGN KEY ("user_id") REFERENCES "users" ("id")

-- +micrate Down
DROP TABLE IF EXISTS oauth_clients;
