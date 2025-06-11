SELECT 
    r.Id_report, 
    r.Username_pelapor,
    r.Jenis_pelapor, 
    r.Konten_type,
    r.Id_konten,
    r.Jenis_report,
    r.Isi_report,
    r.Status_report,
    r.Waktu_report,
    
    -- Content by type
    CASE 
        WHEN r.Konten_type = 'post' THEN p.Isi_post
        WHEN r.Konten_type = 'komentar' THEN k.Isi_komentar
        WHEN r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'siswa' THEN CONCAT('Account: ', s.Username)
        WHEN r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'guru' THEN CONCAT('Account: ', g.Username)
        ELSE NULL
    END AS reported_content,
    
    -- Creator username
    CASE 
        WHEN r.Konten_type = 'post' THEN p.Username_pembuat
        WHEN r.Konten_type = 'komentar' THEN k.Username_komentator
        WHEN r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'siswa' THEN s.Username
        WHEN r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'guru' THEN g.Username
        ELSE NULL
    END AS content_creator,
    
    -- Account information if applicable
    CASE
        WHEN r.Konten_type = 'akun' THEN r.Jenis_konten_akun
        ELSE NULL
    END AS account_type,
    
    -- Full name for account reports
    CASE
        WHEN r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'siswa' THEN s.Nama_lengkap
        WHEN r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'guru' THEN g.Nama_Lengkap
        ELSE NULL
    END AS full_name
    
FROM Report r
LEFT JOIN Post p ON r.Konten_type = 'post' AND r.Id_konten = p.Id_post
LEFT JOIN Komentar k ON r.Konten_type = 'komentar' AND r.Id_konten = k.Id_komentar
LEFT JOIN Siswa s ON r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'siswa' AND r.Id_konten = s.Id_siswa
LEFT JOIN Guru g ON r.Konten_type = 'akun' AND r.Jenis_konten_akun = 'guru' AND r.Id_konten = g.Id_guru
ORDER BY r.Waktu_report DESC;