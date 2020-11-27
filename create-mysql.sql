CREATE TABLE ae (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    aet               VARCHAR(250) BINARY NOT NULL,
    hostname          VARCHAR(250) BINARY NOT NULL,
    port              INTEGER NOT NULL,
    cipher_suites     VARCHAR(250) BINARY,
    pat_id_issuer     VARCHAR(250) BINARY,
    acc_no_issuer     VARCHAR(250) BINARY,
    user_id           VARCHAR(250) BINARY,
    passwd            VARCHAR(250) BINARY,
    fs_group_id       VARCHAR(250) BINARY,
    ae_group          VARCHAR(250) BINARY,
    ae_desc           VARCHAR(250) BINARY,
    wado_url          VARCHAR(250) BINARY,
    station_name      VARCHAR(250) BINARY,
    institution       VARCHAR(250) BINARY,
    department        VARCHAR(250) BINARY,
    installed         BIT NOT NULL,
    vendor_data       LONGBLOB
) ENGINE=INNODB;
CREATE UNIQUE INDEX aet ON ae(aet(64));
CREATE INDEX hostname ON ae(hostname(16));
CREATE INDEX ae_group ON ae(ae_group);

CREATE TABLE code (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    code_value        VARCHAR(250) BINARY NOT NULL,
    code_designator   VARCHAR(250) BINARY NOT NULL,
    code_version      VARCHAR(250) BINARY,
    code_meaning      VARCHAR(250) BINARY
) ENGINE=INNODB;
CREATE UNIQUE INDEX code_value ON code(code_value(64),code_designator(64),code_version(64));

CREATE TABLE issuer (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    entity_id         VARCHAR(250) BINARY,
    entity_uid        VARCHAR(250) BINARY,
    entity_uid_type   VARCHAR(250) BINARY
) ENGINE=INNODB;
CREATE UNIQUE INDEX entity_id ON issuer(entity_id(64));
CREATE UNIQUE INDEX entity_uid ON issuer(entity_uid(64),entity_uid_type(64));

CREATE TABLE patient (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    merge_fk          BIGINT,
    pat_id            VARCHAR(250) BINARY,
    pat_id_issuer     VARCHAR(250) BINARY,
    pat_name          VARCHAR(250) BINARY,
    pat_fn_sx         VARCHAR(250) BINARY,
    pat_gn_sx         VARCHAR(250) BINARY,
    pat_i_name        VARCHAR(250) BINARY,
    pat_p_name        VARCHAR(250) BINARY,
    pat_birthdate     VARCHAR(250) BINARY,
    pat_sex           VARCHAR(250) BINARY,
    pat_custom1       VARCHAR(250) BINARY,
    pat_custom2       VARCHAR(250) BINARY,
    pat_custom3       VARCHAR(250) BINARY,
    updated_time      DATETIME,
    created_time      DATETIME,
    pat_attrs         LONGBLOB
) ENGINE=INNODB;
ALTER TABLE patient
    ADD INDEX pat_merge_fk (merge_fk),
    ADD CONSTRAINT pat_merge_fk FOREIGN KEY (merge_fk) REFERENCES patient(pk);
CREATE INDEX pat_id ON patient(pat_id(64), pat_id_issuer(64));
CREATE INDEX pat_name ON patient(pat_name(64));
CREATE INDEX pat_fn_sx ON patient(pat_fn_sx(16));
CREATE INDEX pat_gn_sx ON patient(pat_gn_sx(16));
CREATE INDEX pat_i_name ON patient(pat_i_name(64));
CREATE INDEX pat_p_name ON patient(pat_p_name(64));
CREATE INDEX pat_birthdate ON patient(pat_birthdate(8));
CREATE INDEX pat_sex ON patient(pat_sex(1));
CREATE INDEX pat_custom1 ON patient(pat_custom1(64));
CREATE INDEX pat_custom2 ON patient(pat_custom2(64));
CREATE INDEX pat_custom3 ON patient(pat_custom3(64));

CREATE TABLE other_pid (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    pat_id            VARCHAR(250) BINARY NOT NULL,
    pat_id_issuer     VARCHAR(250) BINARY NOT NULL
) ENGINE=INNODB;
CREATE UNIQUE INDEX other_pat_id ON other_pid(pat_id(64), pat_id_issuer(64));

