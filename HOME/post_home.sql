SELECT 
    vpd.id_post,
    vpd.username,
    vpd.jenis_user,
    vpd.foto_profil,
    vpd.isi_post,
    vpd.file_foto,
    vpd.tanggal_post,
    vpd.jumlah_feedback,
    vpd.jumlah_save,
    vpd.jumlah_jawab,
    vpd.jumlah_komen,
    vpd.jumlah_repost,
    vpd.jumlah_report,
    vpd.total_upvote,
    vpd.total_downvote,
    CASE -- cek sudah save post
        WHEN s.id_save IS NOT NULL THEN 1 
        ELSE 0 
    END as is_saved_by_user,
    CASE -- cek udah kasih vote
        WHEN f.id_feedback IS NOT NULL THEN 1 
        ELSE 0
        WHEN v.upvote > 0 THEN 'upvoted'
        WHEN v.downvote > 0 THEN 'downvoted'
        ELSE 'not_voted'
    END as user_vote_status
FROM 
    view_post_detail vpd
LEFT JOIN save s ON vpd.id_post = s.id_post AND s.id_user = ? -- parameter: user ID yg lagi login
LEFT JOIN feedback f ON vpd.id_post = f.id_post AND f.id_user = ?-- parameter: user ID yg lagi login
LEFT JOIN vote v ON f.id_feedback = v.id_feedback
WHERE 
    vpd.status_post = 'Publik'
ORDER BY 
    vpd.tanggal_post DESC, 
    vpd.total_upvote DESC
LIMIT 20 OFFSET ?; -- Parameter: ganti agar tiap 20 baris post = offset +20