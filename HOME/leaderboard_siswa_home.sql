SELECT u.foto_profil, u.Username, r.point FROM User u JOIN riwayat r ON u.Id_user = r.Id_user
WHERE u.jenis_user = 'siswa'
ORDER BY r.point DESC;