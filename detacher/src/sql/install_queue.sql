DELETE FROM install_requests
WHERE
	pk IN (PKGNAME);

DROP TRIGGER IF EXISTS j_hc_install_requests_blockupdate_AI;

CREATE TRIGGER j_hc_install_requests_blockupdate_AI AFTER INSERT ON install_requests BEGIN
DELETE FROM install_requests
WHERE
	NEW.pk IN (PKGNAME);

END;

DROP TRIGGER IF EXISTS j_hc_install_requests_blockupdate_BI;

CREATE TRIGGER j_hc_install_requests_blockupdate_BI BEFORE INSERT ON install_requests BEGIN
SELECT
	RAISE (
		ROLLBACK,
		'mindetach: install_requests.install_requests insert'
	)
WHERE
	NEW.pk IN (PKGNAME);

END;