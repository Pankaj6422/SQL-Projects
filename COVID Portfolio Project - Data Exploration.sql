select * from [dbo].[Coviddeaths]
order by 3,4;

--select * from [dbo].[Covidvaccinations]
--order by 3,4
go

select location,date,total_cases,new_cases,total_deaths,new_deaths,population
from [dbo].[Coviddeaths]
order by 1,2;
go


--Que 1. Total cases vs total deaths in India

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
from [dbo].[Coviddeaths]
WHERE location like '%India%'
order by 3 desc
go

--Que2. total cases vs population and what % of populatio got covid

select location,date,population,total_cases,
(total_deaths/population)*100 as deathPercentage
from [dbo].[Coviddeaths]
WHERE location like '%India%'
order by 1,2
go

-- que 3 . country with highest infection rate compared to population

select location,population,max(total_cases)as HighestInfectionCount,max(total_cases/population)*100 as percentPopulationInfected
from [dbo].[Coviddeaths]
--WHERE location like '%India%'
group by location,population
order by  percentPopulationInfected desc
go

--Que.4 countries with highest death count per population

select location,max(cast(total_deaths as bigint)) as total_death_count
from [dbo].[coviddeaths]
where continent is not null
group by location
order by total_death_count desc
go

--Que 5.breakdown things by continent

select continent,max(cast(total_deaths as bigint)) as total_death_count
from [dbo].[coviddeaths]
where continent is  not null
group by continent
order by total_death_count desc
go
--Que6. global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths,sum(cast(new_deaths as bigint))/sum(new_cases)*100 as deathPercentage
from [dbo].[coviddeaths]
where continent is not null	
order by 1,2
go

-- Que 7. looking at total population vs  vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location)
from [dbo].[coviddeaths] dea
join [dbo].[covidvaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
order by 2,3

