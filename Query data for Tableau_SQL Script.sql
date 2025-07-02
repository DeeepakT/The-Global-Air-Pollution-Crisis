SELECT 
    aqi_who.country_name,
    aqi_who."City or Locality",
    TO_DATE(CAST(aqi_who.year_date AS TEXT) || '-01-01', 'YYYY-MM-DD') AS year_date, -- Convert year_date to proper date
    aqi_who."PM2.5 (?g/m3)",
    aqi_who."PM10 (?g/m3)",
    aqi_who."NO2 (?g/m3)",
    aqi_who."PM25 temporal coverage (%)",
    aqi_who."PM10 temporal coverage (%)",
    aqi_who."NO2 temporal coverage (%)",
    death_rate_from_air_pollution_2011_2021."Death rate per 100 k",
    death_by_risk_factor_year_2021."deaths_by_risk_factor_2021",
    death_by_risk_factor_year_2021."Cause of death",
    gdp_per_capita."GDP per capita",
    population_density."Population density",
    CAST(NULLIF(urbanization."Urban Pop. Rate", '') AS NUMERIC) AS "Urban Pop. Rate"
FROM 
    aqi_who
LEFT JOIN 
    death_rate_from_air_pollution_2011_2021
    ON aqi_who.country_name = death_rate_from_air_pollution_2011_2021.country_name
    AND TO_DATE(CAST(aqi_who.year_date AS TEXT) || '-01-01', 'YYYY-MM-DD') 
        = TO_DATE(CAST(death_rate_from_air_pollution_2011_2021.year_date AS TEXT) || '-01-01', 'YYYY-MM-DD')
LEFT JOIN 
    death_by_risk_factor_year_2021
    ON aqi_who.country_name = death_by_risk_factor_year_2021.country_name
LEFT JOIN 
    gdp_per_capita
    ON aqi_who.country_name = gdp_per_capita.country_name
LEFT JOIN 
    population_density
    ON aqi_who.country_name = population_density.country_name
LEFT JOIN 
    urbanization
    ON aqi_who.country_name = urbanization.country_name
WHERE 
    aqi_who.country_name IS NOT NULL
    AND (
        COALESCE(aqi_who."PM2.5 (?g/m3)", aqi_who."PM10 (?g/m3)", aqi_who."NO2 (?g/m3)", 
                 death_rate_from_air_pollution_2011_2021."Death rate per 100 k", 
                 death_by_risk_factor_year_2021."deaths_by_risk_factor_2021", 
                 gdp_per_capita."GDP per capita", 
                 population_density."Population density", 
                 CAST(NULLIF(urbanization."Urban Pop. Rate", '') AS NUMERIC)) IS NOT NULL
        OR 
        COALESCE(death_by_risk_factor_year_2021."Cause of death", '') <> ''
    )