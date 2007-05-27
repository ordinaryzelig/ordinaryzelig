drop schema if exists calendar cascade;

create schema calendar;

create table calendar.events (
    id serial primary key,
    name varchar(100),
    description varchar(200),
    starts_at timestamp with time zone default current_timestamp,
    ends_at timestamp with time zone,
    created_by_user_id int references users.users (id),
    created_at timestamp with time zone default current_timestamp
);