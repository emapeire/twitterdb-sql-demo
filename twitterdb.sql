drop database if exists twitterdb;
create database if not exists twitterdb;

use twitterdb;

drop table if exists users;
create table users (
	user_id int auto_increment,
    user_handle varchar(50) not null unique,
    email_address varchar(50) not null unique,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    phonenumber char(10) unique,
    create_at timestamp not null default (now()),
    primary key(user_id)
);

insert into users(user_handle, email_address, first_name, last_name)
values
('emapeire', 'ema@peire.com', 'Emanuel', 'Peire'),
('elon_musk', 'elon@musk.com', 'Elon', 'Musk'),
('rauchg', 'guillermo@rauch.com', 'Guillermo', 'Rauch');
