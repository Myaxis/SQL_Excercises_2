USE test;
-- Making table for EmployeeInfo and EmployeePosition
create table if not exists EmployeeInfo
(
	EmpId tinyint not null auto_increment primary key,
    EmpFname varchar(20) not null,
    EmpLname varchar(20) not null,
    Department varchar(10) null,
    Project varchar(2) null,
    Address varchar(30) not null,
    Dob date not null,
    Gender char(1)
);

create table if not exists EmployeePosition
(
	EmpId tinyint not null,
    EmpPosition varchar(20) not null,
    DateOfJoining date not null,
    Salary int not null,
    key idx_fk_EmpId (EmpId),
    foreign key(EmpId) references EmployeeInfo(EmpId)
    on update cascade
    on delete cascade
);
-- Populating tables with values
SET AUTOCOMMIT=0;
INSERT INTO EmployeeInfo VALUES
(1,	'Sanjay',	'Mehra',	'HR',		'P1',	'Hyderabad(HYD)',	'1976-01-12',	'M'),
(2,	'Ananya',	'Mishra',	'Admin',	'P2',	'Delhi(DEL)',		'1968-02-05',	'F'),
(3,	'Rohan',	'Diwan',	'Account',	'P3',	'Mumbai(BOM)',		'1980-01-01',	'M'),
(4,	'Sonia',	'Kulkarni',	'HR',		'P1',	'Hyderabad(HYD)',	'1992-02-05',	'F'),
(5,	'Ankit',	'Kapoor',	'Admin',	'P1',	'Delhi(DEL)',		'1994-03-07',	'M');
COMMIT;

SET AUTOCOMMIT=0;
INSERT INTO EmployeePosition VALUES
(1,	'Manager',		'2022-01-05',	500000),
(2,	'Executive',	'2022-02-05',	75000),
(3,	'Manager',		'2022-01-05',	90000),
(2,	'Lead',			'2022-02-05',	85000),
(1,	'Executive',	'2022-01-05',	300000);
COMMIT;

-- Query 1

select upper(EmpFname) as empname from EmployeeInfo ;

-- Query 2

select count(empid) as HRCount from EmployeeInfo where department = 'HR';

-- Query 3
 
select sysdate();

-- Query 4

select substring(emplname, 1, 4) from EmployeeInfo;

-- Query 5

select substring(Address, 1, (locate('(',Address)-1)) from EmployeeInfo;

-- Query 6

create table NewTable as select * from EmployeeInfo;

-- Query 7

select * from EmployeePosition where Salary between 50000 and 100000;

-- Query 8 

select * from EmployeeInfo where empfname like 's%';

-- Query 9

select * from employeeposition order by salary desc limit n;

-- Query 10

select concat(empfname, ' ', emplname) as 'FullName' from EmployeeInfo;

-- Query 11

select count(*), gender from EmployeeInfo where dob between '1970-02-05' and '1975-12-31' group by gender;

-- Query 12

select * from employeeinfo order by emplname desc, department asc;

-- Query 13

select * from EmployeeInfo where emplname like '_____a';

-- Query 14

select * from EmployeeInfo where empfname not in ('Sanjay', 'Sonia');

-- Query 15

select * from EmployeeInfo where address = 'Delhi(DEL)';

-- Query 16

select employeeinfo.EmpFname, employeeinfo.EmpLname, employeeposition.EmpPosition from EmployeeInfo inner join
employeeposition using (empid) where employeeposition.EmpPosition = 'Manager';

-- Query 17

select department, count(empid) as EmpCount from EmployeeInfo group by department order by EmpCount asc;

-- Query 18
-- For odd numbered rows
set @rowno = 0;
select empid from (select (@rowno := @rowno + 1) as rowno, empid from EmployeeInfo) as A where mod(rowno,2)=1;
-- For even numbered rows
set @rowno = 0;
select empid from (select (@rowno := @rowno + 1) as rowno, empid from EmployeeInfo) as A where mod(rowno,2)=0;

-- Query 19

select * from employeeinfo where exists (select * from employeeposition 
where employeeinfo.EmpId = employeeposition.EmpId);

-- Query 20 
-- Two Min salaries
select distinct salary from employeeposition E1 where 2 >= (select count(distinct salary) from employeeposition E2 
where E1.Salary <= E2.Salary) order by E1.Salary desc;
-- Two Max salaries
select distinct salary from employeeposition E1 where 2 >= (select count(distinct salary) from employeeposition E2 
where E1.Salary >= E2.Salary) order by E1.Salary desc;

-- Query 21
set @N := 3;
select salary from EmployeePosition E1 where @N = (select count(distinct(E2.Salary)) from EmployeePosition E2 where
E2.Salary >= E1.Salary);

-- Query 22

select empid, empfname, department, count(*) from EmployeeInfo group by empid, empfname, department having count(*) > 1;

-- Query 23

select distinct E.empid, E.empfname, E.department from EmployeeInfo E, EmployeeInfo E1 where E.department = E1.department
and E.empid != e1.empid;

-- Query 24

select * from (select * from EmployeeInfo order by empid desc limit 3) as E order by empid asc;

-- Query 25

select salary from (select salary from EmployeePosition order by salary desc limit 3) as E order by salary asc limit 1;

-- Query 26

(select * from EmployeeInfo where empid = (select min(empid) from EmployeeInfo)) UNION 
(select * from EmployeeInfo where empid = (select max(empid) from EmployeeInfo));

-- Query 27
-- Adding email column to EmployeeInfo table and a sample email into an already exisiting row
alter table EmployeeInfo
add Email varchar(50) null;
update EmployeeInfo set Email = 'sanjarmehraHR@hotmail.com' where empid = 1;
-- Actual query
select *, Email 'Valid Emails' from EmployeeInfo where Email regexp 
'^[a-zA-Z0-9.!#$%&\'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}
[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$';

-- Query 28

select department, count(empid) as emp_num from EmployeeInfo group by department having emp_num < 2;

-- Query 29

select empposition, sum(salary) from EmployeePosition group by empposition;

-- Query 30

select * from EmployeeInfo where empid <= (select count(empid)/2 from EmployeeInfo);

