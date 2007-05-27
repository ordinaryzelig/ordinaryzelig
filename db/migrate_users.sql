INSERT INTO `users` (`id`,`first_name`,`last_name`,`display_name`,`email`,`password`,`is_admin`) VALUES ('2','Jared','Ning','ten cent','zeliggusgus@cox.net','da39a3ee5e6b4b0d3255bfef95601890afd80709','0');
INSERT INTO `users` (`id`,`first_name`,`last_name`,`display_name`,`email`,`password`,`is_admin`) VALUES ('3','cecelia','wong','the prophet','cece@felice.com','da39a3ee5e6b4b0d3255bfef95601890afd80709','0');
INSERT INTO `users` (`id`,`first_name`,`last_name`,`display_name`,`email`,`password`,`is_admin`) VALUES ('4','mike','minster','mikey','mminster@hotmail.com','a17fed27eaa842282862ff7c1b9c8395a26ac320','0');
INSERT INTO `users` (`id`,`first_name`,`last_name`,`display_name`,`email`,`password`,`is_admin`) VALUES ('5','lina','ea','lina bina','hellolina81@yahoo.com','1ceea5aafbb637c63f1f2ffd35ea6919cbc8da14','0');
INSERT INTO `users` (`id`,`first_name`,`last_name`,`display_name`,`email`,`password`,`is_admin`) VALUES ('6','stephanie','adler','dork','sadler23@gmail.com','ed9d3d832af899035363a69fd53cd3be8f71501c','0');

INSERT INTO `accounts` (`id`,`user_id`,`season_id`,`amount_paid`) VALUES (NULL,'2','1','20');
INSERT INTO `accounts` (`id`,`user_id`,`season_id`,`amount_paid`) VALUES (NULL,'3','1','10');
INSERT INTO `accounts` (`id`,`user_id`,`season_id`,`amount_paid`) VALUES (NULL,'4','1','10');
INSERT INTO `accounts` (`id`,`user_id`,`season_id`,`amount_paid`) VALUES (NULL,'6','1','20');

INSERT INTO `pool_users` (`id`,`season_id`,`user_id`,`bracket_num`) VALUES ('2','1','2','1');
INSERT INTO `pool_users` (`id`,`season_id`,`user_id`,`bracket_num`) VALUES ('3','1','3','1');
INSERT INTO `pool_users` (`id`,`season_id`,`user_id`,`bracket_num`) VALUES ('4','1','4','1');
INSERT INTO `pool_users` (`id`,`season_id`,`user_id`,`bracket_num`) VALUES ('8','1','6','1');
INSERT INTO `pool_users` (`id`,`season_id`,`user_id`,`bracket_num`) VALUES ('10','1','6','2');
INSERT INTO `pool_users` (`id`,`season_id`,`user_id`,`bracket_num`) VALUES ('11','1','2','2');

INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','1','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','2','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','3','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','4','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','5','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','6','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','7','3');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','8','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','9','6');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','10','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','11','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','12','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','13','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','14','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','15','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','16','14');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','17','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','18','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','19','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','20','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','21','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','22','19');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','23','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','24','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','25','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','26','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','27','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','28','25');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','29','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','30','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','31','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','32','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','33','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','34','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','35','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','36','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','37','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','38','35');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','39','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','40','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','41','39');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','42','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','43','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','44','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','45','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','46','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','47','46');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','48','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','49','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','50','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','51','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','52','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','53','52');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','54','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','55','53');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','56','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','57','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','58','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','59','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','60','59');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','61','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','62','61');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'2','63','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','5','4');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','6','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','7','4');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','9','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','10','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','11','13');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','12','10');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','13','10');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','14','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','15','13');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','16','13');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','17','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','18','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','19','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','20','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','21','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','22','20');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','23','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','24','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','25','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','26','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','27','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','28','25');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','29','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','30','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','31','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','32','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','33','42');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','34','42');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','35','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','36','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','37','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','38','35');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','39','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','40','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','41','40');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','42','42');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','43','42');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','44','42');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','45','44');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','46','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','47','46');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','48','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','49','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','50','54');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','51','52');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','52','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','53','52');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','54','54');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','55','54');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','56','56');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','57','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','58','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','59','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','60','60');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','61','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','62','61');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','63','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','8','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','4','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','3','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','2','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'3','1','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','2','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','3','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','4','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','5','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','6','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','7','3');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','8','6');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','9','6');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','10','8');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','11','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','12','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','13','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','14','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','15','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','16','14');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','17','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','18','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','19','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','20','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','21','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','22','19');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','23','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','24','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','25','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','26','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','27','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','28','26');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','29','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','30','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','31','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','32','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','33','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','34','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','35','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','36','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','37','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','38','36');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','39','39');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','40','38');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','41','39');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','42','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','43','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','44','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','45','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','46','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','47','46');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','48','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','49','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','50','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','51','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','52','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','53','52');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','54','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','55','53');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','56','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','57','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','58','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','59','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','60','59');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','61','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','62','62');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','63','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'4','1','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','1','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','2','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','3','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','4','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','5','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','6','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','7','3');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','8','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','9','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','10','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','11','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','12','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','13','10');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','14','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','15','14');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','16','14');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','17','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','18','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','19','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','20','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','21','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','22','20');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','23','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','24','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','25','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','26','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','27','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','28','26');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','29','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','30','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','31','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','32','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','33','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','34','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','35','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','36','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','37','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','38','36');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','39','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','40','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','41','39');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','42','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','43','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','44','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','45','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','46','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','47','46');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','48','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','49','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','50','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','51','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','52','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','53','52');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','54','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','55','54');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','56','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','57','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','58','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','59','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','60','59');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','61','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','62','62');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'8','63','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','1','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','2','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','3','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','4','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','5','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','6','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','7','3');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','8','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','9','5');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','10','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','11','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','12','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','13','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','14','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','15','14');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','16','14');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','17','16');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','18','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','19','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','20','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','21','17');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','22','20');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','23','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','24','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','25','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','26','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','27','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','28','26');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','29','27');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','30','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','31','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','32','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','33','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','34','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','35','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','36','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','37','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','38','36');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','39','39');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','40','38');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','41','39');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','42','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','43','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','44','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','45','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','46','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','47','46');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','48','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','49','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','50','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','51','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','52','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','53','52');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','54','53');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','55','53');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','56','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','57','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','58','59');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','59','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','60','59');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','61','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','62','62');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'10','63','63');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','1','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','2','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','3','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','4','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','5','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','6','1');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','7','3');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','8','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','9','6');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','10','7');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','11','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','12','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','13','9');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','14','11');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','15','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','16','14');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','17','15');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','18','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','19','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','20','20');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','21','18');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','22','20');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','23','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','24','21');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','25','23');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','26','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','27','25');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','28','25');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','29','28');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','30','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','31','30');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','32','31');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','33','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','34','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','35','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','36','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','37','33');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','38','36');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','39','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','40','37');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','41','39');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','42','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','43','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','44','41');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','45','43');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','46','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','47','46');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','48','47');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','49','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','50','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','51','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','52','49');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','53','52');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','54','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','55','53');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','56','55');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','57','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','58','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','59','57');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','60','59');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','61','61');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','62','61');
INSERT INTO `pics` (`id`,`pool_user_id`,`game_id`,`bid_id`) VALUES (NULL,'11','63','63');