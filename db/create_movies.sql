drop table if exists website.movies cascade;
create table website.movies (
    id serial primary key,
    title varchar(100) not null unique,
    imdb_id varchar(20) default null unique
);

drop table if exists website.movie_rating_types cascade;
create table website.movie_rating_types(
    id serial primary key,
    name varchar(100) not null unique
);

COPY website.movie_rating_types (id, name) FROM stdin;
1	overall
2	rewatchability
\.

drop table if exists website.movie_rating_options cascade;
create table website.movie_rating_options(
    id serial primary key,
    movie_rating_type_id integer not null references website.movie_rating_types (id),
    description varchar(50) not null,
    value integer not null
);

COPY website.movie_rating_options (id, movie_rating_type_id, description, value) FROM stdin;
1	1	unwatchable	1
2	1	bad	2
3	1	typical	3
4	1	excellent	4
5	1	classic	5
\.

drop table if exists website.movie_ratings cascade;
create table website.movie_ratings(
    id serial primary key,
    movie_id integer not null references website.movies (id),
    movie_rating_type_id integer not null references website.movie_rating_types (id),
    rating integer not null,
    summary varchar(100) default null,
    explanation text default null,
    user_id integer not null references users.users (id),
    created_at timestamp with time zone not null
);

drop table if exists website.movie_reviews cascade;
create table website.movie_reviews (
    id serial primary key,
    movie_id integer not null references website.movies (id),
    title varchar(100),
    review text,
    movie_rating_id integer not null references website.movie_ratings,
    user_id integer not null references users.users (id) on update cascade,
    created_at timestamp with time zone not null
);
