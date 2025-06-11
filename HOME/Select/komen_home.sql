SELECT 
  u.foto_profil,
  u.username,
  k.isi_komen
FROM komen k
JOIN feedback f ON k.id_feedback = f.id_feedback
JOIN user u ON f.id_user = u.id_user
WHERE f.id_post = {id_post}; -- placeholder post asli