select * from covidvaccination1;
select * from coviddeaths1;

select * from coviddeaths1 order by 3,4; 
select * from covidvaccination1 order by 3,4;

-- select the data that we are going to be using--

select  location,date,total_cases,new_cases,total_deaths,population from coviddeaths1 order by 1,2;

-- lokking at total cases vs total deaths--
-- shows likelihood of dying if you contract covid in your country--


select  location,date,total_cases,total_deaths,(total_deaths/total_cases) as deathspercentage from coviddeaths1
 order by 1,2 asc ;
 
 select  location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathspercentage from coviddeaths1
 where location like '%Afghanistan%' order by 2,3 asc ;
 
 -- total cases vs population--
 select  location,date,population,total_cases,(total_cases/population)*100 as deathspercentage from coviddeaths1
  order by 1,2;
  
  -- looking aaaaaaaaat countries with highest infection rate compared at population--
  
select  location,population,max(total_cases) as highestinfectioncount,max((total_cases/population))*100 as percentpopulationinfected from coviddeaths1
group by location,population order by percentpopulationinfected desc;
 
 
-- showing countries with highest death count per population--
 
 select  location,max(total_deaths) as totaldeathcount from coviddeaths1
 where continent is not null group by location order by totaldeathcount;

select * from coviddeaths1 where continent is not null order by 3,4; 

select  location,max(total_deaths) as totaldeathcount from coviddeaths1
 where continent is not null group by location order by totaldeathcount;

-- lets break things by continent--

select location, continent,max(total_deaths) as totaldeathcount from coviddeaths1
where continent is not  null group by continent order by totaldeathcount desc;

-- lets break things down by continent
-- showing continents with the highest death count per population

select continent,max(total_deaths) as totaldeathcount from coviddeaths1
where continent is not null group by continent order by totaldeathcount ;

-- Global Numbers

select date,sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,sum(new_deaths)/sum(new_cases)*100 as deathcases from coviddeaths1 where continent is not null 
group by date
order by 1,2;

select sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,sum(new_deaths)/sum(new_cases)*100 as deathcases from coviddeaths1 where continent is not null 
order by 1,2;

-- join the two tables
select * from coviddeaths dea
join covidvaccination1 vac
on dea.location = vac.location
and dea.date = vac.date;

-- looking at total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from coviddeaths1 dea
join covidvaccination1 vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- USe Cte

with Popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from coviddeaths1 dea
join covidvaccination1 vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

)
select * ,(rollingpeoplevaccinated/population)*100 from Popvsvac;

-- temp table
create table percentpopulation
(continent nvarchar(255),
location nvarchar(255),
population numeric,
new_vaccination numeric,
rollingpeoplevaccinated numeric
)
insert into percentpopulation
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from coviddeaths1 dea
join covidvaccination1 vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not nullselect * ,(rollingpeoplevaccinated/population)*100 from Popvsvac;


-- create view to store data for later visualization

create view percentpopulation as
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from coviddeaths1 dea
join covidvaccination1 vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null;
 

 select * from percentpopulation;
 
 

