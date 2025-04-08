select*
from layoffs;

create table layoffs1
like layoffs;

insert layoffs1
select *
from layoffs;

select *,
row_number() over(partition by company ,industry,total_laid_off,percentage_laid_off,'date')as row_num
from layoffs1;


##CHEKING FOR DUPLICATES
with duplicate_cte as
(select *,
row_number() over(partition by company ,industry,location,percentage_laid_off,'date',country,funds_raised_millions)as row_num
from layoffs1
)
select*
from duplicate_cte
where row_num >1;

##inserting row_num in colums
CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select*
from layoffs2;

##insert values
insert into layoffs2
(select *,
row_number() over(partition by company ,industry,location,percentage_laid_off,'date',country,funds_raised_millions)as row_num
from layoffs
);


##REMOVING DUPLICATES
SELECT *
FROM layoffs2
WHERE ROW_NUM >1;

DELETE
FROM layoffs2
WHERE ROW_NUM >1;

##STANDARDIZING DATA
SELECT company, TRIM(company)
from layoffs2;
update layoffs2
set company = TRIM(COMPANY);
select distinct industry
from layoffs2
order by 1;

##we have industries with similiar names crypto and cryto currency,to merge them:
select*
from layoffs2
where industry like "crypto%";

update layoffs2
set industry ='crypto%'
where industry like 'crypto%';

select distinct location
from layoffs2
order by 1;

select distinct country
from layoffs2
order by 1;

#united states came in two places to fix :


select distinct country,trim(trailing '.' from country)
from layoffs2
order by 1;

update layoffs2
set country =trim(trailing '.' from country)
where country like 'united states%';

select distinct country
from layoffs2
order by 1;

select date,
str_to_date(DATE,'%m/%d/%Y')
from layoffs2;

UPDATE layoffs2
SET DATE=str_to_date(DATE,'%m/%d/%Y');

##checking null values
select*
from layoffs2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs2
where total_laid_off is null
and percentage_laid_off is null;

select*
from layoffs2
where company is null
or company  ='';

select*
from layoffs2
where industry is null
or industry  ='';

select*
from layoffs2
where date is null
or date  ='';

delete
from layoffs2
where date is null
or date  ='';



 ###Looking at Percentage to see how big these layoffs were
 SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
 FROM layoffs2
 WHERE  percentage_laid_off IS NOT NULL;