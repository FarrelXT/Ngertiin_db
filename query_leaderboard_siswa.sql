SELECT u.Username, r.poin FROM User u JOIN riwayat r ON u.Id_user = r.Id_user
WHERE u.jenis_user = 'siswa'
ORDER BY r.poin DESC;