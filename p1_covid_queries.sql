select * 
from covidP1.dbo.muertes 
order by 3,4

select * 
from covidP1.dbo.vacunacion 
order by 3,4


-- Selecciono las columnas que mas usare para visualizarlas
select location, date, total_cases, new_cases, total_deaths, population
from covidP1..muertes
order by 1, 2

-- Total de casos vs total de muertes (tasa de mortalidad)
select location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 as tasa_mortalidad
from covidP1..muertes
order by 1, 2

-- Casos totales vs poblacion
select location, date, population, total_cases, (total_cases / population) * 100 as tasa_infeccion
from covidP1..muertes
where location like '%chile%'
order by 1, 2

-- Porcentaje de poblacion con covid
select location, population, MAX(CAST(total_cases as int)) as total_casos, ROUND(MAX((total_cases / population)) * 100, 2) as porcentaje_poblacion_infectada
from covidP1..muertes
where location like '%and%'
group by location, population
order by porcentaje_poblacion_infectada desc

-- Porcentaje de poblacion con covid por fecha
select location, date, population, MAX(CAST(total_cases as int)) as total_casos, ROUND(MAX((total_cases / population)) * 100, 2) as porcentaje_poblacion_infectada
from covidP1..muertes
group by location, population, date
order by porcentaje_poblacion_infectada desc

-- Top muertos totales por paises
select location, population, MAX(CAST(total_deaths as int)) as total_muertes
from covidP1..muertes
group by location, population
order by total_muertes desc

-- Top muertos totales por continente 
select location, MAX(CAST(total_deaths as int)) as total_muertes
from covidP1..muertes
where continent is null and location not in ('world', 'european union', 'international', 'lower middle income', 'low income', 'high income', 'upper middle income')
group by location
order by total_muertes desc

-- Tasa de mortalidad global de todos los tiempos
select SUM(new_cases) as casos_totales, SUM(CAST(new_deaths as int)) as muertes_totales, 
	(SUM(cast(new_deaths as float)) / SUM(cast(new_cases as float))) * 100 as tasa_mortalidad
from covidP1..muertes
where continent is not null
order by 1, 2

-- Personas vacunadas en base a la poblacion
select mue.continent, mue.location, mue.date, mue.population, vac.new_vaccinations, vac.total_vaccinations,
(vac.total_vaccinations / mue.population) * 100 as 'porcentaje_vacunados_por_poblacion'
from covidP1..muertes mue
join covidP1..vacunacion vac
	on mue.location = vac.location
	and mue.date = vac.date
where mue.continent is not null
order by 2, 3
