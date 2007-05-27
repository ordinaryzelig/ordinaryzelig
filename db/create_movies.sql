drop schema if exists movies cascade;

create schema movies;

create table movies.movies (
    id serial primary key,
    title varchar(100) unique,
    imdb_id integer
);

create table movies.ratings(
    id integer primary key,
    description char(20) unique
);

COPY movies.ratings (id, description) FROM stdin;
1	unwatchable         
2	bad                 
3	good                
4	excellent           
5	classic             
\.

create table movies.reviews (
    id serial primary key,
    movie_id integer references movies.movies (id),
    user_id integer references users.users (id) on update cascade,
    rating_id integer not null references movies.ratings,
    review text not null,
    reviewed_on date not null
);

create table movies.comments (
    id serial primary key,
    review_id integer not null references movies.reviews (id) on delete cascade,
    parent_id references movies.comments (id) on delete cascade,
    comment text not null
    posted_by_user_id integer not null references users.users (id) on update cascade,
    posted_at timestamp with time zone default current_timestamp
);