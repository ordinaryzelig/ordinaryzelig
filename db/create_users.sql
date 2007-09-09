DROP SCHEMA IF EXISTS users CASCADE;

CREATE SCHEMA users;

CREATE TABLE users.users (
    id serial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    display_name varchar(50),
    email varchar(50) UNIQUE,
    password varchar(50),
    is_admin integer,
    is_authorized integer
);

COPY users.users (first_name, last_name, display_name, email, "password", is_admin, is_authorized) FROM stdin;
master	master	master	admin@ordinaryzelig.org	3da541559918a808c2402bba5012f6c60b27661c	1	\N
\.

create table users.user_activities (
    user_id integer primary key references users.users (id),
    previous_login_at timestamp with time zone,
    last_login_at timestamp with time zone
);

create table users.friendships (
    id serial PRIMARY KEY,
    user_id int REFERENCES users.users (id),
    friend_id int REFERENCES users.users (id),
		created_at timestamp with time zone,
    constraint user_friend unique (user_id, friend_id)
);
