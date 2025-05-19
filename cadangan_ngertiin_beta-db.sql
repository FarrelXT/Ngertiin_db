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
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Nama_Lengkap VARCHAR(100) NOT NULL,
    Nama_Sekolah VARCHAR(100) NOT NULL,
    Tanggal_Lahir DATE NOT NULL,
    Telpon VARCHAR(20) NOT NULL,
    Domisili VARCHAR(100) NOT NULL,
    Foto_Profil VARCHAR(255) NOT NULL,
    NIP VARCHAR(20) NOT NULL,
    Mapel_diajarkan VARCHAR(255) NOT NULL, 
    Tingkat_diajarkan VARCHAR(50) NOT NULL,
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
    Tingkat_sekolah VARCHAR(10) NOT NULL,
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
CREATE TABLE Post (
    Id_post INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_pembuat VARCHAR(50) NOT NULL,
    Jenis_pembuat ENUM('guru', 'siswa') NOT NULL,
    Foto_file VARCHAR(255),
    Isi_post TEXT NOT NULL,
    Jenis_post ENUM('pertanyaan', 'catatan', 'materi') NOT NULL,
    Jumlah_upvote INT DEFAULT 0,
    Jumlah_downvote INT DEFAULT 0,
    Waktu_post DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Repost (
    Id_repost INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_post INT NOT NULL,
    Username_repost VARCHAR(50) NOT NULL,
    Jenis_user ENUM('guru', 'siswa') NOT NULL,
    Waktu_repost DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post)
);
CREATE TABLE Leaderboard (
    Id_leaderboard INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_siswa INT NOT NULL,
    Nama_leaderboard VARCHAR(50) NOT NULL,
    Rank_position INT NOT NULL,
    Kelas VARCHAR(10) NOT NULL,
    FOREIGN KEY (Id_siswa) REFERENCES Siswa(Id_siswa)
);
CREATE TABLE Report (
    Id_report INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_pelapor VARCHAR(50) NOT NULL,
    Jenis_pelapor ENUM('guru', 'siswa') NOT NULL,
    Id_konten INT NOT NULL,
    Jenis_konten ENUM('post', 'komentar') NOT NULL,
    Jenis_report VARCHAR(50) NOT NULL,
    Isi_report TEXT NOT NULL,
    Status_report ENUM('sedang ditangani', 'sedang diproses', 'tertangani') DEFAULT 'sedang diproses',
    Waktu_report DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- aditional table
CREATE TABLE Komentar (
    Id_komentar INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_post INT NOT NULL,
    Username_komentator VARCHAR(50) NOT NULL,
    Jenis_komentator ENUM('guru', 'siswa') NOT NULL,
    Isi_komentar TEXT NOT NULL,
    Waktu_komentar DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post)
);

CREATE TABLE Vote (
    Id_vote INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_post INT NOT NULL,
    Username_voter VARCHAR(50) NOT NULL,
    Jenis_voter ENUM('guru', 'siswa') NOT NULL,
    Jenis_vote ENUM('upvote', 'downvote') NOT NULL,
    FOREIGN KEY (Id_post) REFERENCES Post(Id_post),
    UNIQUE KEY unique_vote (Id_post, Username_voter, Jenis_voter)
);

CREATE TABLE Notifikasi (
    Id_notif INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_penerima VARCHAR(50) NOT NULL,
    Jenis_penerima ENUM('admin', 'guru', 'siswa') NOT NULL,
    Isi_notif TEXT NOT NULL,
    Dibaca BOOLEAN DEFAULT FALSE,
    Waktu_notif DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Pertemanan (
    Id_pertemanan INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_peminta VARCHAR(50) NOT NULL,
    Jenis_peminta ENUM('guru', 'siswa') NOT NULL,
    Username_penerima VARCHAR(50) NOT NULL,
    Jenis_penerima ENUM('guru', 'siswa') NOT NULL,
    Status ENUM('pending', 'accepted') NOT NULL DEFAULT 'pending',
    Tanggal_request DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Pesan (
    Id_pesan INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username_pengirim VARCHAR(50) NOT NULL,
    Jenis_pengirim ENUM('guru', 'siswa') NOT NULL,
    Username_penerima VARCHAR(50) NOT NULL,
    Jenis_penerima ENUM('guru', 'siswa') NOT NULL,
    Isi_pesan TEXT NOT NULL,
    Waktu_kirim DATETIME DEFAULT CURRENT_TIMESTAMP,
    Dibaca BOOLEAN DEFAULT FALSE
);

CREATE TABLE Grup (
    Id_grup INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Nama_grup VARCHAR(100) NOT NULL,
    Deskripsi TEXT,
    Username_pembuat VARCHAR(50) NOT NULL,
    Jenis_pembuat ENUM('guru', 'siswa') NOT NULL,
    Tanggal_pembuatan DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AnggotaGrup (
    Id_anggota INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_grup INT NOT NULL,
    Username_anggota VARCHAR(50) NOT NULL,
    Jenis_anggota ENUM('guru', 'siswa') NOT NULL,
    Role ENUM('admin', 'member') DEFAULT 'member',
    Tanggal_bergabung DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Id_grup) REFERENCES Grup(Id_grup)
);