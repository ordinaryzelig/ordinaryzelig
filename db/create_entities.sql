drop schema if exists entities cascade;

create schema entities;

create table entities.entity_types (
    id serial primary key,
    name varchar (30) unique
);

create table website.recent_entity_types (
    id serial primary key,
    entity_type_id integer references entities.entity_types (id)
);
