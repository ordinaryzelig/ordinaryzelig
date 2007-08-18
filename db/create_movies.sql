drop table if exists website.movies cascade;
create table website.movies (
    id serial primary key,
    title varchar(100) not null unique,
    imdb_id varchar(20) default null unique
);

drop table if exists website.movie_ratings cascade;
create table website.movie_ratings(
    id integer primary key,
    description varchar(20) not null unique
);

COPY website.movie_ratings (id, description) FROM stdin;
1	unwatchable
2	bad
3	typical
4	excellent
5	classic
\.

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
