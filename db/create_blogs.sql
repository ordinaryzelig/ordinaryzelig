drop schema if exists blogs cascade;

create schema blogs;

create table blogs.blogs (
    id serial primary key,
    title varchar (100),
    body text,
    user_id int references users.users (id),
    created_at timestamp with time zone default current_timestamp
);