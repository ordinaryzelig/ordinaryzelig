COPY march_madness.seasons (started_in, tournament_year, tournament_starts_at, is_current, max_num_brackets, buy_in) FROM stdin;
2005	2006	2006-03-11 11:00:00	1	2	10
\.

COPY march_madness.regions (name, season_id, order_num) FROM stdin;
final four	1	1
atlanta	1	2
oakland	1	3
washington, d.c.	1	4
minneapolis	1	5
\.

COPY march_madness.games (season_id, parent_id, round_id, region_id) FROM stdin;
1	\N	1	1
1	1	2	1
1	2	3	2
1	3	4	2
1	4	5	2
1	5	6	2
1	5	6	2
1	4	5	2
1	8	6	2
1	8	6	2
1	3	4	2
1	11	5	2
1	12	6	2
1	12	6	2
1	11	5	2
1	15	6	2
1	15	6	2
1	2	3	3
1	18	4	3
1	19	5	3
1	20	6	3
1	20	6	3
1	19	5	3
1	23	6	3
1	23	6	3
1	18	4	3
1	26	5	3
1	27	6	3
1	27	6	3
1	26	5	3
1	30	6	3
1	30	6	3
1	1	2	1
1	33	3	4
1	34	4	4
1	35	5	4
1	36	6	4
1	36	6	4
1	35	5	4
1	39	6	4
1	39	6	4
1	34	4	4
1	42	5	4
1	43	6	4
1	43	6	4
1	42	5	4
1	46	6	4
1	46	6	4
1	33	3	5
1	49	4	5
1	50	5	5
1	51	6	5
1	51	6	5
1	50	5	5
1	54	6	5
1	54	6	5
1	49	4	5
1	57	5	5
1	58	6	5
1	58	6	5
1	57	5	5
1	61	6	5
1	61	6	5
\.

COPY march_madness.bids (team_id, seed, first_game_id) FROM stdin;
7	4	56
33	14	45
11	1	37
25	12	24
23	3	14
54	12	9
42	13	56
62	7	47
3	16	37
24	4	25
38	14	14
27	4	10
40	6	59
47	10	47
26	8	38
8	13	25
10	7	16
22	13	10
61	6	13
65	11	59
52	2	48
55	9	38
21	6	28
34	10	16
48	14	60
14	3	60
63	15	48
60	5	40
46	11	28
53	2	17
17	7	62
45	16	52
59	1	52
58	12	40
18	3	29
43	15	17
37	10	62
4	8	53
1	13	41
20	4	41
66	14	29
29	1	21
13	1	6
39	2	63
64	9	53
30	6	44
2	10	31
28	7	31
41	16	21
49	16	6
12	15	63
35	5	55
15	11	44
56	2	32
9	9	22
5	8	22
16	8	7
32	12	55
36	3	45
6	15	32
44	5	24
50	11	13
57	9	7
51	5	9
\.

COPY march_madness.pool_users (season_id, user_id, bracket_num) FROM stdin;
1	1	1
\.

COPY march_madness.pics (pool_user_id, game_id, bid_id) FROM stdin;
1	1	\N
1	2	\N
1	3	\N
1	4	\N
1	5	\N
1	6	\N
1	7	\N
1	8	\N
1	9	\N
1	10	\N
1	11	\N
1	12	\N
1	13	\N
1	14	\N
1	15	\N
1	16	\N
1	17	\N
1	18	\N
1	19	\N
1	20	\N
1	21	\N
1	22	\N
1	23	\N
1	24	\N
1	25	\N
1	26	\N
1	27	\N
1	28	\N
1	29	\N
1	30	\N
1	31	\N
1	32	\N
1	33	\N
1	34	\N
1	35	\N
1	36	\N
1	37	\N
1	38	\N
1	39	\N
1	40	\N
1	41	\N
1	42	\N
1	43	\N
1	44	\N
1	45	\N
1	46	\N
1	47	\N
1	48	\N
1	49	\N
1	50	\N
1	51	\N
1	52	\N
1	53	\N
1	54	\N
1	55	\N
1	56	\N
1	57	\N
1	58	\N
1	59	\N
1	60	\N
1	61	\N
1	62	\N
1	63	\N
\.
