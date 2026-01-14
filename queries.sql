-- Create a table for Users 
create table Users (
  user_id serial primary key,
  role varchar(10),
  user_name varchar(50),
  email varchar(100) unique not null,
  password varchar(100) not null,
  phone varchar(50)
)
-- create a table for  Vehicles
create table Vehicles (
  vehicle_id serial primary key,
  vehicle_name varchar(100),
  type varchar(8),
  model varchar(20),
  registration_number varchar(20) unique,
  rental_price_per_day decimal,
  availability_status varchar(15)
)
-- create a table for  Vehicles
create table Bookings (
  booking_id serial primary key,
  user_id int references Users (user_id),
  vehicle_id int references Vehicles (vehicle_id),
  start_date date,
  end_date date,
  booking_status varchar(15),
  total_cost decimal
)
-- insert datas in Users table
insert into
  Users (role, user_name, email, password, phone)
values
  (
    'Admin',
    'Alice Johnson',
    'alice.admin@rentals.com',
    'securepass123',
    '555-0101'
  ),
  (
    'Customer',
    'Bob Smith',
    'bob.smith@gmail.com',
    'bobpassword',
    '555-0202'
  ),
  (
    'Customer',
    'Charlie Davis',
    'charlie.d@outlook.com',
    'charlie789',
    '555-0303'
  );

-- insert datas in Vehicles table
insert into
  Vehicles (
    vehicle_name,
    type,
    model,
    registration_number,
    rental_price_per_day,
    availability_status
  )
values
  (
    'Toyota Corolla',
    'car',
    '2022',
    'ABC-1234',
    50.00,
    'available'
  ),
  (
    'Honda CBR',
    'bike',
    '2021',
    'XYZ-9876',
    30.00,
    'rented'
  ),
  (
    'Ford F-150',
    'truck',
    '2023',
    'TRK-5544',
    85.00,
    'maintenance'
  ),
  (
    'Tesla Model 3',
    'car',
    '2023',
    'EV-0001',
    120.00,
    'available'
  );

-- insert datas in Bookings table
insert into
  Bookings (
    user_id,
    vehicle_id,
    start_date,
    end_date,
    booking_status,
    total_cost
  )
values
  (
    2,
    1,
    '2024-10-01',
    '2024-10-03',
    'completed',
    100.00
  ),
  (
    3,
    2,
    '2024-10-05',
    '2024-10-06',
    'confirmed',
    30.00
  ),
  (
    2,
    4,
    '2024-10-10',
    '2024-10-12',
    'pending',
    240.00
  );

-- Retrieve booking information
select
  b.booking_id,
  u.user_name as customer_name,
  v.vehicle_name,
  b.start_date,
  b.end_date,
  b.booking_status,
  b.total_cost
from
  bookings as b
  join users as u on b.booking_id = u.user_id
  join vehicles as v on b.vehicle_id = v.vehicle_id
  -- Find all vehicles that have never been booked.
select
  *
from
  vehicles v
where
  not exists (
    select
      *
    from
      bookings b
    where
      b.vehicle_id = v.vehicle_id
  )
  -- Retrieve all available vehicles of a specific type (e.g. cars).
select
  vehicle_id,
  vehicle_name,
  model,
  registration_number,
  rental_price_per_day
from
  vehicles
where
  type = 'car'
  and availability_status = 'available'
  -- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
SELECT
  v.vehicle_id,
  v.vehicle_name,
  COUNT(b.booking_id) AS total_bookings
FROM
  Vehicles v
  JOIN Bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY
  v.vehicle_id,
  v.vehicle_name
HAVING
  COUNT(b.booking_id) > 0;