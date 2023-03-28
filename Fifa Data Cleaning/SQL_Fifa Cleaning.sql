select *
from  fifads;

select count(*)
from  fifads;


--Removing Duplicates
SELECT DISTINCT * 
FROM  fifads;

SELECT DISTINCT count(*) 
FROM  fifads;


-- FIXING THE CONTRACTS COLUMN

alter table fifads
add Contract_Start smallint,
	Contract_End smallint,
	Loan_status nvarchar(20) NULL;


select Contract, Contract_Start, Contract_End, Loan_status
from fifads;

--select 
--	(case when CHARINDEX('~', Contract)>0
--		then SUBSTRING(Contract,1,CHARINDEX('~', Contract)-1)
--		END) as new
--from fifads;


update fifads
set Contract_Start = SUBSTRING(Contract,1,4)
where Contract LIKE '%~%';

update fifads
set Contract_End = SUBSTRING(Contract, 8,4)
where Contract LIKE '%~%';

update fifads
set Contract_End = SUBSTRING(Contract,9,4)
where Contract LIKE '%Loan%';

update fifads
set Loan_status = RIGHT(Contract,7)
where Contract LIKE '%Loan%';

update fifads
set Loan_status = Contract
where Contract = 'Free';

select Contract_Start,Contract_End, Loan_status  
from fifads;




					 
-- Fixing the WEIGHT & Height columns

select Height, Weight
from fifads;

alter table fifads
add Height_fixed_cm nvarchar(20) NULL,
	Weight_fixed_kg nvarchar(20);
	
update fifads
set Height_fixed_cm = Height

update fifads
set weight_fixed_kg = Weight

update fifads
set Height_fixed_cm = REPLACE(Height, '"','')

update fifads
set Height_fixed_cm = STUFF(Height_fixed_cm,2,1,'.')
where Height_fixed_cm NOT LIKE '%cm%';

update fifads
set Height_fixed_cm = REPLACE(Height_fixed_cm, 'cm','');

update fifads
set Height_fixed_cm = TRIM(Height_fixed_cm);

update fifads
set Height_fixed_cm = CAST(Height_fixed_cm AS decimal(18,2));

update fifads
set Height_fixed_cm = Height_fixed_cm * 30.48
where SUBSTRING(Height_fixed_cm, 2,1) LIKE '%.%';

update fifads
set Height_fixed_cm = ROUND(Height_fixed_cm,0);

select weight_fixed_kg
from fifads;

update fifads
set weight_fixed_kg = REPLACE(weight_fixed_kg, 'lbs','')

update fifads
set weight_fixed_kg = CAST(weight_fixed_kg AS int) * 0.453592
where weight_fixed_kg NOT LIKE '%kg%';

update fifads
set  weight_fixed_kg = CAST(REPLACE(weight_fixed_kg, 'kg','') as decimal(18,0));


--- Currency Values
select TOP(5)[Value]
from fifads;

alter table fifads
add Value_Fixed nvarchar(50) NULL,
	Wage_fixed nvarchar(50) NULL,
	Release_clause_fixed nvarchar(50) NULL;

update fifads
set Value_Fixed = REPLACE(Value,'€','');

select TOP(5) Value_Fixed
from fifads;



--With Value_conversions (col_1, col_2)
--AS
--(
--select Value_Fixed,
--	CASE 
--		WHEN RIGHT(Value_Fixed,1)='M'
--			THEN CAST(REPLACE(Value_Fixed,'M','') AS decimal(18,2)) * 1000000

--		WHEN RIGHT(Value_Fixed,1)='K'
--			THEN CAST(REPLACE(Value_Fixed,'K','') AS decimal(18,2)) * 1000
--	END as correct


--from fifads
--)
--update fifads
--set Value_Fixed 

update fifads
set Value_Fixed = CAST(REPLACE(Value_Fixed, 'M','') AS decimal(18,2)) * 1000000
where Value_Fixed LIKE '%M%';

update fifads
set Value_Fixed = CAST(REPLACE(Value_Fixed, 'K','') AS decimal(18,2)) * 1000
where Value_Fixed LIKE '%K%';

select Value_Fixed, Value
from fifads;

-- WAGES
update fifads
set Wage_fixed = REPLACE(Wage,'€','');

select TOP(5) Wage, Wage_fixed
from fifads;

update fifads
set Wage_fixed = CAST(REPLACE(Wage_fixed, 'K','') AS decimal(18,2)) * 1000
where Wage_fixed LIKE '%K%';

select Wage_fixed, Wage
from fifads;


-- RELEASE CLAUSE
update fifads
set Release_clause_fixed = REPLACE(Release_Clause,'€','');

select TOP(5) Release_Clause, Release_clause_fixed
from fifads;


update fifads
set Release_clause_fixed = CAST(REPLACE(Release_clause_fixed, 'M','') AS decimal(18,2)) * 1000000
where Release_clause_fixed LIKE '%M%';

update fifads
set Release_clause_fixed = CAST(REPLACE(Release_clause_fixed, 'K','') AS decimal(18,2)) * 1000
where Release_clause_fixed LIKE '%K%';

select Release_clause_fixed, Release_Clause
from fifads;

-- CONCLUDE THE PROCESS
update fifads
set Release_clause_fixed = CAST(Release_clause_fixed AS decimal(18,2)),
	Wage_fixed = CAST(Wage_fixed AS decimal(18,2)),
	Value_Fixed = CAST(Value_Fixed AS decimal(18,2));

select Release_clause_fixed, Wage_fixed, Value_Fixed
from fifads

-- Let's Conclude this with the Hits
select Hits
from fifads;

alter table fifads
add Hits_fixed money null;

update fifads
set Hits_fixed = Hits;

update fifads
set Hits_fixed = CAST(Hits_fixed AS decimal(18,2)) * 1000
where LEFT(Hits_fixed, 2) LIKE '%.%' and LEFT(Hits_fixed,3) NOT LIKE '%0%';

update fifads
set Hits_fixed = CAST(Hits_fixed AS decimal(18,2));


select Hits_fixed, Hits
from fifads;