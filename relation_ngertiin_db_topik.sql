-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 05, 2025 at 02:27 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `relation_ngertiin_db`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_login_user` (`auth_username` VARCHAR(100), `auth_password` VARCHAR(100)) RETURNS TINYINT(1) DETERMINISTIC BEGIN
  DECLARE is_valid BOOLEAN DEFAULT 0;
  IF (
    SELECT COUNT(*)
    FROM users
    WHERE username = auth_username
      AND password = AES_ENCRYPT(auth_password, 'NGERTIIN')
  ) > 0 THEN
    UPDATE active_user
    SET id_user = (SELECT id_user FROM user
                   WHERE username = auth_username
                     AND password = AES_ENCRYPT(auth_password, 'NGERTIIN'))
    WHERE id_user = 1;
    SET is_valid = 1;
  END IF;
  RETURN is_valid;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `active_user`
--

CREATE TABLE `active_user` (
  `id` tinyint UNSIGNED NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_user` int NOT NULL,
  `id_admin` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id_feedback` int NOT NULL,
  `id_user` int NOT NULL,
  `id_post` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guru`
--

CREATE TABLE `guru` (
  `id_user` int NOT NULL,
  `nama_lengkap` varchar(200) NOT NULL,
  `nip` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `domisili` varchar(100) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `status_guru` enum('Terverifikasi','Belum Terverifikasi','Ditolak','') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Belum Terverifikasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jawab`
--

CREATE TABLE `jawab` (
  `id_feedback` int NOT NULL,
  `id_jawab` int NOT NULL,
  `isi_jawab` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `komen`
--

CREATE TABLE `komen` (
  `id_feedback` int NOT NULL,
  `id_komen` int NOT NULL,
  `isi_komen` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `id_post` int NOT NULL,
  `id_user` int NOT NULL,
  `file_foto` varchar(255) DEFAULT NULL,
  `isi_post` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` enum('Publik','Privat','Hapus') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Publik',
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `id_feedback` int NOT NULL,
  `id_report` int NOT NULL,
  `jenis_report` enum('Akun','Post') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status_report` enum('Belum Diproses','Sedang Diproses','Selesai Diproses','') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Belum Diproses',
  `isi_report` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `report_kategori` enum('spam','ucapan kebencian','pelecehan dan perundungan','aktivitas yang berbahaya','konten dewasa (konsensual)','eksploitasi dan pelecehan seksual (keselamatan anak)','eksploitasi dan pelecehan seksual (dewasa)','plagiarisme','lainnya') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `repost`
--

CREATE TABLE `repost` (
  `id_feedback` int NOT NULL,
  `id_repost` int NOT NULL,
  `isi_repost` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `riwayat`
--

CREATE TABLE `riwayat` (
  `id_riwayat` int NOT NULL,
  `id_user` int NOT NULL,
  `point` int DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `save`
--

CREATE TABLE `save` (
  `id_save` int NOT NULL,
  `id_user` int NOT NULL,
  `id_post` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `id_user` int NOT NULL,
  `nama_lengkap` varchar(200) NOT NULL,
  `nisn` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `kelas` enum('1','2','3','4','5','6','7','8','9','10','11','12') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tingkat` enum('SD','SMP','SMA') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varbinary(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `foto_profil` text,
  `status_akun` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Aktif',
  `jenis_user` enum('Admin','Guru','Siswa') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `username`, `password`, `email`, `foto_profil`, `status_akun`, `jenis_user`, `created_at`, `updated_at`) VALUES
(1, 'taufik', 0x338750e2481c9e08fa613b72f38436aa, 'taufiknur15@gmail.com', NULL, 'Aktif', NULL, '2025-06-04 19:24:24', '2025-06-04 19:24:24');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `insert_pass_user` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
  SET NEW.password = AES_ENCRYPT(NEW.password, 'NGERTIIN');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_user_password` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
  SET NEW.password = AES_ENCRYPT(NEW.password, 'NGERTIIN');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_guru_account`
-- (See below for the actual view)
--
CREATE TABLE `view_guru_account` (
`email` varchar(100)
,`foto_profil` text
,`jenis_user` enum('Admin','Guru','Siswa')
,`nama_lengkap` varchar(200)
,`nip` varchar(18)
,`status_guru` enum('Terverifikasi','Belum Terverifikasi','Ditolak','')
,`telepon` varchar(20)
,`tgl_lahir` date
,`username` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_post_detail`
-- (See below for the actual view)
--
CREATE TABLE `view_post_detail` (
`file_foto` varchar(255)
,`foto_profil` text
,`id_post` int
,`isi_post` text
,`jenis_user` enum('Admin','Guru','Siswa')
,`jumlah_feedback` bigint
,`jumlah_jawab` bigint
,`jumlah_komen` bigint
,`jumlah_report` bigint
,`jumlah_repost` bigint
,`jumlah_save` bigint
,`status_post` enum('Publik','Privat','Hapus')
,`tanggal_post` date
,`total_downvote` decimal(32,0)
,`total_upvote` decimal(32,0)
,`username` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_siswa_account`
-- (See below for the actual view)
--
CREATE TABLE `view_siswa_account` (
`email` varchar(100)
,`foto_profil` text
,`jenis_user` enum('Admin','Guru','Siswa')
,`nama_lengkap` varchar(200)
,`nisn` varchar(10)
,`tanggal_lahir` date
,`tingkat` enum('SD','SMP','SMA')
,`username` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `vote`
--

CREATE TABLE `vote` (
  `id_feedback` int NOT NULL,
  `id_vote` int NOT NULL,
  `upvote` int DEFAULT '0',
  `downvote` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure for view `view_guru_account`
--
DROP TABLE IF EXISTS `view_guru_account`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_guru_account`  AS SELECT `user`.`username` AS `username`, `user`.`email` AS `email`, `user`.`jenis_user` AS `jenis_user`, `user`.`foto_profil` AS `foto_profil`, `guru`.`nama_lengkap` AS `nama_lengkap`, `guru`.`nip` AS `nip`, `guru`.`tgl_lahir` AS `tgl_lahir`, `guru`.`telepon` AS `telepon`, `guru`.`status_guru` AS `status_guru` FROM (`guru` join `user` on((`guru`.`id_user` = `user`.`id_user`))) WHERE (`user`.`jenis_user` = 'Guru') GROUP BY `user`.`username`, `user`.`email`, `user`.`jenis_user`, `user`.`foto_profil`, `guru`.`nama_lengkap`, `guru`.`nip`, `guru`.`tgl_lahir`, `guru`.`telepon`, `guru`.`status_guru``status_guru`  ;

-- --------------------------------------------------------

--
-- Structure for view `view_post_detail`
--
DROP TABLE IF EXISTS `view_post_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_post_detail`  AS SELECT `p`.`id_post` AS `id_post`, `u`.`username` AS `username`, `u`.`jenis_user` AS `jenis_user`, `p`.`isi_post` AS `isi_post`, `p`.`file_foto` AS `file_foto`, `p`.`date` AS `tanggal_post`, `p`.`status` AS `status_post`, `u`.`foto_profil` AS `foto_profil`, count(distinct `f`.`id_feedback`) AS `jumlah_feedback`, count(distinct `s`.`id_save`) AS `jumlah_save`, count(distinct `j`.`id_jawab`) AS `jumlah_jawab`, count(distinct `k`.`id_komen`) AS `jumlah_komen`, count(distinct `r`.`id_repost`) AS `jumlah_repost`, count(distinct `rp`.`id_report`) AS `jumlah_report`, coalesce(sum(`vt`.`upvote`),0) AS `total_upvote`, coalesce(sum(`vt`.`downvote`),0) AS `total_downvote` FROM ((((((((`post` `p` join `user` `u` on((`p`.`id_user` = `u`.`id_user`))) left join `feedback` `f` on((`p`.`id_post` = `f`.`id_post`))) left join `save` `s` on((`p`.`id_post` = `s`.`id_post`))) left join `jawab` `j` on((`f`.`id_feedback` = `j`.`id_feedback`))) left join `komen` `k` on((`f`.`id_feedback` = `k`.`id_feedback`))) left join `repost` `r` on((`f`.`id_feedback` = `r`.`id_feedback`))) left join `report` `rp` on((`f`.`id_feedback` = `rp`.`id_feedback`))) left join `vote` `vt` on((`f`.`id_feedback` = `vt`.`id_feedback`))) WHERE (`p`.`status` <> 'Hapus') GROUP BY `p`.`id_post`, `u`.`username`, `u`.`jenis_user`, `p`.`isi_post`, `p`.`file_foto`, `p`.`date`, `p`.`status`, `u`.`foto_profil``foto_profil`  ;

-- --------------------------------------------------------

--
-- Structure for view `view_siswa_account`
--
DROP TABLE IF EXISTS `view_siswa_account`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_siswa_account`  AS SELECT `user`.`username` AS `username`, `user`.`email` AS `email`, `user`.`jenis_user` AS `jenis_user`, `user`.`foto_profil` AS `foto_profil`, `siswa`.`nama_lengkap` AS `nama_lengkap`, `siswa`.`nisn` AS `nisn`, `siswa`.`tingkat` AS `tingkat`, `siswa`.`tanggal_lahir` AS `tanggal_lahir` FROM (`siswa` join `user` on((`siswa`.`id_user` = `user`.`id_user`))) WHERE (`user`.`jenis_user` = 'Siswa') GROUP BY `user`.`username`, `user`.`email`, `user`.`jenis_user`, `user`.`foto_profil`, `siswa`.`nama_lengkap`, `siswa`.`nisn`, `siswa`.`tingkat`, `siswa`.`tanggal_lahir``tanggal_lahir`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `active_user`
--
ALTER TABLE `active_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `active_user_user_fk` (`user_id`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `id_admin` (`id_admin`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id_feedback`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_post` (`id_post`);

--
-- Indexes for table `guru`
--
ALTER TABLE `guru`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `nip` (`nip`);

--
-- Indexes for table `jawab`
--
ALTER TABLE `jawab`
  ADD PRIMARY KEY (`id_feedback`),
  ADD UNIQUE KEY `id_jawab` (`id_jawab`);

--
-- Indexes for table `komen`
--
ALTER TABLE `komen`
  ADD PRIMARY KEY (`id_feedback`),
  ADD UNIQUE KEY `id_komen` (`id_komen`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id_post`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`id_feedback`),
  ADD UNIQUE KEY `id_report` (`id_report`);

--
-- Indexes for table `repost`
--
ALTER TABLE `repost`
  ADD PRIMARY KEY (`id_feedback`),
  ADD UNIQUE KEY `id_repost` (`id_repost`);

--
-- Indexes for table `riwayat`
--
ALTER TABLE `riwayat`
  ADD PRIMARY KEY (`id_riwayat`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `save`
--
ALTER TABLE `save`
  ADD PRIMARY KEY (`id_save`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_post` (`id_post`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `nisn` (`nisn`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- Indexes for table `vote`
--
ALTER TABLE `vote`
  ADD PRIMARY KEY (`id_feedback`),
  ADD UNIQUE KEY `id_vote` (`id_vote`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `active_user`
--
ALTER TABLE `active_user`
  MODIFY `id` tinyint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id_feedback` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guru`
--
ALTER TABLE `guru`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jawab`
--
ALTER TABLE `jawab`
  MODIFY `id_jawab` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `komen`
--
ALTER TABLE `komen`
  MODIFY `id_komen` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `id_post` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `id_report` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `repost`
--
ALTER TABLE `repost`
  MODIFY `id_repost` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `riwayat`
--
ALTER TABLE `riwayat`
  MODIFY `id_riwayat` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `save`
--
ALTER TABLE `save`
  MODIFY `id_save` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `vote`
--
ALTER TABLE `vote`
  MODIFY `id_vote` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `active_user`
--
ALTER TABLE `active_user`
  ADD CONSTRAINT `active_user_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`id_post`) REFERENCES `post` (`id_post`);

--
-- Constraints for table `guru`
--
ALTER TABLE `guru`
  ADD CONSTRAINT `guru_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `jawab`
--
ALTER TABLE `jawab`
  ADD CONSTRAINT `jawab_ibfk_1` FOREIGN KEY (`id_feedback`) REFERENCES `feedback` (`id_feedback`);

--
-- Constraints for table `komen`
--
ALTER TABLE `komen`
  ADD CONSTRAINT `komen_ibfk_1` FOREIGN KEY (`id_feedback`) REFERENCES `feedback` (`id_feedback`);

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `report_ibfk_1` FOREIGN KEY (`id_feedback`) REFERENCES `feedback` (`id_feedback`);

--
-- Constraints for table `repost`
--
ALTER TABLE `repost`
  ADD CONSTRAINT `repost_ibfk_1` FOREIGN KEY (`id_feedback`) REFERENCES `feedback` (`id_feedback`);

--
-- Constraints for table `riwayat`
--
ALTER TABLE `riwayat`
  ADD CONSTRAINT `riwayat_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `save`
--
ALTER TABLE `save`
  ADD CONSTRAINT `save_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `save_ibfk_2` FOREIGN KEY (`id_post`) REFERENCES `post` (`id_post`);

--
-- Constraints for table `siswa`
--
ALTER TABLE `siswa`
  ADD CONSTRAINT `siswa_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `vote`
--
ALTER TABLE `vote`
  ADD CONSTRAINT `vote_ibfk_1` FOREIGN KEY (`id_feedback`) REFERENCES `feedback` (`id_feedback`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
