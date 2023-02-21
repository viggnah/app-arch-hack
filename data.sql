use viggnah_db;

create table catalogue
(
    id int auto_increment
        primary key,
    title varchar(255),
    description varchar(255),
    price double,
    material varchar(255)
);
insert into catalogue (title, description, price, material) values ('dog hoodie', 'just a hoodie for your dog', 14.99, 'cotton');
insert into catalogue(title, description, price, material) values('dog sweater', 'just a sweater for your dog', 11.99, 'acrylic');

create table following
(
    id int auto_increment
        primary key,
    email varchar(255),
    product_id int,
    user_id int
);