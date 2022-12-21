
select*
from PortfolioProject..['coviddeaths']
where continent is not null
order by 3,4



--select*
--from PortfolioProject..['covidvacination']
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..['coviddeaths']
where continent is not null
order by 1,2


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..['coviddeaths']
--where location like'%state%'
where continent is not null
order by 1,2


select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..['coviddeaths']
--where location like'%state%'
where continent is not null
order by 1,2


select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..['coviddeaths']
where continent is not null
GROUP BY location, population
order by PercentPopulationInfected desc


select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['coviddeaths']
where continent is not null
GROUP BY location
order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['coviddeaths']
where continent is not null
GROUP BY continent
order by TotalDeathCount desc


select SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..['coviddeaths']
--where location like'%state%'
where continent is not null
--group by date
order by 1,2



with popvsvac (continent,location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over( partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated--, ( RollingPeopleVaccinated/population)*100
from PortfolioProject..['coviddeaths'] dea
join PortfolioProject..['covidvacination'] vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,( RollingPeopleVaccinated/population)*100
from popvsvac





drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into  #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) over( partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..['coviddeaths'] dea
join PortfolioProject..['covidvacination'] vac
    on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select*,( RollingPeopleVaccinated/population)*100
from  #PercentPopulationVaccinated





create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) over( partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..['coviddeaths'] dea
join PortfolioProject..['covidvacination'] vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3



select*
from PercentPopulationVaccinated