drop schema if exists comments cascade;

create schema comments;

create table comments.comments (
    id serial primary key,
    parent_id int references comments.comments (id),
    comment varchar (1000),
    user_id int references users.users (id),
    created_at timestamp with time zone
);

create table comments.comment_groups (
    id serial primary key,
    entity_type varchar (30) references entities.entity_types (name),
    entity_id int not null,
    root_comment_id int references comments.comments (id),
    unique (entity_type, entity_id, root_comment_id)
);