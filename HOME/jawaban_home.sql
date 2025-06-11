SELECT
  u.foto_profil,
  u.username,
  j.isi_jawab
FROM jawab j
JOIN feedback f ON j.id_feedback = f.id_feedback
JOIN user u ON f.id_user = u.id_user
WHERE f.id_post = {id_post}; -- placeholder post asli