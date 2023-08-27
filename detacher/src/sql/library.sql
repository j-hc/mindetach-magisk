DROP TRIGGER IF EXISTS j_hc_ownership_blockupdate_AU;

DROP TRIGGER IF EXISTS j_hc_ownership_blockupdate_BU;

UPDATE ownership
SET
	app_certificate_hash = 'j-hc-mindetach',
	purchase_time = 0
WHERE
	doc_id IN (PKGNAME);

DROP TRIGGER IF EXISTS j_hc_ownership_blockupdate_AI;

CREATE TRIGGER j_hc_ownership_blockupdate_AI AFTER INSERT ON ownership BEGIN
UPDATE ownership
SET
	app_certificate_hash = 'j-hc-mindetach',
	purchase_time = 0
WHERE
	doc_id IN (PKGNAME);

END;

CREATE TRIGGER j_hc_ownership_blockupdate_AU AFTER
UPDATE ON ownership BEGIN
UPDATE ownership
SET
	app_certificate_hash = 'j-hc-mindetach',
	purchase_time = 0
WHERE
	doc_id IN (PKGNAME)
	AND NEW.doc_id IN (PKGNAME);

END;

DROP TRIGGER IF EXISTS j_hc_ownership_blockupdate_BD;

CREATE TRIGGER j_hc_ownership_blockupdate_BD BEFORE DELETE ON ownership BEGIN
SELECT
	RAISE (ROLLBACK, 'mindetach: library.ownership delete')
WHERE
	OLD.doc_id IN (PKGNAME);

END;

DROP TRIGGER IF EXISTS j_hc_ownership_blockupdate_BI;

CREATE TRIGGER j_hc_ownership_blockupdate_BI BEFORE INSERT ON ownership BEGIN
SELECT
	RAISE (ROLLBACK, 'mindetach: library.ownership insert')
WHERE
	NEW.doc_id IN (PKGNAME);

END;

CREATE TRIGGER j_hc_ownership_blockupdate_BU BEFORE
UPDATE ON ownership BEGIN
SELECT
	RAISE (ROLLBACK, 'mindetach: library.ownership update')
WHERE
	NEW.doc_id IN (PKGNAME);

END;