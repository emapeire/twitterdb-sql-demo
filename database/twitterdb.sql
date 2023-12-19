-- create databse twitterdb
drop database if exists twitterdb;
create database if not exists twitterdb;

-- use twitterdb
use twitterdb;

-- create table users
drop table if exists users;
create table users (
	user_id int not null auto_increment,
    user_handle varchar(50) not null unique,
    email_address varchar(50) not null unique,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    phonenumber char(10) unique,
    follower_count int not null default 0,
    following_count int not null default 0,
    create_at timestamp not null default (now()),
    primary key(user_id)
);

-- insert into users
insert into users(user_handle, email_address, first_name, last_name)
values
('emapeire', 'ema@peire.com', 'Emanuel', 'Peire'),
('elon_musk', 'elon@musk.com', 'Elon', 'Musk'),
('evilrabbit_', 'evil@rabbit.com', 'Evil', 'Rabbit'),
('rauchg', 'guillermo@rauch.com', 'Guillermo', 'Rauch');

-- create table followers
drop table if exists followers;
create table followers (
	follower_id int not null,
    following_id int not null,
    foreign key(follower_id) references users(user_id),
    foreign key(following_id) references users(user_id),
    primary key(follower_id, following_id)
);

-- alter table followers
alter table followers
add constraint check_follower_id
check (follower_id != following_id);

-- select
-- select follower_id, following_id from followers;
-- select follower_id from followers where following_id = 1;
-- select count(follower_id) as followers_count from followers where following_id = 1;
/*
select users.user_id, users.user_handle, users.first_name, following_id, count(follower_id) as followers_count
from followers
join users on users.user_id = followers.following_id
group by following_id
order by followers_count desc
limit 3;
*/

-- create table tweets
drop table if exists tweets;
create table tweets (
	tweet_id int not null auto_increment,
    user_id int not null,
    tweet_text varchar(280) not null,
    num_likes int default 0,
    num_retweets int default 0,
    created_at timestamp not null default (now()),
    foreign key (user_id) references users(user_id),
    primary key (tweet_id)
);

-- insert into tweets
insert into tweets(user_id, tweet_text)
values
(1, 'Hello world!'),
(2, 'On my own way into Twitter, so great!'),
(3, 'HTML is a language programming 😂'),
(4, 'This gonna be awesome!'),
(1, 'This is a new social media!');

-- select
/*
select user_id, count(*) as tweet_count
from tweets
where user_id = 1;
*/

-- select
/*
select tweet_id, tweet_text, user_id
from tweets
where user_id in (
	select following_id
    from followers
    group by following_id
    having count(*) > 2
);
*/

-- delete
-- delete from tweets where tweet_id = 1;
-- delete from tweets where user_id = 1;

-- update
update tweets set num_likes = num_likes + 1 where tweet_id = 1;

-- create table tweet_likes
drop table if exists tweet_likes;
create table tweet_likes(
	user_id int not null,
    tweet_id int not null,
    foreign key (user_id) references users(user_id),
    foreign key (tweet_id) references tweets(tweet_id),
    primary key (user_id, tweet_id)
);

-- insert into tweet_likes
insert into tweet_likes (user_id, tweet_id)
values
(1, 3),
(1, 4),
(1, 2),
(2, 3),
(3, 2),
(4, 1),
(4, 5),
(3, 4),
(4, 2);

-- select
/*
select tweet_id, count(*) as like_count
from tweet_likes
group by tweet_id
order by like_count desc;
*/

-- triggers

-- increase_followers_count
drop trigger if exists increase_followers_count;

delimiter $$

create trigger increase_followers_count
after insert on followers
for each row
begin
	update users set follower_count = follower_count + 1
    where user_id = new.following_id;
end $$

delimiter ;

-- drecrease_followers_count
drop trigger if exists decrease_followers_count;

delimiter $$

create trigger decrease_followers_count
after delete on followers
for each row
begin
	update users set follower_count = follower_count - 1
    where user_id = new.following_id;
end $$

delimiter ;

-- insert into followers
insert into followers(follower_id, following_id)
values
(1, 2),
(2, 1),
(3, 1),
(3, 2),
(4, 1),
(2, 3);
