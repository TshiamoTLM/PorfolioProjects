select * from PortfolioProject..CovidDeaths$
order by 4,5


--Looking at Total case vs Total Deaths---

--Show the percentage of dealth if you had contract covid in SA--

Select Location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as  DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%South Africa'
Order by 1,2

--Shows what percentage of population got Covid--
Select Location,date,population, total_cases,total_deaths,(total_cases/population)*100 as  ContractedCovidPercentage
from PortfolioProject..CovidDeaths$
where location like '%South Africa'
Order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population---

Select Location,Population, Max(total_cases) as  HighestInfectionCount,Max((total_cases/population))* 100 as PopulationInfectedPercentage
from PortfolioProject..CovidDeaths$
Group by location,population
order by PopulationInfectedPercentage desc


--Show Countries with the highest death count per Population
Select Location,MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
Where continent is not null
Group By location
Order by TotalDeathCount desc

--Data of Covid deaths Broken down by Continent
Select Continent,MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
Where continent is not null
Group By continent
Order by TotalDeathCount desc;



--Global stats
Select Sum(new_cases) as Total_cases,sum(CAST(new_deaths as int)) as total_deaths, 
Sum(cast(new_deaths as int))/
Sum(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
 where continent is not null
--Group by date
 order by 1,2;

 ---Total Population vs vaccin stats--
  select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
  Sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
  from PortfolioProject..CovidDeaths$ dea
  join PortfolioProject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null 
  order by 2,3



  --USE CTE--

  With PopvsVac (Continent, Location, Date,Population,New_Vaccinations, RollingPeopleVaccinated)
  as
  (

	select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
  Sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
  from PortfolioProject..CovidDeaths$ dea
  join PortfolioProject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null 
  order by 2,3

  )
  select *,(RollingPeopleVaccinated/Population)*100 from PopvsVac

  --Temp Table
  DRop Table if exists #PopulationVaccinatedPercent
  Create Table #PopulationVaccinatedPercent
  (
	Continent varchar (255),
	Location varchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
  )

  Insert into #PopulationVaccinatedPercent
  select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
  Sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
  from PortfolioProject..CovidDeaths$ dea
  join PortfolioProject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date  

  Select *,(RollingPeopleVaccinated/Population)*100 from #PopulationVaccinatedPercent

