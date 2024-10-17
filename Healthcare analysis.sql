create database healthcare;
use healthcare;

-- Retreive all tables information
select * from patients;
select * from appointments;
select * from billing;
select * from doctors;
select * from prescriptions;

-- Get all appointments for a specific patient
select * from appointments
where patient_id = 1;

-- retrieve all prescritions for a specific appointment
select * from prescriptions
where appointment_id = 1;

-- Get billing information for a specific appointment
select * from billing
where appointment_id = 2;

-- 
select a.appointment_id , p.first_name as patient_first_name,p.last_name as patient_last_name,
d.first_name as doctor_first_name,d.last_name as doctor_last_name,a.appointment_date,a.reason
from appointments a 
join patients p on a.patient_id = p.patient_id
join doctors d on a.doctor_id = d.doctor_id;

-- List all Appointments with billing status

select a.appointment_id , p.first_name as patient_first_name,p.last_name as patient_last_name,
d.first_name as doctor_first_name,d.last_name as doctor_last_name,b.amount,b.payment_date, b.status
from appointments a
join patients p on a.patient_id = p.patient_id
join doctors d on a.doctor_id = d.doctor_id
join billing b on a.appointment_id = b.appointment_id;

-- Find all Paid Billing
Select * from billing
where status = 'Paid';

-- Calculate total amount billed and total paid amount
select(
select sum(amount) from billing) as total_billed,
(select sum(amount) from billing where status = 'paid') as total_paid;

-- get the number of appointments by speciality
select d.specialty,count(a.appointment_id) as number_of_appointments
from Appointments a
join Doctors d on a.doctor_id = d.doctor_id
group by d.specialty;

-- Find the most common reason for appointments
select reason,
count(*) as count
from appointments
group by reason
order by count DESC;

-- List patients with their latest appointment date
select p.patient_id,p.first_name,p.last_name,Max(a.appointment_date) as Latest_appointment
from Patients p
join appointments a on p.patient_id = a.patient_id
group by p.patient_id,p.first_name,p.last_name;

-- List all doctors and the number of appountments they had
select d.doctor_id,d.first_name,d.last_name,Count(a.appointment_id) as number_of_appointments
from doctors d
left join appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id,d.first_name,d.last_name;

-- Retreive Patients who had appointmenst in the last 30 days
select Distinct p.*
from patients p
join appointments a on p.patient_id = a.patient_id
where a.appointment_date >=curdate()-Interval 30 day;

-- Find Presciptions associated that are pending payment
select pr.prescription_id,pr.medication,pr.dosage,pr.instructions
from Prescriptions pr
join Appointments a on pr.appointment_id = a.appointment_id
Join Billing b on a.appointment_id = b.appointment_id
where b.status = 'Pending';

-- Analyse Patient Demographics
Select gender , Count(*) as count
from patients
group by gender;

-- Analyze the trend of appointments over months or years
select Date_format(appointment_date,'%Y-%m') as month , count(*) as Number_of_Appointments
from appointments
group by month
order by month;

-- Yearly trend
Select year(appointment_date) as year, Count(*) as number_of_appointments
from appointments
group by year
order by year;

-- Identify the most frequently prescribed medications and their total dosage
select medication,count(*) as frequency , SUM(cast(substring_index(dosage,'',1) as unsigned)) as total_dosage
from prescriptions
group by medication
order by frequency DESC;

-- average billing amount by number of appointments
select p.patient_id,count(a.appointment_id) as appointment_count,avg(b.amount) as avg_billing_amount
from patients p
left join Appointments a on p.patient_id = a.patient_id
left join Billing b on a.appointment_id = b.appointment_id
group by p.patient_id;

-- Analyze the correlation between appointment frequnecy and billing status
select p.patient_id,p.first_name,p.last_name,SUM(b.amount) as total_billed
from patients p
JOIN Appointments a on p.patient_id = a.patient_id
Join billing b on a.appointment_id = b.appointment_id
group by p.patient_id,p.first_name,p.last_name
order by total_billed DESC
limit 10;

-- Payment status over time
Select date_format(payment_date,'%Y-%m') as month,status,Count(*) as count
from billing
group by month,status
order by month,status;

-- Unpaid bills analysis
select p.patient_id,p.first_name,p.Last_name , SUM(b.amount) as total_unpaid
from Patients p
JOIN appointments a on p.patient_id = a.patient_id
JOIN Billing b on a.appointment_id = b.appointment_id
where b.status = 'pending'
group by p.patient_id , p.first_name , p.last_name
order by total_unpaid DESC;

-- Doctors performance metrics
select d.doctor_id , d.first_name , d.last_name , Count(a.appointment_id) as Total_appointments
from doctors d
Left JOIN appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id , d.first_name , d.last_name;

-- Day wise appointment counts
select appointment_date, count(*) as apppointment_count
from appointments
group by appointment_date;

-- Find patients with missing appointments
select p.patient_id, p.first_name,p.last_name
from patients p
left join appointments a ON p.patient_id = a.patient_id
where a.appointment_id is null;

--  Find all appointments for Doctor with ID 1
select a.appointment_id , p.first_name as patient_first_name, p.last_name as patient_last_name , a.appointment_date, a.reason
from appointments a
join patients p on a.patient_id = p.patient_id
where a.doctor_id = 1;

-- All prescription with payment status as pending
select p.medication, p.dosage , p.instructions , b.amount , b.payment_date , b.status 
from prescriptions p
join appointments a on a.appointment_id = a.appointment_id
join Billing b on a.appointment_id = b.appointment_id
where b.status = 'pending';

-- List all patients who had appointments in august
select p.patient_id , p.first_name , p.last_name , p.dob , p.gender , a.appointment_date 
from patients p
join Appointments a on p.patient_id = a.patient_id
where Date_format(a.appointment_date , '%Y-%m') = '2024-08';

-- List all doctors and their appointments in august till today
select d.first_name , d.last_name , a.appointment_date , p.first_name as patient_first_name , p.last_name as patient_last_name
from doctors d
JOIN Appointments a on d.doctor_id = a.doctor_id
JOIN patients p on a.patient_id = p.patient_id
where a.appointment_date between '2024-08-01' and '2024-08-10';

-- Get total amount billed per doctor
select d.first_name , d.last_name , d.specialty , sum(b.amount) as total_billed 
from doctors d
join appointments a on d.doctor_id = a.doctor_id
join billing b on a.appointment_id = b.appointment_id
group by d.first_name , d.last_name , d.specialty
order by total_billed desc;

-- 