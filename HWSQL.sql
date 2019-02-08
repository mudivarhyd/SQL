use sakila;
/* 1a question */
select first_name, last_name from actor;

/* 1b question */
select ucase(concat(first_name, ',', last_name)) as Actor_Name from actor;

/* 2a question */
select actor_id, first_name, last_name from actor where first_name = 'Joe';

/* 2b question */
select * from actor where last_name LIKE '%GEN%';

/* 2b question */
select * from actor where last_name LIKE '%LI%' order by 3,2;

/* 2c question */
select country_id, country from country where country 
in ('Afghanistan','Bangladesh','China');

/* 3a question */
ALTER TABLE `sakila`.`country` 
ADD COLUMN `Description` BLOB NULL AFTER `last_update`;

/* 3b question */
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `last_update`;

/* 4a question */
select last_name, count(last_name) from actor group by last_name;

/* 4b question */
select last_name, count(last_name) from actor group by last_name
having count(last_name) > 1 order by 2;

/* 4c question */
update actor set first_name = 'HARPO' where actor_id = 172;

/* 4d question */
update actor set first_name = 'GROUCHO' where actor_id = 172;

/* 5a question */
SHOW CREATE TABLE sakila.address;
/*CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8*/

/* 6a question */
select staff.first_name, staff.last_name, address.address
from staff
inner join address on
staff.address_id = address.address_id;

/* 6b question */
select staff.first_name, staff.last_name, payment.amount
from staff
inner join payment on
staff.staff_id = payment.staff_id
where DATE_FORMAT(payment_date,'%m/%Y')='08/2005';

/* 6c question */
select film.title, count(film_actor.actor_id) as number_of_actors 
from film_actor
inner join film on
film_actor.film_id = film.film_id
group by film.title;

/* 6d question */
select film.title, count(inventory.inventory_id) as copies 
from film
inner join inventory on
film.film_id = inventory.film_id
where film.title = 'Hunchback Impossible';

/* 6e question */
select customer.first_name, customer.last_name, sum(payment.amount) as total_amount_paid
from payment
inner join customer on
payment.customer_id = customer.customer_id
group by customer.first_name, customer.last_name
order by 2;

/* 7a question */
select title from film
where language_id in
	(select language_id from language
	where name = 'English')
 and (title like 'K%') or (title like 'Q%');
 
 /* 7b question */
 select first_name, last_name from actor
where actor_id in
	(select actor_id
    from film_actor
    inner join film on
    film_actor.film_id = film.film_id
	where film.title like 'Alone Trip');
    
/* 7c question */    
select first_name, last_name, email
from customer
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
where country.country = 'Canada';

/* 7d question */
select film.title
from film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name = 'Family';

/*7e question. I took view defination of sales_by_film_category and manipulated it
hence it does have extra joins not required in the select statement for the results */
SELECT 
        `f`.`title` AS `Title`, count(`p`.`rental_id`) AS `total_rentals`
    FROM
        (((((`sakila`.`payment` `p`
        JOIN `sakila`.`rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
        JOIN `sakila`.`inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `sakila`.`film` `f` ON ((`i`.`film_id` = `f`.`film_id`)))
        JOIN `sakila`.`film_category` `fc` ON ((`f`.`film_id` = `fc`.`film_id`)))
        JOIN `sakila`.`category` `c` ON ((`fc`.`category_id` = `c`.`category_id`)))
    GROUP BY `f`.`title`
    ORDER BY `total_rentals` DESC;
    
/* 7f question */
select store, total_sales from sales_by_store order by 2 desc;

/* 7g question */
select SID as store_id, city, country from customer_list;

/* 7h question */
SELECT 
        `c`.`name` AS `topy_five_generes`, SUM(`p`.`amount`) AS `gross_revenue`
    FROM
        (((((`sakila`.`payment` `p`
        JOIN `sakila`.`rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
        JOIN `sakila`.`inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `sakila`.`film` `f` ON ((`i`.`film_id` = `f`.`film_id`)))
        JOIN `sakila`.`film_category` `fc` ON ((`f`.`film_id` = `fc`.`film_id`)))
        JOIN `sakila`.`category` `c` ON ((`fc`.`category_id` = `c`.`category_id`)))
    GROUP BY `c`.`name`
    ORDER BY `gross_revenue` DESC
    limit 5;

/* 8a question */
CREATE 
VIEW `sakila`.`top_five_geners_by_revenue` AS
SELECT 
        `c`.`name` AS `topy_five_generes`, SUM(`p`.`amount`) AS `gross_revenue`
    FROM
        (((((`sakila`.`payment` `p`
        JOIN `sakila`.`rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
        JOIN `sakila`.`inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `sakila`.`film` `f` ON ((`i`.`film_id` = `f`.`film_id`)))
        JOIN `sakila`.`film_category` `fc` ON ((`f`.`film_id` = `fc`.`film_id`)))
        JOIN `sakila`.`category` `c` ON ((`fc`.`category_id` = `c`.`category_id`)))
    GROUP BY `c`.`name`
    ORDER BY `gross_revenue` DESC
    limit 5;
    
/* 8b question */
select * from top_five_geners_by_revenue;

/* 8c question */
DROP VIEW `sakila`.`top_five_geners_by_revenue`;