drop table if exists website.movies cascade;
create table website.movies (
    id serial primary key,
    title varchar(100) not null unique,
    imdb_id varchar(20) unique
);

drop table if exists website.movie_rating_types cascade;
create table website.movie_rating_types(
    id serial primary key,
    name varchar(100) not null unique
);

COPY website.movie_rating_types (name) FROM stdin;
overall
rewatchability
\.

drop table if exists website.movie_rating_options cascade;
create table website.movie_rating_options(
    id serial primary key,
    movie_rating_type_id integer not null references website.movie_rating_types (id),
    description varchar(50) not null,
    value integer not null,
    unique (movie_rating_type_id, value)
);

COPY website.movie_rating_options (movie_rating_type_id, description, value) FROM stdin;
1	unwatchable	1
1	bad	2
1	average	3
1	excellent	4
1	classic	5
\.

drop table if exists website.movie_ratings cascade;
create table website.movie_ratings(
    id serial primary key,
    movie_id integer not null references website.movies (id),
    movie_rating_type_id integer not null references website.movie_rating_types (id),
    rating integer not null,
    summary varchar(100),
    explanation text,
    user_id integer not null references users.users (id),
    created_at timestamp with time zone not null
);
