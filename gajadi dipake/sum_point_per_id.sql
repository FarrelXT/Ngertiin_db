SELECT id_user, SUM(point) AS total_point
FROM riwayat
GROUP BY id_user;