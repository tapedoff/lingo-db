set persist=1;

create table patients (
    patient_id bigint,
    sex varchar(16),
    birth_year bigint,
    site_id varchar(32),
    primary key (patient_id)
);

create table encounters (
    encounter_id bigint,
    patient_id bigint not null,
    encounter_date date not null,
    encounter_type varchar(32),
    primary key (encounter_id)
);

create table diagnoses (
    diagnosis_id bigint,
    encounter_id bigint not null,
    code_system varchar(16) not null,
    code varchar(32) not null,
    diagnosis_date date,
    primary key (diagnosis_id)
);

create table specimens (
    specimen_id bigint,
    patient_id bigint not null,
    specimen_type varchar(32),
    collection_date date,
    primary key (specimen_id)
);

create table omics_features (
    feature_event_id bigint,
    specimen_id bigint not null,
    feature_id varchar(64) not null,
    value double not null,
    platform varchar(32),
    primary key (feature_event_id)
);

create table outcomes (
    outcome_id bigint,
    patient_id bigint not null,
    outcome_type varchar(32) not null,
    outcome_date date,
    outcome_value double,
    primary key (outcome_id)
);

insert into patients(patient_id, sex, birth_year, site_id) values
    (1001, 'female', 1972, 'site_a'),
    (1002, 'male',   1965, 'site_a'),
    (1003, 'female', 1988, 'site_b'),
    (1004, 'male',   1959, 'site_b'),
    (1005, 'female', 1979, 'site_c');

insert into encounters(encounter_id, patient_id, encounter_date, encounter_type) values
    (20001, 1001, date '2021-01-03', 'inpatient'),
    (20002, 1001, date '2021-06-11', 'followup'),
    (20003, 1002, date '2021-03-15', 'inpatient'),
    (20004, 1003, date '2021-08-21', 'outpatient'),
    (20005, 1004, date '2022-01-10', 'inpatient'),
    (20006, 1005, date '2022-02-17', 'followup');

insert into diagnoses(diagnosis_id, encounter_id, code_system, code, diagnosis_date) values
    (30001, 20001, 'ICD10', 'C50.9', date '2021-01-03'),
    (30002, 20002, 'ICD10', 'Z08',   date '2021-06-11'),
    (30003, 20003, 'ICD10', 'C34.1', date '2021-03-15'),
    (30004, 20004, 'ICD10', 'E11.9', date '2021-08-21'),
    (30005, 20005, 'ICD10', 'I21.9', date '2022-01-10'),
    (30006, 20006, 'ICD10', 'C50.9', date '2022-02-17');

insert into specimens(specimen_id, patient_id, specimen_type, collection_date) values
    (40001, 1001, 'tumor_biopsy', date '2021-01-04'),
    (40002, 1002, 'tumor_biopsy', date '2021-03-16'),
    (40003, 1003, 'blood',        date '2021-08-22'),
    (40004, 1004, 'blood',        date '2022-01-11'),
    (40005, 1005, 'tumor_biopsy', date '2022-02-18');

insert into omics_features(feature_event_id, specimen_id, feature_id, value, platform) values
    (50001, 40001, 'TP53_expr',  11.4, 'rna_seq'),
    (50002, 40001, 'EGFR_expr',   4.8, 'rna_seq'),
    (50003, 40002, 'TP53_expr',   8.7, 'rna_seq'),
    (50004, 40002, 'EGFR_expr',  12.2, 'rna_seq'),
    (50005, 40003, 'CRP_level',   2.5, 'proteomics'),
    (50006, 40004, 'CRP_level',   9.8, 'proteomics'),
    (50007, 40005, 'TP53_expr',  13.1, 'rna_seq'),
    (50008, 40005, 'EGFR_expr',   5.9, 'rna_seq');

insert into outcomes(outcome_id, patient_id, outcome_type, outcome_date, outcome_value) values
    (60001, 1001, 'progression_free_survival_days', date '2022-01-03', 365),
    (60002, 1002, 'progression_free_survival_days', date '2021-10-01', 200),
    (60003, 1003, 'hba1c_percent',                  date '2021-09-15', 7.4),
    (60004, 1004, 'troponin_ng_l',                  date '2022-01-10', 185.0),
    (60005, 1005, 'progression_free_survival_days', date '2023-02-17', 365);
