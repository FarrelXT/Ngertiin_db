-- generalisir tabel user (union : admin, guru, siswa)
CREATE TABLE User (
    Id_user INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    jenis_user ENUM('admin', 'guru', 'siswa') NOT NULL,
    Foto_profil VARCHAR(255),
    Nama_Lengkap VARCHAR(100) NOT NULL,
    Nama_Sekolah VARCHAR(100),
    Tanggal_Lahir DATE NOT NULL,
    Nomer_Telepon VARCHAR(20) NOT NULL,
    Domisili VARCHAR(100),
    NIP VARCHAR(20),
    Mapel_diajarkan VARCHAR(100), 
    Tingkat_diajarkan ENUM('SD', 'SMP', 'SMA'),
    Status_guru ENUM('terverifikasi', 'belum terverifikasi') 
                    DEFAULT 'belum terverifikasi',
    NISN VARCHAR(20),
    Tingkat_sekolah ENUM('SD', 'SMP', 'SMA'),
    kelas_sekolah ENUM('1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '6',
                        '7',
                        '8',
                        '9',
                        '10',
                        '11',
                        '12')
);

-- riwayat poin user table
CREATE TABLE riwayat_poin (
    Id_riwayat INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_user INT NOT NULL,
    poin INT NOT NULL DEFAULT 0,
    tanggal_masuk DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_user) REFERENCES User(Id_user)
);

-- Info Table
CREATE TABLE Info (
    Id_info INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_user INT NOT NULL,
    Nama_info VARCHAR(100) NOT NULL,
    Isi_info TEXT NOT NULL,
    Tanggal_info DATETIME NOT NULL,
    Gambar_info VARCHAR(255) NOT NULL,
    FOREIGN KEY (Id_user) REFERENCES User(Id_user)
);

-- Post Table 
CREATE TABLE Post (
    Id_user INT NOT NULL,
    Id_feedback INT NOT NULL,
    Id_post INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_pembuat VARCHAR(50) NOT NULL,
    foto_file VARCHAR(255),
    Isi_post TEXT NOT NULL,
    Waktu_post DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_post ENUM('aktif', 'nonaktif', 'Hapus') DEFAULT 'aktif',
    FOREIGN KEY (Id_user) REFERENCES User(Id_user)
);

-- generalisir tabel feedback (union : repost, komentar, report, vote)
CREATE TABLE feedback (
    Id_user INT NOT NULL,
    Id_feedback INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Id_post INT NOT NULL,
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post)
);

--      GENERALISIR FEEDBACK
-- Repost Table
CREATE TABLE Repost (
    Id_repost INT PRIMARY KEY NOT NULL,
    Username_repost VARCHAR(50) NOT NULL,
    Waktu_repost DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_repost) REFERENCES feedback(Id_feedback)
);

-- Komentar Table
CREATE TABLE Komentar (
    Id_komentar INT PRIMARY KEY NOT NULL,
    Isi_komentar TEXT NOT NULL,
    FOREIGN KEY (Id_komentar) REFERENCES feedback(Id_feedback)
);

-- Vote Table
CREATE TABLE Vote (
    Id_vote INT PRIMARY KEY NOT NULL,
    downvote INT DEFAULT 0,
    upvote INT DEFAULT 0,
    FOREIGN KEY (Id_vote) REFERENCES feedback(Id_feedback)
);

-- anggota report
CREATE TABLE Report (
    Id_report INT PRIMARY KEY NOT NULL,
    Jenis_report ENUM('spam',
                        'bullying',
                        'konten tidak pantas',
                        'Pelanggaran Hak Cipta',
                        'lainnya') NOT NULL,
    Isi_report TEXT NOT NULL,
    Status_report ENUM('sedang ditangani', 'sedang diproses', 'tertangani') DEFAULT 'sedang diproses',
    Waktu_report_masuk DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_report) REFERENCES feedback(Id_feedback)
);
--      GENERALISIR FEEDBACK

-- simpan/archive post user
CREATE TABLE save_post (
    Id_user INT NOT NULL,
    Id_post INT NOT NULL,
    Waktu_save DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_user) REFERENCES User(Id_user),
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post)
);

-- anggota report akun
CREATE TABLE report_akun (
    Id_report_akun INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_user INT NOT NULL,
    Jenis_report_akun ENUM('spam',
                            'akun palsu',
                            'konten berbahaya mengandung SARA dan diluar konteks akademik',
                            'penipuan, HOAX, fraud',
                            'pelanggaran privasi',
                            'pelanggaran hak cipta',
                            'lainnya') NOT NULL,
    report_akun_deskripsi TEXT NOT NULL,
    Status_report_akun ENUM('sedang ditangani',
                            'sedang diproses',
                            'tertangani') DEFAULT 'sedang diproses',
    waktu_report_akun_masuk DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_user) REFERENCES User(Id_user)
);

-- ALTER TABLE `post` ADD FOREIGN KEY (Id_feedback) REFERENCES feedback(Id_feedback);

DELIMITER //
CREATE TRIGGER sebelum_update_riwayat_poin BEFORE UPDATE ON riwayat_poin
FOR EACH ROW
BEGIN
    SET NEW.poin = OLD.poin + NEW.poin;
END//
DELIMITER ;