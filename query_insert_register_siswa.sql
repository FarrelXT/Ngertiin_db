INSERT INTO User (
    Username,
    Email,
    Password,
    jenis_user,
    Foto_profil,
    Nama_Lengkap,
    Nama_Sekolah,
    Tanggal_Lahir,
    Nomer_Telepon, 
    Domisili, 
    NISN, 
    Tingkat_sekolah, 
    kelas_sekolah
) VALUES ( -- input data siswa baru
    'username_baru', -- username
    'userbaru@mail.com', -- email
    'password123', -- password
    'siswa', -- jenis_user (wajib otomatis enum siswa)
    'path_foto_profil.jpg', -- Foto_profil(opsional)
    'User Baru', -- Nama_Lengkap
    'SMA 1', -- Nama_Sekolah
    '2005-01-01', -- Tanggal_Lahir
    '08123456789', -- Nomer_Telepon
    'Bandung', -- Domisili
    '99887788', -- NISN(opsional)
    'SMA', -- Tingkat_sekolah
    '12' -- kelas_sekolah
);