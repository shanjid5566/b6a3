## Creating the Users Table

```sql
create table Users (
  user_id serial primary key,
  role varchar(10),
  user_name varchar(50),
  email varchar(100) unique not null,
  password varchar(100) not null,
  phone varchar(50)
);
```

**Explanation:**

This table stores details of all system users. The `user_id` is an auto-incremented primary key that uniquely identifies each user. The `role` field defines whether the user is an Admin or Customer. The `email` must be unique and cannot be NULL, ensuring each user has a valid, distinct email address. The `password` field stores login credentials, while `phone` stores the contact number.

**Purpose:** This table manages authentication and role-based access control for the system.

## Creating the Vehicles Table

```sql
create table Vehicles (
  vehicle_id serial primary key,
  vehicle_name varchar(100),
  type varchar(8),
  model varchar(20),
  registration_number varchar(20) unique,
  rental_price_per_day decimal,
  availability_status varchar(15)
);
```

**Explanation:**

This table stores all vehicles available for rent. The `vehicle_id` serves as the primary key. The `type` field can be Car, Bike, or Truck. Each vehicle has a unique `registration_number` that serves as its identifier. The `rental_price_per_day` indicates the cost per day, and `availability_status` tracks whether the vehicle is Available, Rented, or in Maintenance.

**Purpose:** This table keeps track of vehicle inventory and availability status.

## Creating the Bookings Table

```sql
create table Bookings (
  booking_id serial primary key,
  user_id int references Users (user_id),
  vehicle_id int references Vehicles (vehicle_id),
  start_date date,
  end_date date,
  booking_status varchar(15),
  total_cost decimal
);
```

**Explanation:**

This table stores booking transactions. The `user_id` is a foreign key linked to the Users table, while `vehicle_id` is a foreign key linked to the Vehicles table. The `booking_status` can be Pending, Confirmed, or Completed, and `total_cost` represents the total rental cost for the booking period.

**Purpose:** This table tracks rental history and ongoing bookings.

## Inserting Data into Users Table

```sql
insert into Users (role, user_name, email, password, phone) values (...);
```

**Explanation:**

This statement adds sample users to the system, including 1 Admin and 2 Customers. This demonstrates real-world system roles and how different user types interact with the platform.

**Result:** Users are ready to make bookings or manage the system.

## Inserting Data into Vehicles Table

```sql
insert into Vehicles (...) values (...);
```

**Explanation:**

This statement adds different vehicle types including Cars, Bikes, and Trucks. Each vehicle has a different availability status to represent real-world scenarios.

**Result:** The system now has a mix of rentable and unavailable vehicles.

## Inserting Data into Bookings Table

```sql
insert into Bookings (...) values (...);
```

**Explanation:**

This statement records booking history for customers. The total cost is calculated based on the rental duration.

**Result:** Booking transactions are stored for reporting and analysis.

## Retrieve Booking Information (JOIN Query)

```sql
select
  b.booking_id,
  u.user_name as customer_name,
  v.vehicle_name,
  b.start_date,
  b.end_date,
  b.booking_status,
  b.total_cost
from
  bookings b
  join users u on b.user_id = u.user_id
  join vehicles v on b.vehicle_id = v.vehicle_id;
```

**Explanation:**

This query uses JOINs to combine booking details with customer names and vehicle names, providing a complete booking summary.

**Result:** This displays who booked which vehicle and when.

**Note:** The correct join condition is `b.user_id = u.user_id` (not `b.booking_id = u.user_id`).

## Find Vehicles That Have Never Been Booked

```sql
select *
from vehicles v
where not exists (
  select *
  from bookings b
  where b.vehicle_id = v.vehicle_id
);
```

**Explanation:**

This query uses NOT EXISTS to filter vehicles with no bookings, helping to identify unused inventory.

**Result:** Shows vehicles that have never been rented.

## Retrieve All Available Cars

```sql
select
  vehicle_id,
  vehicle_name,
  model,
  registration_number,
  rental_price_per_day
from vehicles
where type = 'car'
  and availability_status = 'available';
```

**Explanation:**

This query filters vehicles by type (car) and status (available).

**Result:** Displays only cars that are ready for rental.

## Count Bookings Per Vehicle

```sql
select
  v.vehicle_id,
  v.vehicle_name,
  count(b.booking_id) as total_bookings
from vehicles v
join bookings b on v.vehicle_id = b.vehicle_id
group by v.vehicle_id, v.vehicle_name
having count(b.booking_id) > 0;
```

**Explanation:**

This query uses COUNT() to calculate total bookings per vehicle, GROUP BY for aggregation, and HAVING to filter vehicles with bookings.

**Result:** Shows vehicles that have been booked at least once.

**Note:** To find vehicles with more than 2 bookings, change the HAVING clause to `HAVING COUNT(b.booking_id) > 2;`

## Conclusion

This SQL project demonstrates core database concepts including relational database design, primary and foreign keys, data insertion, JOINs, subqueries, filtering, grouping, and aggregation. It provides a practical example of a vehicle rental management system that can be used as a foundation for real-world applications.