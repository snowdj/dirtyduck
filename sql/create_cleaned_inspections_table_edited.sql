  create schema if not exists cleaned_randomized;

drop table if exists cleaned_randomized.inspections cascade;

create table cleaned_randomized.inspections as (
with cleaned as (
select
inspection,
btrim(lower(results)) as result,
license_num,
btrim(lower(dba_name)) as facility,
btrim(lower(aka_name)) as facility_aka,
case when
facility_type is null then 'unknown'
else btrim(lower(facility_type))
end as facility_type,
lower(substring(risk from '\((.+)\)')) as risk,
btrim(lower(address)) as address,
zip as zip_code,
substring(
btrim(lower(regexp_replace(type, 'liquor', 'task force', 'gi')))
from 'canvass|task force|complaint|food poisoning|consultation|license|tag removal') as type,
date,
ST_SetSRID(ST_MakePoint(longitude, latitude), 4326) as location
from raw_randomized.inspections
where zip is not null  -- removing NULL zip codes
)

select * from cleaned where type is not null
);
