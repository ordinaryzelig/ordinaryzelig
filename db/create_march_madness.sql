DROP SCHEMA IF EXISTS march_madness CASCADE;

CREATE SCHEMA march_madness;

CREATE TABLE march_madness.seasons (
    id serial PRIMARY KEY,
    tournament_year integer UNIQUE,
    tournament_starts_at timestamp with time zone,
    is_current integer UNIQUE,
    max_num_brackets integer default 1,
    buy_in integer
);

CREATE TABLE march_madness.rounds (
    id serial PRIMARY KEY,
    name varchar(30),
    number integer
);

COPY march_madness.rounds (id, name, number) FROM stdin;
1	championship	6
2	final 4	5
3	elite 8	4
4	sweet 16	3
5	field of 32	2
6	field of 64	1
7	play-in	0
\.

CREATE TABLE march_madness.regions (
    id serial PRIMARY KEY,
    name varchar(30),
    season_id integer,
    order_num integer,
    UNIQUE (season_id,order_num),
    CONSTRAINT fk_r_season_id FOREIGN KEY (season_id) REFERENCES march_madness.seasons (id)
);

CREATE TABLE march_madness.teams (
    id serial PRIMARY KEY,
    name varchar(20) UNIQUE
);

COPY march_madness.teams (name) FROM stdin;
boston college
clemson
duke
florida state
georgia tech
maryland
miami
north carolina
virginia
virginia tech
wake forest
cincinnati
connecticut
depaul
georgetown
louisville
marquette
notre dame
pittsburgh
providence
rutgers
st johns
seton hall
south florida
syracuse
villanova
west virginia
illinois
indiana
iowa
michigan
michigan state
minnesota
northwestern
ohio state
pennsylvania state
purdue
wisconsin madison
baylor
colorado
iowa state
kansas
kansas state
missouri
nebraska
oklahoma
oklahoma state
texas
texas a&m
texas tech
arizona
arizona state
california
oregon
oregon state
stanford
ucla
southern california
washington
washington state
florida
georgia
kentucky
south carolina
tennessee
vanderbilt
alabama
arkansas
auburn
louisiana state
ole miss
mississippi state
alabama birmingham
central florida
east carolina
houston
memphis
rice
southern methodist
southern mississippi
texas el paso
tulane
tulsa
akron
ball state
bowling green
buffalo
central michigan
eastern michigan
kent state
miami ohio
northern illinois
ohio
toledo
western michigan
air force
brigham young
colorado state
new mexico
san diego state
texas christian
unlv
utah
wyoming
arkansas little rock
arkansas state
denver
florida atlantic
florida intl
louisiana lafayette
louisiana monroe
middle tennessee st
new orleans
north texas
south alabama
troy
western kentucky
boise state
fresno state
hawaii
idaho
louisiana tech
nevada
new mexico state
san jose state
utah state
eastern washington
idaho state
montana
montana st bozeman
northern arizona
northern colorado
portland state
cal st sacramento
weber state
charleston southern
coastal carolina
high point
liberty
radford
unc asheville
virginia military
winthrop
delaware
drexel
george mason
georgia state
hofstra
james madison
northeastern
old dominion
towson
unc wilmington
virginia comm
william and mary
illinois state
indiana state
missouri state
northern iowa
southern illinois
north dakota state
south dakota state
davis
brown
columbia
cornell
dartmouth
harvard
princeton
pennsylvania
yale
canisius
fairfield
iona
loyola maryland
manhattan
marist
niagara
rider
siena
saint peters
bethune-cookman
coppin state
delaware state
florida a&m
hampton
howard
maryland eastern
morgan state
norfolk state
north carolina a&t
south carolina state
central connecticut
fairleigh dickinson
long island-brooklyn
monmouth
mount st marys
quinnipiac
robert morris
sacred heart
st francis college
st francis univ
wagner
austin peay state
eastern illinois
eastern kentucky
jacksonville state
morehead state
murray state
samford
se missouri st
tennessee state
tennessee tech
tennessee at martin
american university
west point
bucknell
colgate
holy cross
lafayette
lehigh
navy
appalachian state
chattanooga
citadel
charleston
davidson
elon
furman
georgia southern
unc greensboro
western carolina
wofford
central arkansas
lamar
mcneese state
nicholls state
northwestern state
sam houston state
se louisiana
stephen f austin
texas arlington
texas san antonio
texas corpus christi
texas st san marcos
alabama a&m
alabama state
alcorn state
arkansas pine bluff
grambling state
jackson state
mississippi valley
prairie view a&m
southern
texas southern
university at albany
binghamton
boston
hartford
maine
maryland baltimore
new hampshire
stony brook
vermont
belmont
campbell
east tennessee state
gardner-webb
jacksonville
kennesaw state
lipscomb
mercer
north florida
stetson
unc charlotte
dayton
duquesne
fordham
george washington
la salle
massachusetts
rhode island
richmond
st bonaventure
saint josephs
saint louis
temple
xavier
polytech
fullerton
northridge
long beach
pacific
irvine
riverside
santa barbara
butler
cleveland state
detroit mercy
illinois chicago
loyola chicago
wisconsin green bay
wisconsin milwaukee
wright state
youngstown state
centenary
iupui
missouri kansas city
oakland
oral roberts
southern utah
valparaiso
western illinois
bradley
creighton
drake
evansville
wichita state
gonzaga
loyola marymount
pepperdine
portland
saint marys
san diego
san francisco
santa clara
\.

