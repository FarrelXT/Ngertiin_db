-- Admin Table
CREATE TABLE Admin (
    Id_admin INT AUTO_INCREMENT UNIQUE NOT NULL PRIMARY KEY
);

-- Guru Table
CREATE TABLE Guru (
    Id_guru INT AUTO_INCREMENT UNIQUE NOT NULL PRIMARY KEY,
    Nama_Lengkap VARCHAR(100) NOT NULL,
    Nama_Sekolah VARCHAR(100) NOT NULL,
    Tanggal_Lahir DATE NOT NULL,
    Nomer_Telepon VARCHAR(20) NOT NULL,
    Domisili VARCHAR(100) NOT NULL,
    NIP VARCHAR(20) NOT NULL,
    Mapel_diajarkan VARCHAR(100) NOT NULL, 
    Tingkat_diajarkan ENUM('SD', 'SMP', 'SMA') NOT NULL,
    Status ENUM('terverifikasi', 'belum terverifikasi') DEFAULT 'belum terverifikasi'
);

-- Siswa Table
CREATE TABLE Siswa (
    Id_siswa INT AUTO_INCREMENT UNIQUE NOT NULL,
    Nama_lengkap VARCHAR(100) NOT NULL,
    NISN VARCHAR(20),
    Nomor_telephone VARCHAR(20),
    Tingkat_sekolah ENUM('SD', 'SMP', 'SMA') NOT NULL,
    kelas_sekolah ENUM('1','2','3','4','5','6','7', '8', '9', '10', '11', '12') NOT NULL,
    Tanggal_Lahir DATE NOT NULL,
);

-- table generalisir user (union : admin, guru, siswa)
CREATE TABLE User (
    Id_user INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Foto_profil VARCHAR(255),
    Jenis_user ENUM('admin', 'guru', 'siswa') NOT NULL,
    foreign key (Id_user) refferences Admin(Id_admin),
    foreign key (Id_user) refferences Guru(Id_guru),
    foreign key (Id_user) refferences Siswa(Id_siswa)
);

-- riwayat poin user table
CREATE TABLE riwayat_poin (
    id_riwayat INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_user INT NOT NULL,
    poin INT NOT NULL DEF1AULT 0,
    tanggal_masuk DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_user) REFERENCES User(Id_user)
);

-- Info Table
CREATE TABLE Info (
    Id_info INT AUTO_INCREMENT PRIMARY kEY NOT NULL,
    Id_admin VARCHAR(50) NOT NULL,
    Nama_info VARCHAR(100) NOT NULL,
    Isi_info TEXT NOT NULL,
    Tanggal_info DATETIME NOT NULL,
    Gambar_info VARCHAR(255) NOT NULL,
);


-- Post Table 
CREATE TABLE Post (
    Id_post INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_pembuat VARCHAR(50) NOT NULL,
    Foto_file VARCHAR(255),
    Isi_post TEXT NOT NULL,
    Jumlah_upvote INT DEFAULT 0,
    Jumlah_downvote INT DEFAULT 0,
    Waktu_post DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Repost Table
CREATE TABLE Repost (
    Id_repost INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_post INT NOT NULL,
    Username_repost VARCHAR(50) NOT NULL,
    Waktu_repost DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post)
);

-- Komentar Table
CREATE TABLE Komentar (
    Id_komentar INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_post INT NOT NULL,
    Username_komentator VARCHAR(50) NOT NULL,
    Jenis_komentator ENUM('guru', 'siswa') NOT NULL,
    Isi_komentar TEXT NOT NULL,
    Waktu_komentar DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post)
);

-- Vote Table
CREATE TABLE Vote (
    Id_vote INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_post INT NOT NULL,
    Username_voter VARCHAR(50) NOT NULL,
    Jenis_voter ENUM('guru', 'siswa') NOT NULL,
    Jenis_vote ENUM('upvote', 'downvote') NOT NULL,
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post),
    UNIQUE KEY unique_vote (Id_post, Username_voter, Jenis_voter)
);

-- Leaderboard Table
CREATE TABLE Leaderboard (
    Id_leaderboard INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    USERNAME VARCHAR(50) NOT NULL,
    Nama_leaderboard VARCHAR(50) NOT NULL,
    Rank_position INT NOT NULL
);

