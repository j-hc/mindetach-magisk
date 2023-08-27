DELETE FROM auto_update
WHERE
	pk IN (PKGNAME);

DROP TRIGGER IF EXISTS j_hc_auto_update_blockupdate_AI;

CREATE TRIGGER j_hc_auto_update_blockupdate_AI AFTER INSERT ON auto_update BEGIN
DELETE FROM auto_update
WHERE
	pk IN (PKGNAME);
END;

DROP TRIGGER IF EXISTS j_hc_auto_update_blockupdate_BI;

CREATE TRIGGER j_hc_auto_update_blockupdate_BI BEFORE INSERT ON auto_update BEGIN
SELECT
	RAISE (
		ROLLBACK,
		'mindetach: auto_update.auto_update insert'
	)
WHERE
	NEW.pk IN (PKGNAME);
END;