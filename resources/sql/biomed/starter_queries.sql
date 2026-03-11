-- 1) Cohort count by diagnosis code and age bucket at encounter time.
select
    d.code as diagnosis_code,
    case
        when (extract(year from e.encounter_date) - p.birth_year) < 40 then '<40'
        when (extract(year from e.encounter_date) - p.birth_year) between 40 and 59 then '40-59'
        else '60+'
    end as age_bucket,
    count(distinct p.patient_id) as patient_count
from patients p
join encounters e on p.patient_id = e.patient_id
join diagnoses d on d.encounter_id = e.encounter_id
group by d.code,
    case
        when (extract(year from e.encounter_date) - p.birth_year) < 40 then '<40'
        when (extract(year from e.encounter_date) - p.birth_year) between 40 and 59 then '40-59'
        else '60+'
    end
order by diagnosis_code, age_bucket;

-- 2) Mean feature value per diagnosis for a selected omics feature.
select
    d.code as diagnosis_code,
    avg(o.value) as mean_feature_value
from diagnoses d
join encounters e on e.encounter_id = d.encounter_id
join specimens s on s.patient_id = e.patient_id
join omics_features o on o.specimen_id = s.specimen_id
where o.feature_id = 'TP53_expr'
group by d.code
order by d.code;

-- 3) Time-window aggregation: diagnoses within 30 days of specimen collection.
select
    s.specimen_type,
    count(*) as diagnosis_events_near_collection
from specimens s
join encounters e on e.patient_id = s.patient_id
join diagnoses d on d.encounter_id = e.encounter_id
where abs(datediff(day, s.collection_date, d.diagnosis_date)) <= 30
group by s.specimen_type
order by s.specimen_type;

-- 4) Longitudinal monthly encounter volume per site.
select
    p.site_id,
    extract(year from e.encounter_date) as yr,
    extract(month from e.encounter_date) as mon,
    count(*) as encounter_count
from patients p
join encounters e on e.patient_id = p.patient_id
group by p.site_id, extract(year from e.encounter_date), extract(month from e.encounter_date)
order by p.site_id, yr, mon;

-- 5) Outcome summary by feature quantile buckets (coarse).
with tp53_per_patient as (
    select
        s.patient_id,
        avg(o.value) as tp53_avg
    from specimens s
    join omics_features o on o.specimen_id = s.specimen_id
    where o.feature_id = 'TP53_expr'
    group by s.patient_id
)
select
    case
        when t.tp53_avg < 9 then 'low'
        when t.tp53_avg < 12 then 'mid'
        else 'high'
    end as tp53_bucket,
    avg(outc.outcome_value) as avg_pfs_days,
    count(*) as patients
from tp53_per_patient t
join outcomes outc on outc.patient_id = t.patient_id
where outc.outcome_type = 'progression_free_survival_days'
group by
    case
        when t.tp53_avg < 9 then 'low'
        when t.tp53_avg < 12 then 'mid'
        else 'high'
    end
order by tp53_bucket;
