select * from Censusproject.dbo.Data1;

select * from Censusproject.dbo.Data2;


-- number of rows in our dataset
select count(*) from Censusproject..data1;
select count(*) from Censusproject..data2;


-- dataset for 2 states
select * from Censusproject..data1 where state in ('Jharkhand','Bihar')


-- population of India
select sum(population) Population from Censusproject..data2


-- Avg growth percentage for India
select avg(growth)*100 avg_growth from censusproject..data1


-- avg growth for every state in India
select state, avg(growth)*100 avg_growth from censusproject..data1 group by state;


-- avg sex ratio
select state, round(avg(sex_ratio),0) avg_sex_ratio from censusproject..data1 group by state;
select state, round(avg(sex_ratio),0) avg_sex_ratio from censusproject..data1 group by state order by avg_sex_ratio desc;


-- avg literacy rate
select state, round(avg(literacy),0) avg_literacy from censusproject..data1 group by state order by avg_literacy desc;

select state, round(avg(literacy),0) avg_literacy_ratio from censusproject..data1 
group by state having round (avg(literacy),0)>90 order by avg_literacy_ratio desc;



-- top 3 states showing highest growth ratio
select top 3 state, avg(growth)*100 avg_growth from censusproject..data1 group by state order by avg_growth desc;


-- bottom 3 states showing lowest sex ratio
select state, round(avg(sex_ratio),0) avg_sex_ratio from censusproject..data1 group by state order by avg_sex_ratio desc;


-- top and bottom 3 states in literacy state

 drop table if exists #topstates;
create table #topstates
( state nvarchar(255),
  topstate float

  )

insert into #topstates
select state,round(avg(literacy),0) avg_literacy_ratio from censusproject..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * from #topstates order by #topstates.topstate desc;

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
  bottomstate float

  )

insert into #bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from censusproject..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * from #bottomstates order by #bottomstates.bottomstate asc;


--union opertor

select * from (
select top 3 * from #topstates order by #topstates.topstate desc) a

union

select * from (
select top 3 * from #bottomstates order by #bottomstates.bottomstate asc) b;

--joining both tables

select a.district, a.state, a.sex_ratio, b.population from censusproject..data1 a inner join censusproject..data2 b on a.district = b.district
   
--total males and females

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from censusproject..data1 a inner join censusproject..data2 b on a.district=b.district ) c) d
group by d.state;


-- total literacy rate

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from censusproject..data1 a 
inner join censusproject..data2 b on a.district=b.district) d) c
group by c.state





