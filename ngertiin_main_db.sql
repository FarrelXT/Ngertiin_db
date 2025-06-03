CREATE TABLE user (
    id_user INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    foto_profil VARCHAR(255) DEFAULT NULL,
    jenis_user ENUM('siswa', 
                    'guru', 
                    'admin') NOT NULL,
    nama_lengkap_guru_siswa VARCHAR(100) NOT NULL,
    tanggal_lahir_guru_siswa DATE DEFAULT NULL,
    telpon_guru VARCHAR(20) DEFAULT NULL,
    domisili_guru TEXT DEFAULT NULL,
    nip_guru VARCHAR(18) DEFAULT NULL,
    status_guru ENUM('terdaftar' ,'belum terdaftar', 'tidak terdaftar') DEFAULT NULL,
    tingkat_siswa ENUM('SD',
                        'SMP',
                        'SMA') DEFAULT NULL,
    kelas_siswa ENUM('1',
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
                    '12') DEFAULT NULL,
    nisn_siswa VARCHAR(20) DEFAULT NULL,
    status_akun ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif'
);

CREATE TABLE info (
    id_info INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    nama_info VARCHAR(100) NOT NULL,
    file_foto_info VARCHAR(255) NOT NULL,
    isi_info TEXT NOT NULL,
    tanggal_info DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post (
    id_post int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user int NOT NULL,
    id_feedback int NOT NULL,
    file_foto varchar(255) NOT NULL,
    isi_post text NOT NULL,
    status_post enum('Publik','Privat','Hapus') NOT NULL,
    tanggal_post date NOT NULL
);

CREATE TABLE riwayat (
    id_riwayat INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    point INT NOT NULL DEFAULT 0,
    date DATE NOT NULL
);

CREATE TABLE save (
    id_save INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_post INT NOT NULL
);

CREATE TABLE feedback (
  `id_feedback` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_user` int NOT NULL,
  `id_post` int NOT NULL,
  `jenis_report` enum('Akun','Post') DEFAULT NULL,
  `status_report` enum('Belum diproses','Sedang diproses','Selesai diproses') DEFAULT NULL,
  `isi_report` text,
  `isi_repost` text,
  `isi_komen` text,
  `downvote` int DEFAULT '0',
  `upvote` int DEFAULT '0',
  `isi_jawab` text
);

ALTER TABLE `riwayat`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user);

ALTER TABLE `save`     
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user),
    ADD FOREIGN KEY (id_post) REFERENCES Post(id_post);

ALTER TABLE `info`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user);

ALTER TABLE `post`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user);
ALTER TABLE `feedback`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user),
    ADD FOREIGN KEY (id_post) REFERENCES Post(id_post);

DELIMITER //
CREATE TRIGGER sebelum_update_riwayat_poin BEFORE UPDATE ON riwayat
FOR EACH ROW
BEGIN
    SET NEW.point = OLD.point + NEW.point;
END//
DELIMITER ;