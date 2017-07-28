-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR,
  encrypted_password VARCHAR,
  owner BOOL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX index_users_on_email ON users USING btree (email);

-- +micrate Down
DROP TABLE IF EXISTS users;
