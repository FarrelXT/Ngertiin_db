CREATE TABLE Admin (
    Id_admin INT AUTO_INCREMENT UNIQUE NOT NULL,
    Username VARCHAR(50) PRIMARY KEY NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Foto_Profil VARCHAR(255)
);

CREATE TABLE Guru (
    Id_guru INT AUTO_INCREMENT UNIQUE NOT NULL,
    Username VARCHAR(50) PRIMARY KEY NOT NULL, 
    Email VARCHAR(50) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Nama_Lengkap VARCHAR(100) NOT NULL,
    Nama_Sekolah VARCHAR(100) NOT NULL,
    Tanggal_Lahir DATE NOT NULL,
    Telpon VARCHAR(20) NOT NULL,
    Domisili VARCHAR(100) NOT NULL,
    Foto_Profil VARCHAR(255) NOT NULL,
    NIP VARCHAR(20) NOT NULL,
    -- Mapel_diajarkan VARCHAR(255)/Enum ? NOT NULL, 
    -- Tingkat_diajarkan VARCHAR(50)/Enum ? NOT NULL,
    Point INT DEFAULT 0,
    Status ENUM('terverifikasi', 'belum terverifikasi') DEFAULT 'belum terverifikasi'
);

CREATE TABLE Siswa (
    Id_siswa INT AUTO_INCREMENT UNIQUE NOT NULL,
    Username VARCHAR(50) PRIMARY KEY NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Foto_profil VARCHAR(255),
    Nama_lengkap VARCHAR(100),
    NISN VARCHAR(20),
    Nomor_telephone VARCHAR(20),
    Tingkat_diajarkan Enum('SD', 'SMP', 'SMA') NOT NULL,
    -- Tingkat_sekolah VARCHAR(10)/Enum ? NOT NULL,
    Tanggal_Lahir DATE NOT NULL,
    Point INT DEFAULT 0
);

CREATE TABLE Info (
    Id_info INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_admin VARCHAR(50) NOT NULL,
    Nama_info VARCHAR(100) NOT NULL,
    Isi_info TEXT NOT NULL,
    Tanggal_info DATETIME NOT NULL,
    Gambar_info VARCHAR(255) NOT NULL,
    FOREIGN KEY (Id_admin) REFERENCES Admin(Username)
);

-- CREATE TABLE Repost (
--     Id_repost INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
--     Id_post INT NOT NULL,
--     Username_repost VARCHAR(50) NOT NULL,
--     Waktu_repost DATETIME DEFAULT CURRENT_TIMESTAMP,
--     FOREIGN KEY (Id_post) REFERENCES Post(Id_post)
-- );

CREATE TABLE Leaderboard (
    Id_leaderboard INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_siswa INT NOT NULL,
    Nama_leaderboard VARCHAR(50) NOT NULL,
    Rank_position INT NOT NULL,
    -- rank posisi butuh kalkulasi point. buat tabel perhitungan point untuk siswa ?
    FOREIGN KEY (Id_siswa) REFERENCES Siswa(Id_siswa)
);

CREATE TABLE Report (
    Id_report INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username VARCHAR(50) NOT NULL,
    -- Jenis_report VARCHAR(50) NOT NULL, jenis pelanggaran ? Enum ?
    Isi_report TEXT NOT NULL,
    Status_report ENUM('sedang ditangani', 'sedang diproses', 'tertangani') DEFAULT 'sedang diproses',
    Waktu_report DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Post_Repost (
    Id_post INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_pembuat VARCHAR(50) NOT NULL,
    Foto_file VARCHAR(255),
    Isi_post TEXT NOT NULL,
    Jumlah_upvote INT DEFAULT 0,
    Jumlah_downvote INT DEFAULT 0,
    Waktu_post DATETIME DEFAULT CURRENT_TIMESTAMP
);