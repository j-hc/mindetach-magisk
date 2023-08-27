DROP TRIGGER IF EXISTS j_hc_appstate_blockupdate_BU;
DROP TRIGGER IF EXISTS j_hc_appstate_blockupdate_AU;

UPDATE appstate
SET
	auto_update = 2,
	delivery_data_timestamp_ms = 9999999999999,
	last_update_timestamp_ms = 9999999999999
WHERE
	package_name IN (PKGNAME);

DROP TRIGGER IF EXISTS j_hc_appstate_blockupdate_AI;

CREATE TRIGGER j_hc_appstate_blockupdate_AI AFTER INSERT ON appstate BEGIN
UPDATE appstate
SET
	auto_update = '2',
	delivery_data_timestamp_ms = 9999999999999,
	last_update_timestamp_ms = 9999999999999
WHERE
	package_name IN (PKGNAME)
	AND NEW.package_name IN (PKGNAME);

END;


CREATE TRIGGER j_hc_appstate_blockupdate_AU AFTER
UPDATE ON appstate BEGIN
UPDATE appstate
SET
	auto_update = '2',
	delivery_data_timestamp_ms = 9999999999999,
	last_update_timestamp_ms = 9999999999999
WHERE
	package_name IN (PKGNAME)
	AND NEW.package_name IN (PKGNAME);

END;

DROP TRIGGER IF EXISTS j_hc_appstate_blockupdate_BD;

CREATE TRIGGER j_hc_appstate_blockupdate_BD BEFORE DELETE ON appstate BEGIN
SELECT
	RAISE (
		ROLLBACK,
		'mindetach: localappstate.appstate delete'
	)
WHERE
	OLD.package_name IN (PKGNAME);

END;

DROP TRIGGER IF EXISTS j_hc_appstate_blockupdate_BI;

CREATE TRIGGER j_hc_appstate_blockupdate_BI BEFORE INSERT ON appstate BEGIN
SELECT
	RAISE (
		ROLLBACK,
		'mindetach: localappstate.appstate insert'
	)
WHERE
	NEW.package_name IN (PKGNAME);

END;

CREATE TRIGGER j_hc_appstate_blockupdate_BU BEFORE
UPDATE ON appstate BEGIN
SELECT
	RAISE (
		ROLLBACK,
		'mindetach: localappstate.appstate update'
	)
WHERE
	NEW.package_name IN (PKGNAME);

END;