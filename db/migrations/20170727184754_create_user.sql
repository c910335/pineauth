-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR,
  name VARCHAR,
  encrypted_password VARCHAR,
  level BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX index_users_on_email ON "users" USING btree ("email");

-- +micrate Down
DROP TABLE IF EXISTS users;
