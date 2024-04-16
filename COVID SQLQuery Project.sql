select *
from PortfolioProjects..CovidDeaths
where continent is not null 
order by 3,4

/*select *
from PortfolioProjects..CovidVaccinations
order by 3,4 */

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
order by 1,2

-- Total cases VS Total deaths
-- Shows likelihood of dying if you contract covid in Nigeria
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProjects..CovidDeaths
where location = 'Nigeria'
order by 1,2

-- Total cases VS Population
-- Show percentage of the population that got covid
select Location, date,  population, total_cases, (total_cases/population)*100 as PercentageOfIntectedPopulation
from PortfolioProjects..CovidDeaths
where location = 'Nigeria'
order by 1,2

-- Countries with the highest infection rate
select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentageOfPopulationInfected
from PortfolioProjects..CovidDeaths
--where location = 'Nigeria'
Group by Location, population
order by PercentageOfPopulationInfected desc


-- Countries with the highest death rate per population
select Location,  MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Continent with the highest death rate 
select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global data
select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from PortfolioProjects..CovidDeaths
where continent is not null
Group by date
order by 1,2

--Total global number without date
select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from PortfolioProjects..CovidDeaths
where continent is not null
order by 1,2


-- Total population vs vacinations
select *
from PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--Sum of the vaccination per location
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population) * 100 
from PopvsVac

-- Temp table 
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Select *, (RollingPeopleVaccinated/Population) * 100 
from #PercentPopulationVaccinated
order by 2,3


-- creating views
USE PortfolioProjects;
GO
CREATE VIEW dbo.PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
GO

Select *
From PercentPopulationVaccinated