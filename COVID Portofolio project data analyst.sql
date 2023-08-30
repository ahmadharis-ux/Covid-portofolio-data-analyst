-- 1
SELECT * FROM coviddeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4 ;

-- 2
SELECT * FROM covidvaccinations
ORDER BY 3,4 ;

-- 3
SELECT location, DATE, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent IS NOT NULL 
ORDER BY 1,2;

-- 4
-- Melihat data total kasus vs data total kematian
-- shows likelihood OF dying if you contract covid IN your country
SELECT location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100  AS DeathPercentage
FROM coviddeaths
WHERE location LIKE '%indo%'
and continent IS NOT NULL 
ORDER BY 2;

-- 5
-- melihat total kasus dan populasi
-- Tunjukan persentasi covid dari populasi
SELECT location, DATE, population, total_cases, (total_cases/population)*100  AS DeathPercentage
FROM coviddeaths
WHERE location LIKE '%states%'
ORDER BY 1,2;

-- 6
-- melihat negara dengan tingkat infeksi tertinggi daripada populasinya
SELECT location,population, MAX(total_cases) AS JumlahInfeksiTertinggi, MAX((total_cases/population))*100 AS persentasiPopulasiTerinfeksi
FROM coviddeaths
-- WHERE location LIKE '%state%'
GROUP By location,population
ORDER BY persentasiPopulasiTerinfeksi DESC;

-- 7
-- showing countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- 8
-- LET'S BREAK THINGS DOWN BY CONTINENT
SELECT continent, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS not NULL  
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- 9
-- showing continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS not NULL  
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- 10
-- GLOBAL NUMBERS 
SELECT sum(new_cases) AS total_cases, SUM(CAST(new_deaths AS SIGNED)) AS total_deaths, SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2;


-- NOT WORKING
-- Looking at total population vs vaccinations
-- SELECT 
-- dea.continent, dea.location, dea.date, dea.population,
-- vac.new_vaccinations,
-- SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- -- ,(RollingPeopleVaccinated/population)*100
-- FROM coviddeaths dea 
-- JOIN covidvaccinations vac 
-- ON dea.location = vac.location
-- AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3;
-- 

-- Use CTE
WITH PopvsVac (continent, location, DATE,population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT 
dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM coviddeaths dea 
JOIN covidvaccinations vac 
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 
FROM PopvsVac;


-- TEMP TABLE

-- DROP TABLE if EXISTS #PercentPopulationVaccinated
-- CREATE TABLE #PercentPopulationVaccinated
-- (
-- continent NVARCHAR(255),
-- location NVARCHAR(255),
-- DATE DATETIME,
-- population NUMERIC,
-- new_vaccinations NUMERIC,
-- RollingPeopleVaccinated NUMERIC
-- )
-- 
-- INSERT INTO #PercentPopulationVaccinated
-- SELECT 
-- dea.continent, dea.location, dea.date, dea.population,
-- vac.new_vaccinations,
-- SUM(CONVERT (SIGNED, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- -- ,(RollingPeopleVaccinated/population)*100
-- FROM coviddeaths dea 
-- JOIN covidvaccinations vac 
-- ON dea.location = vac.location
-- AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- -- ORDER BY 2,3
-- 
-- SELECT *, (RollingPeopleVaccinated/population)*100 
-- FROM #PercentPopulationVaccinated

-- Creating view to store data for later visualizations
CREATE VIEW PercentagePopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinationsportofolioprojectpercentagepopulationvaccinated) OVER (PARTITION BY dea.location ORDER BY dea.location
, dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
-- ORDER BY 2,3;