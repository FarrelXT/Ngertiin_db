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
    tgl_lahir_guru_siswa DATE DEFAULT NULL,
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

CREATE TEMPORARY TABLE active_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT active_user_fk FOREIGN KEY (user_id) REFERENCES user(id_user)
) ENGINE=MEMORY;

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
  `jenis_report` enum('Akun','Post') ,
  `status_report` enum('Belum diproses','Sedang diproses','Selesai diproses') ,
  `report_tag` enum('spam','ucapan kebencian','pelecehan dan perundungan','aktivitas yang berbahaya','konten dewasa (konsensual)','eksploitasi dan pelecehan seksual (keselamatan anak)','eksploitasi dan pelecehan seksual (dewasa)','plagiarisme','lainnya')
  `isi_report` text,
  `isi_repost` text,
  `isi_jawab` text,
  `isi_komen` text,
  `jenis_vote` enum ('upvote','downvote')
);

ALTER TABLE `riwayat`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user);

ALTER TABLE `save`     
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user),
    ADD FOREIGN KEY (id_post) REFERENCES Post(id_post);

ALTER TABLE `info`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user),
    ADD CONSTRAINT chk_jenis_user CHECK (u.jenis_user);

ALTER TABLE `post`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user),
    ADD FOREIGN KEY (id_feedback) REFERENCES feedback(id_feedback);
ALTER TABLE `feedback`
    ADD FOREIGN KEY (id_user) REFERENCES User(id_user),
    ADD FOREIGN KEY (id_post) REFERENCES Post(id_post);

CREATE INDEX idx_riwayat_user_date ON riwayat(id_user, date);

DELIMITER // -- Trigger update riwayat poin
CREATE TRIGGER sebelum_update_riwayat_poin BEFORE UPDATE ON riwayat
FOR EACH ROW
BEGIN
    SET NEW.point = OLD.point + NEW.point;
END//
DELIMITER ;


DELIMITER // -- Trigger untuk menambahkan poin saat feedback
CREATE TRIGGER  point_feedback
AFTER INSERT ON feedback
FOR EACH ROW
BEGIN
    DECLARE add_point INT DEFAULT 0;
    DECLARE point_exist INT;
    
    IF NEW.isi_komen IS NOT NULL THEN SET add_point = add_point + 2; END IF;
    IF NEW.isi_jawab IS NOT NULL THEN SET add_point = add_point + 7; END IF;
    IF NEW.jenis_vote IS NOT NULL THEN SET add_point = points_to_add + 1; END IF;
    IF NEW.isi_report IS NOT NULL THEN SET add_point = add_point + 2; END IF;
    IF NEW.isi_repost IS NOT NULL THEN SET add_point = add_point + 5; END IF;

    IF add_point > 0 THEN 
        INSERT INTO riwayat (id_user, add_point, date)
        VALUES (NEW.id_user, add_point, CURDATE) 
END//
DELIMITER ;


DELIMITER // -- Fungsi cek user adalah admin
CREATE FUNCTION chck_user_admin(user_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE jns_user VARCHAR(20);
    DECLARE can_access BOOLEAN DEFAULT FALSE;
    
    SELECT jenis_user INTO jns_user 
    FROM user 
    WHERE id_user = user_id;
    
    IF jns_user = 'admin' THEN
        SET can_access = TRUE;
    ELSE
        SET can_access = FALSE;
    END IF;
    
    RETURN can_access;
END//
DELIMITER ;