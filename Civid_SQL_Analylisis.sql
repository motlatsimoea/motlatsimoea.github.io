
--Checking that the data tables were imported properly
select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3, 4;

--select * 
--from PortfolioProject..Vaccinations
--order by 3, 4;

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2;



--Investigating Total Cases vs Total Deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [Death Rate]
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2;

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [Death Rate]
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2;

--Looking at the Rates in Lesotho and South Africa specifically.
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [Death Rate]
from PortfolioProject..CovidDeaths
where continent is not null
and location = 'Lesotho'
order by 1,2;


select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [Death Rate]
from PortfolioProject..CovidDeaths
where continent is not null
and location = 'South Africa'
order by 1,2;

--Looking at total cases vs Population

select Location, date, total_cases, population, (total_deaths/population)*100 as [Cases_per_Capita]
from PortfolioProject..CovidDeaths
where continent is not null
and location = 'South Africa'
order by 1,2;

select Location, date, total_cases, population, (total_deaths/population)*100 as [Cases_per_Capita]
from PortfolioProject..CovidDeaths
where continent is not null
and location = 'Lesotho'
order by 1,2;


--Countries with hightest Infection Rate

select Location, max(total_cases) as highestInfectionCount, population, max((total_cases/population))*100 as [Cases_per_Capita]
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by 4 desc;


--Countries with highest Death Rate per capita
select Location, max(cast(total_deaths as int)) as [Highest Mortality Count], population, max((cast(total_deaths as int)/population))*100 as [Deaths_per_Capita]
from PortfolioProject..CovidDeaths
where continent is null
group by location, population
order by [Highest Mortality Count] desc;


--Analysis by Continent

select continent, max(cast(total_deaths as int)) as [Highest Mortality Count]
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by [Highest Mortality Count] desc;


--Showing Continent with the highest Death Count Per Population


--Global Numbers

select date, sum(new_cases) as [total cases], sum(cast(new_deaths as int)) as [total deaths], sum(cast(new_deaths as int))/sum(new_cases)*100 as [Death Rate]
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2;

select sum(new_cases) as [total cases], sum(cast(new_deaths as int)) as [total deaths], sum(cast(new_deaths as int))/sum(new_cases)*100 as [Death Rate]
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2;


--Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)  as RollingTotalVaccinations

from PortfolioProject..CovidDeaths dea
inner join PortfolioProject..Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3;




--USE CTE
with PopvsVac (continent, location, date, population, new_vaccinations,  RollingTotalVaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)  as RollingTotalVaccinations
from PortfolioProject..CovidDeaths dea
inner join PortfolioProject..Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select * , (RollingTotalVaccinations/population)*100
from PopvsVac