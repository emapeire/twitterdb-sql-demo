-- create database twitterdb
DROP DATABASE IF EXISTS twitterdb;
CREATE DATABASE IF NOT EXISTS twitterdb;

-- use twitterdb
USE twitterdb;

-- create table users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	user_id INT NOT NULL AUTO_INCREMENT,
    user_handle VARCHAR(100) NOT NULL UNIQUE,
    email_address VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phonenumber VARCHAR(20) UNIQUE,
    bio TEXT,
    follower_count INT NOT NULL DEFAULT 0,
    following_count INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id)
);
CREATE INDEX idx_user_handle ON users (user_handle);
CREATE INDEX idx_email_address ON users (email_address);

-- insert into users
INSERT INTO users(user_handle, email_address, first_name, last_name)
VALUES
('emapeire', 'ema@peire.com', 'Emanuel', 'Peire'),
('elon_musk', 'elon@musk.com', 'Elon', 'Musk'),
('evilrabbit_', 'evil@rabbit.com', 'Evil', 'Rabbit'),
('rauchg', 'guillermo@rauch.com', 'Guillermo', 'Rauch');

-- create table tweets
DROP TABLE IF EXISTS tweets;
CREATE TABLE tweets (
	tweet_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_text VARCHAR(280) NOT NULL,
    num_likes INT DEFAULT 0,
    num_retweets INT DEFAULT 0,
    reply_to_tweet_id INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    PRIMARY KEY (tweet_id)
);

-- insert into tweets
INSERT INTO tweets(user_id, tweet_text)
VALUES
(1, 'Hello world!'),
(2, 'On my own way into Twitter, so great!'),
(3, 'HTML is a language programming 😂'),
(4, 'This gonna be awesome!'),
(1, 'This is a new social media!');

-- create table followers
DROP TABLE IF EXISTS followers;
CREATE TABLE followers (
	follower_id INT NOT NULL,
    following_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (following_id) REFERENCES users(user_id),
    PRIMARY KEY (follower_id, following_id),
    CHECK (follower_id != following_id) -- Check constraint to prevent self-following
);

-- alter table followers
ALTER TABLE followers
ADD CONSTRAINT check_follower_id
CHECK (follower_id != following_id);

-- create table tweet_likes
DROP TABLE IF EXISTS tweet_likes;
CREATE TABLE tweet_likes (
	user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    PRIMARY KEY (user_id, tweet_id)
);

-- insert into tweet_likes
INSERT INTO tweet_likes (user_id, tweet_id)
VALUES
(1, 3),
(1, 4),
(1, 2),
(2, 3),
(3, 2),
(4, 1),
(4, 5),
(3, 4),
(4, 2);

-- triggers
-- increase_followers_count
DROP TRIGGER IF EXISTS increase_followers_count;
DELIMITER $$
CREATE TRIGGER increase_followers_count
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
    UPDATE users SET follower_count = follower_count + 1
    WHERE user_id = NEW.following_id;
END $$
DELIMITER ;

-- decrease_followers_count
DROP TRIGGER IF EXISTS decrease_followers_count;
DELIMITER $$
CREATE TRIGGER decrease_followers_count
AFTER DELETE ON followers
FOR EACH ROW
BEGIN
    UPDATE users SET follower_count = follower_count - 1
    WHERE user_id = OLD.following_id;
END $$
DELIMITER ;

-- insert into followers
INSERT INTO followers(follower_id, following_id)
VALUES
(1, 2),
(2, 1),
(3, 1),
(3, 2),
(4, 1),
(2, 3);
