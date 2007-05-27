DROP SCHEMA IF EXISTS message_board cascade;

CREATE SCHEMA message_board;

CREATE TABLE message_board.messages (
    id serial PRIMARY KEY,
    parent_id integer REFERENCES message_board.messages (id) ON DELETE CASCADE,
    subject varchar(100),
    body text,
    posted_by_user_id integer REFERENCES users.users (id),
    posted_at timestamp with time zone DEFAULT current_timestamp
);