CREATE TABLE rel_pat_other_pid (
    patient_fk        BIGINT,
    other_pid_fk      BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_pat_other_pid
    ADD INDEX other_pid_pat_fk (patient_fk),
    ADD CONSTRAINT other_pid_pat_fk FOREIGN KEY (patient_fk) REFERENCES patient(pk);
ALTER TABLE rel_pat_other_pid
    ADD INDEX pat_other_pid_fk (other_pid_fk),
    ADD CONSTRAINT pat_other_pid_fk FOREIGN KEY (other_pid_fk) REFERENCES other_pid(pk);

CREATE TABLE study (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    patient_fk        BIGINT,
    accno_issuer_fk   BIGINT,
    study_iuid        VARCHAR(250) BINARY NOT NULL,
    study_id          VARCHAR(250) BINARY,
    study_datetime    DATETIME,
    accession_no      VARCHAR(250) BINARY,
    ref_physician     VARCHAR(250) BINARY,
    ref_phys_fn_sx    VARCHAR(250) BINARY,
    ref_phys_gn_sx    VARCHAR(250) BINARY,
    ref_phys_i_name   VARCHAR(250) BINARY,
    ref_phys_p_name   VARCHAR(250) BINARY,
    study_desc        VARCHAR(250) BINARY,
    study_custom1     VARCHAR(250) BINARY,
    study_custom2     VARCHAR(250) BINARY,
    study_custom3     VARCHAR(250) BINARY,
    study_status_id   VARCHAR(250) BINARY,
    mods_in_study     VARCHAR(250) BINARY,
    cuids_in_study    VARCHAR(250) BINARY,
    num_series        INTEGER NOT NULL,
    num_instances     INTEGER NOT NULL,
    ext_retr_aet      VARCHAR(250) BINARY,
    retrieve_aets     VARCHAR(250) BINARY,
    fileset_iuid      VARCHAR(250) BINARY,
    fileset_id        VARCHAR(250) BINARY,
    availability      INTEGER NOT NULL,
    study_status      INTEGER NOT NULL,
    checked_time      DATETIME,
    updated_time      DATETIME,
    created_time      DATETIME,
    study_attrs       LONGBLOB
) ENGINE=INNODB;
ALTER TABLE study
    ADD INDEX patient_fk (patient_fk),
    ADD CONSTRAINT patient_fk FOREIGN KEY (patient_fk) REFERENCES patient(pk);
ALTER TABLE study
    ADD INDEX accno_issuer_fk (accno_issuer_fk),
    ADD CONSTRAINT accno_issuer_fk FOREIGN KEY (accno_issuer_fk) REFERENCES issuer(pk);
CREATE UNIQUE INDEX study_iuid ON study(study_iuid(64));
CREATE INDEX study_id ON study(study_id(64));
CREATE INDEX study_datetime ON study(study_datetime);
CREATE INDEX accession_no ON study(accession_no(16));
CREATE INDEX ref_physician ON study(ref_physician(64));
CREATE INDEX ref_phys_fn_sx ON study(ref_phys_fn_sx(16));
CREATE INDEX ref_phys_gn_sx ON study(ref_phys_gn_sx(16));
CREATE INDEX ref_phys_i_name ON study(ref_phys_i_name(64));
CREATE INDEX ref_phys_p_name ON study(ref_phys_p_name(64));
CREATE INDEX study_desc ON study(study_desc(64));
CREATE INDEX study_custom1 ON study(study_custom1(64));
CREATE INDEX study_custom2 ON study(study_custom2(64));
CREATE INDEX study_custom3 ON study(study_custom3(64));
CREATE INDEX study_status_id ON study(study_status_id(16));
CREATE INDEX study_checked ON study(checked_time);
CREATE INDEX study_created ON study(created_time);
CREATE INDEX study_updated ON study(updated_time);
CREATE INDEX study_status ON study(study_status);

CREATE TABLE rel_study_pcode (
    study_fk          BIGINT,
    pcode_fk          BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_study_pcode
    ADD INDEX pcode_study_fk (study_fk),
    ADD CONSTRAINT pcode_study_fk FOREIGN KEY (study_fk) REFERENCES study(pk);
ALTER TABLE rel_study_pcode
    ADD INDEX study_pcode_fk (pcode_fk),
    ADD CONSTRAINT study_pcode_fk FOREIGN KEY (pcode_fk) REFERENCES code(pk);

CREATE TABLE study_permission (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    study_iuid        VARCHAR(250) BINARY NOT NULL,
    action            VARCHAR(250) BINARY NOT NULL,
    roles             VARCHAR(250) BINARY NOT NULL
) ENGINE=INNODB;
CREATE UNIQUE INDEX study_perm_idx ON study_permission(study_iuid(64), action(1), roles(16));

CREATE TABLE mpps (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    patient_fk        BIGINT,
    drcode_fk         BIGINT,
    mpps_iuid         VARCHAR(250) BINARY NOT NULL,
    pps_start         DATETIME,
    station_aet       VARCHAR(250) BINARY,
    modality          VARCHAR(250) BINARY,
    accession_no      VARCHAR(250) BINARY,
    mpps_status       INTEGER NOT NULL,
    updated_time      DATETIME,
    created_time      DATETIME,
    mpps_attrs        LONGBLOB
) ENGINE=INNODB;
ALTER TABLE mpps
    ADD INDEX mpps_patient_fk (patient_fk),
    ADD CONSTRAINT mpps_patient_fk FOREIGN KEY (patient_fk) REFERENCES patient(pk);
ALTER TABLE mpps
    ADD INDEX mpps_drcode_fk (drcode_fk),
    ADD CONSTRAINT mpps_drcode_fk FOREIGN KEY (drcode_fk) REFERENCES code(pk);
CREATE UNIQUE INDEX mpps_iuid ON mpps (mpps_iuid);
CREATE INDEX mpps_pps_start ON mpps (pps_start);
CREATE INDEX mpps_station_aet ON mpps (station_aet(16));
CREATE INDEX mpps_modality ON mpps (modality(16));
CREATE INDEX mpps_accession_no ON mpps (accession_no(16));    

CREATE TABLE series (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    study_fk          BIGINT,
    mpps_fk           BIGINT,
    inst_code_fk      BIGINT,
    series_iuid       VARCHAR(250) BINARY NOT NULL,
    series_no         VARCHAR(250) BINARY,
    modality          VARCHAR(250) BINARY,
    body_part         VARCHAR(250) BINARY,
    laterality        VARCHAR(250) BINARY,
    series_desc       VARCHAR(250) BINARY,
    institution       VARCHAR(250) BINARY,
    station_name      VARCHAR(250) BINARY,
    department        VARCHAR(250) BINARY,
    perf_physician    VARCHAR(250) BINARY,
    perf_phys_fn_sx   VARCHAR(250) BINARY,
    perf_phys_gn_sx   VARCHAR(250) BINARY,
    perf_phys_i_name  VARCHAR(250) BINARY,
    perf_phys_p_name  VARCHAR(250) BINARY,
    pps_start         DATETIME,
    pps_iuid          VARCHAR(250) BINARY,
    series_custom1    VARCHAR(250) BINARY,
    series_custom2    VARCHAR(250) BINARY,
    series_custom3    VARCHAR(250) BINARY,
    num_instances     INTEGER,
    src_aet           VARCHAR(250) BINARY,
    ext_retr_aet      VARCHAR(250) BINARY,
    retrieve_aets     VARCHAR(250) BINARY,
    fileset_iuid      VARCHAR(250) BINARY,
    fileset_id        VARCHAR(250) BINARY,
    availability      INTEGER NOT NULL,
    series_status     INTEGER NOT NULL,
    created_time      DATETIME,
    updated_time      DATETIME,
    series_attrs      LONGBLOB
) ENGINE=INNODB;
ALTER TABLE series
    ADD INDEX study_fk (study_fk),
    ADD CONSTRAINT study_fk FOREIGN KEY (study_fk) REFERENCES study(pk);
ALTER TABLE series
    ADD INDEX series_mpps_fk (mpps_fk),
    ADD CONSTRAINT series_mpps_fk FOREIGN KEY (mpps_fk) REFERENCES mpps(pk);
ALTER TABLE series
    ADD INDEX series_inst_code_fk (inst_code_fk),
    ADD CONSTRAINT series_inst_code_fk FOREIGN KEY (inst_code_fk) REFERENCES code(pk);
CREATE UNIQUE INDEX series_iuid ON series(series_iuid(64));
CREATE INDEX series_no ON series(series_no(16));
CREATE INDEX modality ON series(modality(16));
CREATE INDEX body_part ON series(body_part(16));
CREATE INDEX laterality ON series(laterality(16));
CREATE INDEX series_desc ON series(series_desc(64));
CREATE INDEX institution ON series(institution(64));
CREATE INDEX station_name ON series(station_name(16));
CREATE INDEX department ON series(department(64));
CREATE INDEX perf_physician ON series(perf_physician(64));
CREATE INDEX perf_phys_fn_sx ON series(perf_phys_fn_sx(16));
CREATE INDEX perf_phys_gn_sx ON series(perf_phys_gn_sx(16));
CREATE INDEX perf_phys_i_name ON series(perf_phys_i_name(64));
CREATE INDEX perf_phys_p_name ON series(perf_phys_p_name(64));
CREATE INDEX series_pps_start ON series(pps_start);
CREATE INDEX series_pps_iuid ON series (pps_iuid(64));
CREATE INDEX series_custom1 ON series(series_custom1(64));
CREATE INDEX series_custom2 ON series(series_custom2(64));
CREATE INDEX series_custom3 ON series(series_custom3(64));
CREATE INDEX series_src_aet ON series (src_aet(64));
CREATE INDEX series_status ON series(series_status);
CREATE INDEX series_created ON series(created_time);
CREATE INDEX series_updated ON series(updated_time);

CREATE TABLE series_req (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    series_fk         BIGINT,
    accno_issuer_fk   BIGINT,
    accession_no      VARCHAR(250) BINARY,
    study_iuid        VARCHAR(250) BINARY,
    req_proc_id       VARCHAR(250) BINARY,
    sps_id            VARCHAR(250) BINARY,
    req_service       VARCHAR(250) BINARY,
    req_physician     VARCHAR(250) BINARY,
    req_phys_fn_sx    VARCHAR(250) BINARY,
    req_phys_gn_sx    VARCHAR(250) BINARY,
    req_phys_i_name   VARCHAR(250) BINARY,
    req_phys_p_name   VARCHAR(250) BINARY
) ENGINE=INNODB;
ALTER TABLE series_req
    ADD INDEX ser_req_series_fk (series_fk),
    ADD CONSTRAINT ser_req_series_fk FOREIGN KEY (series_fk) REFERENCES series(pk);
ALTER TABLE series_req
    ADD INDEX ser_req_accno_issuer_fk (accno_issuer_fk),
    ADD CONSTRAINT ser_req_accno_issuer_fk FOREIGN KEY (accno_issuer_fk) REFERENCES issuer(pk);
CREATE INDEX ser_req_accession_no ON series_req(accession_no(16));
CREATE INDEX ser_req_study_iuid ON series_req(study_iuid(64));
CREATE INDEX ser_req_proc_id ON series_req(req_proc_id(16));
CREATE INDEX ser_req_sps_id ON series_req(sps_id(16));    
CREATE INDEX ser_req_service ON series_req(req_service(64));
CREATE INDEX ser_req_phys ON series_req(req_physician(64));
CREATE INDEX ser_req_phys_fn_sx ON series_req(req_phys_fn_sx(16));
CREATE INDEX ser_req_phys_gn_sx ON series_req(req_phys_gn_sx(16));
CREATE INDEX ser_req_phys_i ON series_req(req_phys_i_name(64));
CREATE INDEX ser_req_phys_p ON series_req(req_phys_p_name(64));

CREATE TABLE media (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    fileset_iuid      VARCHAR(250) BINARY NOT NULL,
    fileset_id        VARCHAR(250) BINARY,
    media_rq_iuid     VARCHAR(250) BINARY,
    media_status      INTEGER NOT NULL,
    media_status_info VARCHAR(250) BINARY,
    media_usage       BIGINT NOT NULL,
    created_time      DATETIME,
    updated_time      DATETIME
) ENGINE=INNODB;
CREATE UNIQUE INDEX fileset_iuid ON media(fileset_iuid);
CREATE INDEX media_status ON media(media_status);

CREATE TABLE instance (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    series_fk         BIGINT,
    srcode_fk         BIGINT,
    media_fk          BIGINT,
    sop_iuid          VARCHAR(250) BINARY NOT NULL,
    sop_cuid          VARCHAR(250) BINARY NOT NULL,
    inst_no           VARCHAR(250) BINARY,
    content_datetime  DATETIME,
    sr_complete       VARCHAR(250) BINARY,
    sr_verified       VARCHAR(250) BINARY,
    inst_custom1      VARCHAR(250) BINARY,
    inst_custom2      VARCHAR(250) BINARY,
    inst_custom3      VARCHAR(250) BINARY,    
    ext_retr_aet      VARCHAR(250) BINARY,
    retrieve_aets     VARCHAR(250) BINARY,
    availability      INTEGER NOT NULL,
    inst_status       INTEGER NOT NULL,
    all_attrs         BIT NOT NULL,
    commitment        BIT NOT NULL,
    archived          BIT NOT NULL,
    updated_time      DATETIME,
    created_time      DATETIME,
    inst_attrs        LONGBLOB
) ENGINE=INNODB;
ALTER TABLE instance
    ADD INDEX series_fk (series_fk),
    ADD CONSTRAINT series_fk FOREIGN KEY (series_fk) REFERENCES series(pk);
ALTER TABLE instance
    ADD INDEX srcode_fk (srcode_fk),
    ADD CONSTRAINT srcode_fk FOREIGN KEY (srcode_fk) REFERENCES code(pk);
ALTER TABLE instance
    ADD INDEX media_fk (media_fk),
    ADD CONSTRAINT media_fk FOREIGN KEY (media_fk) REFERENCES media(pk);
CREATE UNIQUE INDEX sop_iuid ON instance(sop_iuid(64));
CREATE INDEX sop_cuid ON instance(sop_cuid(64));
CREATE INDEX inst_no ON instance(inst_no(16));
CREATE INDEX content_datetime ON instance(content_datetime);
CREATE INDEX sr_complete ON instance(sr_complete(16));
CREATE INDEX sr_verified ON instance(sr_verified(16));
CREATE INDEX inst_custom1 ON instance(inst_custom1(64));
CREATE INDEX inst_custom2 ON instance(inst_custom2(64));
CREATE INDEX inst_custom3 ON instance(inst_custom3(64));
CREATE INDEX ext_retr_aet ON instance(ext_retr_aet(16));
CREATE INDEX commitment ON instance(commitment);
CREATE INDEX inst_status ON instance(inst_status);
CREATE INDEX inst_created ON instance(created_time);
CREATE INDEX inst_archived ON instance(archived);

CREATE TABLE verify_observer (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    instance_fk       BIGINT,
    verify_datetime   DATETIME,
    observer_name     VARCHAR(250) BINARY,
    observer_fn_sx    VARCHAR(250) BINARY,
    observer_gn_sx    VARCHAR(250) BINARY,
    observer_i_name   VARCHAR(250) BINARY,
    observer_p_name   VARCHAR(250) BINARY
) ENGINE=INNODB;
ALTER TABLE verify_observer
    ADD INDEX observer_inst_fk (instance_fk),
    ADD CONSTRAINT observer_inst_fk FOREIGN KEY (instance_fk) REFERENCES instance(pk);
CREATE INDEX verify_datetime ON verify_observer(verify_datetime);
CREATE INDEX observer_name ON verify_observer(observer_name(64));
CREATE INDEX observer_fn_sx ON verify_observer(observer_fn_sx(16));
CREATE INDEX observer_gn_sx ON verify_observer(observer_gn_sx(16));
CREATE INDEX observer_i_name ON verify_observer(observer_i_name(64));
CREATE INDEX observer_p_name ON verify_observer(observer_p_name(64));

CREATE TABLE content_item (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    instance_fk       BIGINT,
    name_fk           BIGINT,
    code_fk           BIGINT,
    rel_type          VARCHAR(250) BINARY,
    text_value        VARCHAR(250) BINARY
);
ALTER TABLE content_item
    ADD INDEX content_item_inst_fk (instance_fk),
    ADD CONSTRAINT content_item_inst_fk FOREIGN KEY (instance_fk) REFERENCES instance(pk);
ALTER TABLE content_item
    ADD INDEX content_item_name_fk (name_fk),
    ADD CONSTRAINT content_item_name_fk FOREIGN KEY (name_fk) REFERENCES code(pk);
ALTER TABLE content_item
    ADD INDEX content_item_code_fk (code_fk),
    ADD CONSTRAINT content_item_code_fk FOREIGN KEY (code_fk) REFERENCES code(pk);
CREATE INDEX content_item_rel_type ON content_item(rel_type(16));
CREATE INDEX content_item_text_value ON content_item(text_value(64));

CREATE TABLE filesystem (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    next_fk           BIGINT,
    dirpath           VARCHAR(250) BINARY NOT NULL,
    fs_group_id       VARCHAR(250) BINARY NOT NULL,
    retrieve_aet      VARCHAR(250) BINARY NOT NULL,
    availability      INTEGER NOT NULL,
    fs_status         INTEGER NOT NULL,
    user_info         VARCHAR(250) BINARY
) ENGINE=INNODB;
ALTER TABLE filesystem
    ADD INDEX fs_next_fk (next_fk),
    ADD CONSTRAINT fs_next_fk FOREIGN KEY (next_fk) REFERENCES filesystem(pk);
CREATE UNIQUE INDEX fs_dirpath ON filesystem(dirpath(64));
CREATE INDEX fs_group_id ON filesystem(fs_group_id(16));
CREATE INDEX fs_retrieve_aet ON filesystem(retrieve_aet(16));
CREATE INDEX fs_availability ON filesystem(availability);
CREATE INDEX fs_status ON filesystem(fs_status);

CREATE TABLE files (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    instance_fk       BIGINT,
    filesystem_fk     BIGINT,
    filepath          VARCHAR(250) BINARY NOT NULL,
    file_tsuid        VARCHAR(250) BINARY NOT NULL,
    file_md5          VARCHAR(250) BINARY,
    file_size         BIGINT,
    file_status       INTEGER,
    md5_check_time    DATETIME,
    created_time      DATETIME
) ENGINE=INNODB;
ALTER TABLE files
    ADD INDEX instance_fk (instance_fk),
    ADD CONSTRAINT instance_fk FOREIGN KEY (instance_fk) REFERENCES instance(pk);
ALTER TABLE files
    ADD INDEX filesystem_fk (filesystem_fk),
    ADD CONSTRAINT filesystem_fk FOREIGN KEY (filesystem_fk) REFERENCES filesystem(pk);
CREATE INDEX file_tsuid ON files(file_tsuid(64));
CREATE INDEX md5_check_time ON files(md5_check_time);
CREATE INDEX file_created ON files(created_time);
CREATE INDEX file_status ON files(file_status);
CREATE INDEX filepath ON files(filepath);

CREATE TABLE study_on_fs (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    study_fk          BIGINT,
    filesystem_fk     BIGINT,
    access_time       DATETIME NOT NULL,
    mark_to_delete    BIT NOT NULL
) ENGINE=INNODB;
ALTER TABLE study_on_fs
    ADD UNIQUE INDEX i_study_on_fs (study_fk, filesystem_fk),
    ADD CONSTRAINT i_study_on_fs FOREIGN KEY (study_fk) REFERENCES study(pk);
ALTER TABLE study_on_fs
    ADD INDEX fs_of_study (filesystem_fk),
    ADD CONSTRAINT fs_of_study FOREIGN KEY (filesystem_fk) REFERENCES filesystem(pk);
CREATE INDEX access_time ON study_on_fs(access_time);
CREATE INDEX mark_to_delete ON study_on_fs(mark_to_delete);

CREATE TABLE mwl_item (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    patient_fk        BIGINT,
    sps_status        INTEGER,
    sps_id            VARCHAR(250) BINARY,
    start_datetime    DATETIME NOT NULL,
    station_aet       VARCHAR(250) BINARY NOT NULL,
    station_name      VARCHAR(250) BINARY,
    modality          VARCHAR(250) BINARY NOT NULL,
    perf_physician    VARCHAR(250) BINARY,
    perf_phys_fn_sx   VARCHAR(250) BINARY,
    perf_phys_gn_sx   VARCHAR(250) BINARY,
    perf_phys_i_name  VARCHAR(250) BINARY,
    perf_phys_p_name  VARCHAR(250) BINARY,
    req_proc_id       VARCHAR(250) BINARY NOT NULL,
    accession_no      VARCHAR(250) BINARY,
    study_iuid        VARCHAR(250) BINARY NOT NULL,
    updated_time      DATETIME,
    created_time      DATETIME,
    item_attrs        LONGBLOB
) ENGINE=INNODB;
ALTER TABLE mwl_item
    ADD INDEX mwl_patient_fk (patient_fk),
    ADD CONSTRAINT mwl_patient_fk FOREIGN KEY (patient_fk) REFERENCES patient(pk);
CREATE INDEX sps_status ON mwl_item(sps_status);
CREATE UNIQUE INDEX mwl_sps_id ON mwl_item(sps_id(16),req_proc_id(16));
CREATE INDEX mwl_start_time ON mwl_item(start_datetime);
CREATE INDEX mwl_station_aet ON mwl_item(station_aet(16));
CREATE INDEX mwl_station_name ON mwl_item(station_name(16));
CREATE INDEX mwl_modality ON mwl_item(modality(16));
CREATE INDEX mwl_perf_physician ON mwl_item(perf_physician(64));
CREATE INDEX mwl_perf_phys_fn_sx ON mwl_item(perf_phys_fn_sx(16));
CREATE INDEX mwl_perf_phys_gn_sx ON mwl_item(perf_phys_gn_sx(16));
CREATE INDEX mwl_perf_phys_i_nm ON mwl_item(perf_phys_i_name(64));
CREATE INDEX mwl_perf_phys_p_nm ON mwl_item(perf_phys_p_name(64));
CREATE INDEX mwl_req_proc_id ON mwl_item(req_proc_id(16));
CREATE INDEX mwl_accession_no ON mwl_item(accession_no(16));
CREATE INDEX mwl_study_iuid ON mwl_item(study_iuid(64));

CREATE TABLE gpsps (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    patient_fk        BIGINT,
    code_fk           BIGINT,
    gpsps_iuid        VARCHAR(250) BINARY NOT NULL,
    gpsps_tuid        VARCHAR(250) BINARY,
    start_datetime    DATETIME NOT NULL,
    end_datetime      DATETIME,
    gpsps_status      INTEGER,
    gpsps_prior       INTEGER,
    in_availability   INTEGER,
    item_attrs        LONGBLOB
) ENGINE=INNODB;
ALTER TABLE gpsps
    ADD INDEX gpsps_patient_fk (patient_fk),
    ADD CONSTRAINT gpsps_patient_fk FOREIGN KEY (patient_fk) REFERENCES patient(pk);
ALTER TABLE gpsps
    ADD INDEX gpsps_code_fk (code_fk),
    ADD CONSTRAINT gpsps_code_fk FOREIGN KEY (code_fk) REFERENCES code(pk);
CREATE UNIQUE INDEX gpsps_iuid ON gpsps(gpsps_iuid(64));
CREATE INDEX gpsps_tuid ON gpsps(gpsps_tuid(64));
CREATE INDEX gpsps_start_time ON gpsps(start_datetime);
CREATE INDEX gpsps_end_time ON gpsps(end_datetime);
CREATE INDEX gpsps_status ON gpsps(gpsps_status);
CREATE INDEX gpsps_prior ON gpsps(gpsps_prior);
CREATE INDEX in_availability ON gpsps(in_availability);

CREATE TABLE rel_gpsps_appcode (
    gpsps_fk          BIGINT,
    appcode_fk        BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_gpsps_appcode
    ADD INDEX appcode_gpsps_fk (gpsps_fk),
    ADD CONSTRAINT appcode_gpsps_fk FOREIGN KEY (gpsps_fk) REFERENCES gpsps(pk);
ALTER TABLE rel_gpsps_appcode
    ADD INDEX gpsps_appcode_fk (appcode_fk),
    ADD CONSTRAINT gpsps_appcode_fk FOREIGN KEY (appcode_fk) REFERENCES code(pk);

CREATE TABLE rel_gpsps_devname (
    gpsps_fk          BIGINT,
    devname_fk        BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_gpsps_devname
    ADD INDEX devname_gpsps_fk (gpsps_fk),
    ADD CONSTRAINT devname_gpsps_fk FOREIGN KEY (gpsps_fk) REFERENCES gpsps(pk);
ALTER TABLE rel_gpsps_devname
    ADD INDEX gpsps_devname_fk (devname_fk),
    ADD CONSTRAINT gpsps_devname_fk FOREIGN KEY (devname_fk) REFERENCES code(pk);

CREATE TABLE rel_gpsps_devclass (
    gpsps_fk          BIGINT,
    devclass_fk       BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_gpsps_devclass
    ADD INDEX devclass_gpsps_fk (gpsps_fk),
    ADD CONSTRAINT devclass_gpsps_fk FOREIGN KEY (gpsps_fk) REFERENCES gpsps(pk);
ALTER TABLE rel_gpsps_devclass
    ADD INDEX gpsps_devclass_fk (devclass_fk),
    ADD CONSTRAINT gpsps_devclass_fk FOREIGN KEY (devclass_fk) REFERENCES code(pk);

CREATE TABLE rel_gpsps_devloc (
    gpsps_fk          BIGINT,
    devloc_fk         BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_gpsps_devloc
    ADD INDEX devloc_gpsps_fk (gpsps_fk),
    ADD CONSTRAINT devloc_gpsps_fk FOREIGN KEY (gpsps_fk) REFERENCES gpsps(pk);
ALTER TABLE rel_gpsps_devloc
    ADD INDEX gpsps_devloc_fk (devloc_fk),
    ADD CONSTRAINT gpsps_devloc_fk FOREIGN KEY (devloc_fk) REFERENCES code(pk);

CREATE TABLE gpsps_perf (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    gpsps_fk          BIGINT,
    code_fk           BIGINT,
    human_perf_name   VARCHAR(250) BINARY,
    hum_perf_fn_sx    VARCHAR(250) BINARY,
    hum_perf_gn_sx    VARCHAR(250) BINARY,
    hum_perf_i_name   VARCHAR(250) BINARY,
    hum_perf_p_name   VARCHAR(250) BINARY
) ENGINE=INNODB;
ALTER TABLE gpsps_perf
    ADD INDEX gpsps_perf_sps_fk (gpsps_fk),
    ADD CONSTRAINT gpsps_perf_sps_fk FOREIGN KEY (gpsps_fk) REFERENCES gpsps(pk);
ALTER TABLE gpsps_perf
    ADD INDEX gpsps_perf_code_fk (code_fk),
    ADD CONSTRAINT gpsps_perf_code_fk FOREIGN KEY (code_fk) REFERENCES code(pk);
CREATE INDEX gpsps_perf_name ON gpsps_perf(human_perf_name(64));
CREATE INDEX gpsps_perf_fn_sx ON gpsps_perf(hum_perf_fn_sx(16));
CREATE INDEX gpsps_perf_gn_sx ON gpsps_perf(hum_perf_gn_sx(16));
CREATE INDEX gpsps_perf_i_name ON gpsps_perf(hum_perf_i_name(64));
CREATE INDEX gpsps_perf_p_name ON gpsps_perf(hum_perf_p_name(64));

CREATE TABLE gpsps_req (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    gpsps_fk          BIGINT,
    req_proc_id       VARCHAR(250) BINARY,
    accession_no      VARCHAR(250) BINARY
) ENGINE=INNODB;
ALTER TABLE gpsps_req
    ADD INDEX gpsps_req_gpsps_fk (gpsps_fk),
    ADD CONSTRAINT gpsps_req_gpsps_fk FOREIGN KEY (gpsps_fk) REFERENCES gpsps(pk);
CREATE INDEX gpsps_req_proc_id ON gpsps_req(req_proc_id);
CREATE INDEX gpsps_req_acc_no ON gpsps_req(accession_no);    

CREATE TABLE gppps (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    patient_fk        BIGINT,
    pps_iuid          VARCHAR(250) BINARY NOT NULL,
    pps_start         DATETIME,
    pps_status        INTEGER NOT NULL,
    created_time      DATETIME,
    updated_time      DATETIME,
    pps_attrs         LONGBLOB
) ENGINE=INNODB;
ALTER TABLE gppps
    ADD INDEX gppps_patient_fk (patient_fk),
    ADD CONSTRAINT gppps_patient_fk FOREIGN KEY (patient_fk) REFERENCES patient(pk);
CREATE UNIQUE INDEX gppps_iuid ON gppps (pps_iuid);
CREATE INDEX gppps_pps_start ON gppps (pps_start);

CREATE TABLE rel_gpsps_gppps (
    gpsps_fk          BIGINT,
    gppps_fk          BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_gpsps_gppps
    ADD INDEX gppps_gpsps_fk (gpsps_fk),
    ADD CONSTRAINT gppps_gpsps_fk FOREIGN KEY (gpsps_fk) REFERENCES gpsps(pk);
ALTER TABLE rel_gpsps_gppps
    ADD INDEX gpsps_gppps_fk (gppps_fk),
    ADD CONSTRAINT gpsps_gppps_fk FOREIGN KEY (gppps_fk) REFERENCES gppps(pk);

CREATE TABLE ups (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    patient_fk        BIGINT,
    code_fk           BIGINT,
    ups_iuid          VARCHAR(250) BINARY NOT NULL,
    ups_tuid          VARCHAR(250) BINARY,
    adm_id            VARCHAR(250) BINARY,
    adm_id_issuer_id  VARCHAR(250) BINARY,
    adm_id_issuer_uid VARCHAR(250) BINARY,
    ups_label         VARCHAR(250) BINARY NOT NULL,
    uwl_label         VARCHAR(250) BINARY NOT NULL,
    ups_start_time    DATETIME NOT NULL,
    ups_compl_time    DATETIME,
    ups_state         INTEGER,
    ups_prior         INTEGER,
    created_time      DATETIME,
    updated_time      DATETIME,
    ups_attrs         LONGBLOB
);
ALTER TABLE ups
    ADD INDEX ups_patient_fk (patient_fk),
    ADD CONSTRAINT ups_patient_fk FOREIGN KEY (patient_fk) REFERENCES patient(pk);
ALTER TABLE ups
    ADD INDEX ups_code_fk (code_fk),
    ADD CONSTRAINT ups_code_fk FOREIGN KEY (code_fk) REFERENCES code(pk);
CREATE UNIQUE INDEX ups_iuid ON ups(ups_iuid);
CREATE INDEX ups_tuid ON ups(ups_tuid);
CREATE INDEX ups_adm_id ON ups(adm_id);
CREATE INDEX ups_adm_id_issuer_id ON ups(adm_id_issuer_id);
CREATE INDEX ups_adm_id_issuer_uid ON ups(adm_id_issuer_uid);
CREATE INDEX ups_label ON ups(ups_label);
CREATE INDEX uwl_label ON ups(uwl_label);
CREATE INDEX ups_start_time ON ups(ups_start_time);
CREATE INDEX ups_compl_time ON ups(ups_compl_time);
CREATE INDEX ups_state ON ups(ups_state);
CREATE INDEX ups_prior ON ups(ups_prior);
CREATE INDEX ups_updated_time ON ups(updated_time);

CREATE TABLE rel_ups_appcode (
    ups_fk            BIGINT,
    appcode_fk        BIGINT
);
ALTER TABLE rel_ups_appcode
    ADD INDEX appcode_ups_fk (ups_fk),
    ADD CONSTRAINT appcode_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
ALTER TABLE rel_ups_appcode
    ADD INDEX ups_appcode_fk (appcode_fk),
    ADD CONSTRAINT ups_appcode_fk FOREIGN KEY (appcode_fk) REFERENCES code(pk);

CREATE TABLE rel_ups_devname (
    ups_fk            BIGINT,
    devname_fk        BIGINT
);
ALTER TABLE rel_ups_devname
    ADD INDEX devname_ups_fk (ups_fk),
    ADD CONSTRAINT devname_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
ALTER TABLE rel_ups_devname
    ADD INDEX ups_devname_fk (devname_fk),
    ADD CONSTRAINT ups_devname_fk FOREIGN KEY (devname_fk) REFERENCES code(pk);

CREATE TABLE rel_ups_devclass (
    ups_fk            BIGINT,
    devclass_fk       BIGINT
);
ALTER TABLE rel_ups_devclass
    ADD INDEX devclass_ups_fk (ups_fk),
    ADD CONSTRAINT devclass_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
ALTER TABLE rel_ups_devclass
    ADD INDEX ups_devclass_fk (devclass_fk),
    ADD CONSTRAINT ups_devclass_fk FOREIGN KEY (devclass_fk) REFERENCES code(pk);

CREATE TABLE rel_ups_devloc (
    ups_fk            BIGINT,
    devloc_fk         BIGINT
);
ALTER TABLE rel_ups_devloc
    ADD INDEX devloc_ups_fk (ups_fk),
    ADD CONSTRAINT devloc_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
ALTER TABLE rel_ups_devloc
    ADD INDEX ups_devloc_fk (devloc_fk),
    ADD CONSTRAINT ups_devloc_fk FOREIGN KEY (devloc_fk) REFERENCES code(pk);

CREATE TABLE rel_ups_performer (
    ups_fk            BIGINT,
    performer_fk      BIGINT
);
ALTER TABLE rel_ups_performer
    ADD INDEX performer_ups_fk (ups_fk),
    ADD CONSTRAINT performer_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
ALTER TABLE rel_ups_performer
    ADD INDEX ups_performer_fk (performer_fk),
    ADD CONSTRAINT ups_performer_fk FOREIGN KEY (performer_fk) REFERENCES code(pk);

CREATE TABLE ups_req (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ups_fk            BIGINT,
    req_proc_id       VARCHAR(250) BINARY,
    accession_no      VARCHAR(250) BINARY,
    confidentiality   VARCHAR(250) BINARY,
    req_service       VARCHAR(250) BINARY
);
ALTER TABLE ups_req
    ADD INDEX ups_req_ups_fk (ups_fk),
    ADD CONSTRAINT ups_req_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
CREATE INDEX ups_req_proc_id ON ups_req(req_proc_id);
CREATE INDEX ups_req_acc_no ON ups_req(accession_no);
CREATE INDEX ups_confidentiality ON ups_req(confidentiality);
CREATE INDEX ups_req_service ON ups_req(req_service);

CREATE TABLE ups_rel_ps (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ups_fk            BIGINT,
    sop_iuid          VARCHAR(250) BINARY NOT NULL,
    sop_cuid          VARCHAR(250) BINARY NOT NULL
);
ALTER TABLE ups_rel_ps
    ADD INDEX ups_rel_ps_ups_fk (ups_fk),
    ADD CONSTRAINT ups_rel_ps_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
CREATE INDEX ups_rel_ps_iuid ON ups_rel_ps(sop_iuid);
CREATE INDEX ups_rel_ps_cuid ON ups_rel_ps(sop_cuid);

CREATE TABLE ups_repl_ps (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ups_fk            BIGINT,
    sop_iuid          VARCHAR(250) BINARY NOT NULL,
    sop_cuid          VARCHAR(250) BINARY NOT NULL
);
ALTER TABLE ups_repl_ps
    ADD INDEX ups_repl_ps_ups_fk (ups_fk),
    ADD CONSTRAINT ups_repl_ps_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
CREATE INDEX ups_repl_ps_iuid ON ups_repl_ps(sop_iuid);
CREATE INDEX ups_repl_ps_cuid ON ups_repl_ps(sop_cuid);

CREATE TABLE ups_subscr (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ups_fk            BIGINT,
    aet               VARCHAR(250) BINARY NOT NULL,
    deletion_lock     BIT NOT NULL
);
ALTER TABLE ups_subscr
    ADD INDEX ups_subscr_ups_fk (ups_fk),
    ADD CONSTRAINT ups_subscr_ups_fk FOREIGN KEY (ups_fk) REFERENCES ups(pk);
CREATE INDEX ups_deletion_lock ON ups_subscr(deletion_lock);
CREATE INDEX ups_subscr_aet ON ups_subscr(aet);

CREATE TABLE ups_glob_subscr (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    aet               VARCHAR(250) BINARY NOT NULL,
    deletion_lock     BIT NOT NULL
);
CREATE UNIQUE INDEX ups_glob_subscr_aet ON ups_glob_subscr(aet);

CREATE TABLE hp (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_fk           BIGINT,
    hp_iuid           VARCHAR(250) BINARY NOT NULL,
    hp_cuid           VARCHAR(250) BINARY,
    hp_name           VARCHAR(250) BINARY,
    hp_group          VARCHAR(250) BINARY,
    hp_level          INTEGER,
    num_priors        INTEGER,
    num_screens       INTEGER,
    hp_attrs          LONGBLOB
) ENGINE=INNODB;
ALTER TABLE hp
    ADD INDEX hp_user_fk (user_fk),
    ADD CONSTRAINT hp_user_fk FOREIGN KEY (user_fk) REFERENCES code(pk);
CREATE UNIQUE INDEX hp_iuid ON hp(hp_iuid(64));
CREATE INDEX hp_cuid ON hp(hp_cuid(64));
CREATE INDEX hp_name ON hp(hp_name(64));
CREATE INDEX hp_level ON hp(hp_level);
CREATE INDEX num_priors ON hp(num_priors);
CREATE INDEX num_screens ON hp(num_screens);

CREATE TABLE hpdef (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    hp_fk             BIGINT,
    modality          VARCHAR(250) BINARY,
    laterality        VARCHAR(250) BINARY
) ENGINE=INNODB;
ALTER TABLE hpdef
    ADD INDEX hp_fk (hp_fk),
    ADD CONSTRAINT hp_fk FOREIGN KEY (hp_fk) REFERENCES hp(pk);
CREATE INDEX hpdef_modality ON hpdef(modality(16));
CREATE INDEX hpdef_laterality ON hpdef(laterality(16));

CREATE TABLE rel_hpdef_region (
    hpdef_fk          BIGINT,
    region_fk         BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_hpdef_region
    ADD INDEX region_hpdef_fk (hpdef_fk),
    ADD CONSTRAINT region_hpdef_fk FOREIGN KEY (hpdef_fk) REFERENCES hpdef(pk);
ALTER TABLE rel_hpdef_region
    ADD INDEX hpdef_region_fk (region_fk),
    ADD CONSTRAINT hpdef_region_fk FOREIGN KEY (region_fk) REFERENCES code(pk);

CREATE TABLE rel_hpdef_proc (
    hpdef_fk          BIGINT,
    proc_fk           BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_hpdef_proc
    ADD INDEX proc_hpdef_fk (hpdef_fk),
    ADD CONSTRAINT proc_hpdef_fk FOREIGN KEY (hpdef_fk) REFERENCES hpdef(pk);
ALTER TABLE rel_hpdef_proc
    ADD INDEX hpdef_proc_fk (proc_fk),
    ADD CONSTRAINT hpdef_proc_fk FOREIGN KEY (proc_fk) REFERENCES code(pk);

CREATE TABLE rel_hpdef_reason (
    hpdef_fk          BIGINT,
    reason_fk         BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_hpdef_reason
    ADD INDEX reason_hpdef_fk (hpdef_fk),
    ADD CONSTRAINT reason_hpdef_fk FOREIGN KEY (hpdef_fk) REFERENCES hpdef(pk);
ALTER TABLE rel_hpdef_reason
    ADD INDEX hpdef_reason_fk (reason_fk),
    ADD CONSTRAINT hpdef_reason_fk FOREIGN KEY (reason_fk) REFERENCES code(pk);

CREATE TABLE priv_patient (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    priv_type         INTEGER NOT NULL,
    pat_id            VARCHAR(250) BINARY,
    pat_id_issuer     VARCHAR(250) BINARY,
    pat_name          VARCHAR(250) BINARY,
    pat_attrs         LONGBLOB
) ENGINE=INNODB;
CREATE INDEX priv_pat_id ON priv_patient(pat_id, pat_id_issuer(64));
CREATE INDEX priv_pat_name ON priv_patient(pat_name(64));
CREATE INDEX priv_pat_type ON priv_patient(priv_type);

CREATE TABLE priv_study (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    patient_fk        BIGINT,
    priv_type         INTEGER NOT NULL,
    study_iuid        VARCHAR(250) BINARY NOT NULL,
    accession_no      VARCHAR(250) BINARY,
    study_attrs       LONGBLOB
) ENGINE=INNODB;
ALTER TABLE priv_study
    ADD INDEX priv_patient_fk (patient_fk),
    ADD CONSTRAINT priv_patient_fk FOREIGN KEY (patient_fk) REFERENCES priv_patient(pk);
CREATE INDEX priv_study_type ON priv_study(priv_type);
CREATE INDEX priv_study_iuid ON priv_study(study_iuid(64));
CREATE INDEX priv_study_accs_no ON priv_study(accession_no(16));

CREATE TABLE priv_series (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    study_fk          BIGINT,
    priv_type         INTEGER NOT NULL,
    series_iuid       VARCHAR(250) BINARY NOT NULL,
    src_aet           VARCHAR(250) BINARY,
    series_attrs      LONGBLOB
) ENGINE=INNODB;
ALTER TABLE priv_series
    ADD INDEX priv_study_fk (study_fk),
    ADD CONSTRAINT priv_study_fk FOREIGN KEY (study_fk) REFERENCES priv_study(pk);
CREATE INDEX priv_series_type ON priv_series(priv_type);
CREATE INDEX priv_series_iuid ON priv_series(series_iuid(64));
CREATE INDEX priv_ser_src_aet ON priv_series(src_aet(16));


CREATE TABLE priv_instance (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    series_fk         BIGINT,
    priv_type         INTEGER NOT NULL,
    sop_iuid          VARCHAR(250) BINARY NOT NULL,
    created_time      DATETIME,
    inst_attrs        LONGBLOB
) ENGINE=INNODB;
ALTER TABLE priv_instance
    ADD INDEX priv_series_fk (series_fk),
    ADD CONSTRAINT priv_series_fk FOREIGN KEY (series_fk) REFERENCES priv_series(pk);
CREATE INDEX priv_inst_type ON priv_instance(priv_type);
CREATE INDEX priv_sop_iuid ON priv_instance(sop_iuid(64));
CREATE INDEX priv_inst_created ON priv_instance(created_time);

CREATE TABLE priv_file (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    instance_fk       BIGINT,
    filesystem_fk     BIGINT,
    filepath          VARCHAR(250) BINARY NOT NULL,
    file_tsuid        VARCHAR(250) BINARY NOT NULL,
    file_md5          VARCHAR(250) BINARY,
    file_size         BIGINT,
    file_status       INTEGER
) ENGINE=INNODB;
ALTER TABLE priv_file
    ADD INDEX priv_instance_fk (instance_fk),
    ADD CONSTRAINT priv_instance_fk FOREIGN KEY (instance_fk) REFERENCES priv_instance(pk);
ALTER TABLE priv_file
    ADD INDEX priv_fs_fk (filesystem_fk),
    ADD CONSTRAINT priv_fs_fk FOREIGN KEY (filesystem_fk) REFERENCES filesystem(pk);

CREATE TABLE published_study (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    study_fk          BIGINT,
    created_time      DATETIME,
    updated_time      DATETIME,
    doc_uid           VARCHAR(250) BINARY,
    docentry_uid      VARCHAR(250) BINARY,
    repository_uid    VARCHAR(250) BINARY,
    status		      INT NOT NULL,
FOREIGN KEY (study_fk) REFERENCES study(pk)
);
CREATE INDEX published_study ON published_study(study_fk);
CREATE INDEX published_study_status ON published_study(status);
CREATE INDEX repository_uid ON published_study(repository_uid);

CREATE TABLE device (
    pk                BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    station_name      VARCHAR(250) BINARY NOT NULL,
    station_aet       VARCHAR(250) BINARY NOT NULL,
    modality          VARCHAR(250) BINARY NOT NULL
) ENGINE=INNODB;
CREATE UNIQUE INDEX dev_station_name ON device(station_name(16));

CREATE TABLE rel_dev_proto (
    device_fk         BIGINT,
    prcode_fk         BIGINT
) ENGINE=INNODB;
ALTER TABLE rel_dev_proto
    ADD INDEX device_fk (device_fk),
    ADD CONSTRAINT device_fk FOREIGN KEY (device_fk) REFERENCES device(pk);
ALTER TABLE rel_dev_proto
    ADD INDEX prcode_fk (prcode_fk),
    ADD CONSTRAINT prcode_fk FOREIGN KEY (prcode_fk) REFERENCES code(pk);

CREATE TABLE users(
    user_id           VARCHAR(250) BINARY NOT NULL PRIMARY KEY,
    passwd            VARCHAR(250) BINARY
) ENGINE=INNODB;
CREATE TABLE roles(
    user_id           VARCHAR(250) BINARY,
    roles             VARCHAR(250) BINARY
) ENGINE=INNODB;
ALTER TABLE roles
    ADD INDEX roles_user_id (user_id),
    ADD CONSTRAINT roles_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);

INSERT INTO users VALUES('admin','0DPiKuNIrrVmD8IUCuw1hQxNqZc=');
INSERT INTO roles VALUES('admin','JBossAdmin');
INSERT INTO roles VALUES('admin','WebAdmin');
INSERT INTO roles VALUES('admin','WebUser');
INSERT INTO roles VALUES('admin','McmUser');
INSERT INTO roles VALUES('admin','AuditLogUser');
INSERT INTO roles VALUES('admin','Doctor');

INSERT INTO users VALUES('user','Et6pb+wgWTVmq3VpLJlJWWgzrck=');
INSERT INTO roles VALUES('user','WebUser');
INSERT INTO roles VALUES('user','McmUser');
INSERT INTO roles VALUES('user','Doctor');

INSERT INTO ae (aet,hostname,port,pat_id_issuer,ae_desc,installed)
    VALUES('DCM4CHEE','localhost',11112,'DCM4CHEE','This dcm4chee archive instance',1);
INSERT INTO ae (aet,hostname,port,ae_desc,installed)
    VALUES('CDRECORD','localhost',10104,'Media Creation Server (part of dcm4chee)',1);