CREATE TABLE march_madness.accounts (
    id serial PRIMARY KEY,
    user_id integer,
    season_id integer,
    amount_paid integer default '0',
    UNIQUE (user_id,season_id),
    CONSTRAINT fk_a_season_id FOREIGN KEY (season_id) REFERENCES march_madness.seasons (id),
    CONSTRAINT fk_a_user_id FOREIGN KEY (user_id) REFERENCES users.users (id)
);

CREATE TABLE march_madness.games (
    id serial PRIMARY KEY,
    season_id integer,
    parent_id integer,
    round_id integer,
    region_id integer,
    CONSTRAINT fk_g_region_id FOREIGN KEY (region_id) REFERENCES march_madness.regions (id),
    CONSTRAINT fk_g_round_id FOREIGN KEY (round_id) REFERENCES march_madness.rounds (id),
    CONSTRAINT fk_g_season_id FOREIGN KEY (season_id) REFERENCES march_madness.seasons (id)
);

CREATE TABLE march_madness.bids (
    id serial PRIMARY KEY,
    team_id integer,
    seed integer,
    first_game_id integer,
    UNIQUE (team_id,first_game_id),
    CONSTRAINT fk_b_first_game_id FOREIGN KEY (first_game_id) REFERENCES march_madness.games (id),
    CONSTRAINT fk_b_team_id FOREIGN KEY (team_id) REFERENCES march_madness.teams (id)
);

CREATE TABLE march_madness.pool_users (
    id serial PRIMARY KEY,
    season_id integer,
    user_id integer,
    bracket_num integer,
    UNIQUE (season_id,user_id,bracket_num),
    CONSTRAINT fk_pu_season_id FOREIGN KEY (season_id) REFERENCES march_madness.seasons (id),
    CONSTRAINT fk_pu_user_id FOREIGN KEY (user_id) REFERENCES users.users (id)
);

CREATE TABLE march_madness.pics (
    id serial PRIMARY KEY,
    pool_user_id integer,
    game_id integer,
    bid_id integer,
    UNIQUE (pool_user_id,game_id),
    CONSTRAINT fk_p_bid_id FOREIGN KEY (bid_id) REFERENCES march_madness.bids (id),
    CONSTRAINT fk_p_game_id FOREIGN KEY (game_id) REFERENCES march_madness.games (id),
    CONSTRAINT fk_p_pool_user_id FOREIGN KEY (pool_user_id) REFERENCES march_madness.pool_users (id)
);