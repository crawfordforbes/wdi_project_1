twilio phone number (973) 828-0420


db = afd

CREATE TABLE authors (
id serial primary key,
name varchar(255)
);

CREATE TABLE docs (
id serial primary key,
title varchar(255),
content text,
created_at timestamp,
updated_at timestamp,
edit text,
author_id integer references authors(id),
sub_ids text,
story_date date
);

CREATE TABLE subscribers (
id serial primary key,
name varchar(255),
docs text,
email varchar(255),
phone integer
);