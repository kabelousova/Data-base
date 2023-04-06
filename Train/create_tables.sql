drop table Way;
drop table CancelTicket;
drop table Ticket;
drop table Administration;
drop table Manager;
drop table BodyCheck;
drop table Employee;
drop table Schedule;
drop table Delay;
drop table DelayReason;
drop table RailwayFlight;
drop table Repair;
drop table RepairType;
drop table Locomotive;
drop table Crew;
drop table CrewType;
drop table Department;
drop table Route;
drop table RouteType;
drop table Station;
drop table LocomotiveType;

create table Department
(
    id   serial primary key,
    name varchar(100) not null
);

create table CrewType
(
    id   serial primary key,
    name varchar(100) not null
);

create table Crew
(
    id            serial primary key,
    name          varchar(100) not null,
    type_id       int          not null references CrewType (id),
    department_id int          not null references Department (id)
);

create table Employee
(
    id           serial primary key,
    first_name   varchar(100) not null,
    last_name    varchar(100) not null,
    sex          bit          not null,

    experience   int          not null check (experience >= 0),
    birth_date   date         not null,
    email        varchar(100) not null,
    phone_number varchar(100) not null,

    salary       int          not null CHECK (salary > 0),
    children     int          not null CHECK (children >= 0),

    crew_id      int references Crew (id)
);

create table Station
(
    id   serial primary key,
    name varchar(100) not null
);

create table Manager
(
    employee_id   int primary key references Department (id),
    department_id int unique not null references Employee (id)
);

create table Administration
(
    station_id int references Station (id),
    manager_id int references Manager (employee_id),

    constraint PK_C primary key (station_id, manager_id)
);

create table BodyCheck
(
    id          serial primary key,
    employee_id int  not null references Employee (id),
    date_check  date not null
);

create table RouteType
(
    id   serial primary key,
    name varchar(100) not null
);

create table Route
(
    id            serial primary key,

    type          int not null references RouteType (id),
    start_station int not null references Station (id),
    end_station   int not null references Station (id)
);
create table Way
(
    way_order  int not null,
    station_id int references Station (id),
    route_id   int references Route (id),
    constraint PK_CC primary key (station_id, route_id)
);

create table RailwayFlight
(
    id              serial primary key,
    loco_id         int       not null,
    departure_time  timestamp not null,
    arrival_time    timestamp not null,
    service_crew_id int       not null references Crew (id),
    route_id        int       not null references Route (id),
    direction       bit       not null,
    cancel          bit       not null,
    capacity        int       not null check (capacity > 0),

    constraint DT_L_AT check (departure_time < arrival_time)
);

create table DelayReason
(
    id   serial primary key,

    name varchar(100) not null
);

create table Delay
(
    id     serial primary key,

    reason int      not null references DelayReason (id),
    delay  interval not null
);


create table Schedule
(
    id             serial primary key,

    departure_time timestamp not null,
    arrival_time   timestamp not null,
    station        int       not null references Station (id),
    flight         int       not null references RailwayFlight (id),
    price          int       not null check (price > 0),
    delay          int references Delay (id)
);

create table LocomotiveType
(
    id   serial primary key,

    name varchar(100) not null
);

create table Locomotive
(
    id                serial primary key,
    type_id           int  not null references LocomotiveType (id),
    manufacture_year  date not null,
    driver_crew_id    int  not null references Crew (id) unique,
    technical_crew_id int  not null references Crew (id),
    railway_station   int  not null references Station (id)
);

create table RepairType
(
    id   serial primary key,

    name varchar not null
);

create table Repair
(
    id       serial primary key,

    type     int  not null references RepairType (id),
    crew_id  int  not null references Crew (id),
    loco_id  int  not null references Locomotive (id),
    rep_date date not null
);

create table Ticket
(
    id             serial primary key,

    purchase_time  timestamp not null,
    passenger      int       not null,
    seat           int       not null,
    luggage_count  int       not null,
    price          int       not null check (price > 0),
    start_station  int       not null references Station (id),
    end_station    int       not null references Station (id),
    railway_flight int       not null references RailwayFlight (id)
);

create table CancelTicket
(
    ticket_id   int primary key references Ticket (id),

    cancel_time timestamp not null
);