-- Notifikasi Table
CREATE TABLE Notifikasi (
    Id_notif INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_penerima VARCHAR(50) NOT NULL,
    Jenis_penerima ENUM('admin', 'guru', 'siswa') NOT NULL,
    Isi_notif TEXT NOT NULL,
    Dibaca BOOLEAN DEFAULT FALSE,
    Waktu_notif DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- -- Pesan Table (BUKAN PRIORITAS)
-- CREATE TABLE Pesan (
--     Id_pesan INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
--     Username_pengirim VARCHAR(50) NOT NULL,
--     Username_penerima VARCHAR(50) NOT NULL,
--     Isi_pesan TEXT NOT NULL,
--     Dibaca BOOLEAN DEFAULT FALSE,
--     Waktu_kirim DATETIME DEFAULT CURRENT_TIMESTAMP
-- );

-- -- Pertemanan Table (BUKAN PRIORITAS)
-- CREATE TABLE Pertemanan (
--     Id_pertemanan INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
--     Username1 VARCHAR(50) NOT NULL,
--     Username2 VARCHAR(50) NOT NULL,
--     Status ENUM('pending', 'sukses', 'ditolak') NOT NULL,
--     Tanggal_request DATETIME DEFAULT CURRENT_TIMESTAMP,
--     Tanggal_konfirmasi DATETIME
-- );

-- Grup Table
CREATE TABLE Grup (
    Id_grup INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Nama_grup VARCHAR(100) NOT NULL,
    Deskripsi TEXT,
    Tanggal_dibuat DATETIME DEFAULT CURRENT_TIMESTAMP,
    Username_creator VARCHAR(50) NOT NULL,
    Foto_grup VARCHAR(255)
);

-- AnggotaGrup Table
CREATE TABLE AnggotaGrup (
    Id_anggota INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_grup INT NOT NULL,
    Username_anggota VARCHAR(50) NOT NULL,
    Role ENUM('moderator','owner', 'member') DEFAULT 'member',
    Tanggal_bergabung DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_grup) REFERENCES Grup(Id_grup)
);

-- anggota report
CREATE TABLE Report (
    Id_report INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_pelapor VARCHAR(50) NOT NULL, 
    Jenis_report ENUM('spam', 'bullying', 'konten tidak pantas', 'lainnya') NOT NULL,
    Isi_report TEXT NOT NULL,
    Status_report ENUM('sedang ditangani', 'sedang diproses', 'tertangani') DEFAULT 'sedang diproses',
    Waktu_report_masuk DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- anggota report akun
CREATE TABLE report_akun (
    id_report_akun INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    id_user INT NOT NULL,
    Jenis_report_akun ENUM('spam',
                            'akun palsu',
                            'konten berbahaya mengandung SARA dan diluar konteks akademik',
                            'penipuan, HOAX, fraud',
                            'pelanggaran privasi',
                            'pelanggaran hak cipta',
                            'lainnya') NOT NULL
    report_akun_deskripsi TEXT NOT NULL,
    Status_report_akun ENUM('sedang ditangani', 'sedang diproses', 'tertangani') DEFAULT 'sedang diproses',
    waktu_report_akun_masuk DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES User(Id_user)
);

-- -- index + trigger exists insert cek report table
-- CREATE INDEX idx_report_konten ON Report(Konten_type, Id_konten);
-- DELIMITER //
-- CREATE TRIGGER sebelum_insert_report BEFORE INSERT ON Report
-- FOR EACH ROW
-- BEGIN
--     DECLARE valdi BOOLEAN DEFAULT FALSE;

--     IF NEW.konten_type = 'post' THEN
--         SET valdi = EXISTS(SELECT 1 FROM Post WHERE Id_post = NEW.id_konten);
--     ELSEIF NEW.konten_type = 'komentar' THEN
--         SET valdi = EXISTS(SELECT 1 FROM Komentar WHERE Id_komentar = NEW.id_konten);
--     ELSEIF NEW.konten_type = 'akun' THEN
--         IF NEW.jenis_konten_akun = 'siswa' THEN
--             SET valdi = EXISTS(SELECT 1 FROM Siswa WHERE Id_siswa = NEW.id_konten);
--         ELSEIF NEW.jenis_konten_akun = 'guru' THEN
--             SET valdi = EXISTS(SELECT 1 FROM Guru WHERE Id_guru = NEW.id_konten);
--         END IF;
--     END IF;
    
--     IF NOT valdi THEN
--         SIGNAL SQLSTATE '45000' 
--         SET MESSAGE_TEXT = 'konten tidak tersedia atau telah dihapus';
--     END IF;
-- END//
-- DELIMITER ;
-- -- end index + trigger exists insert cek report table
-- -- Akhiran Bagian Report

DELIMITER//
CREATE TRIGGER sebelum_update_riwayat_poin BEFORE UPDATE ON riwayat_poin
FOR EACH ROW
BEGIN
    UPDATE riwayat_poin SET poin = poin + NEW.poin 
    WHERE Id_user = NEW.Id_user;
END//
