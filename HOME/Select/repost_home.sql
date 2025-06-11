SELECT
    u.username AS username_repost,
    r.isi_repost,
    p.isi_post    
FROM repost r
JOIN feedback f ON r.id_feedback = f.id_feedback
JOIN post p ON f.id_post = p.id_post
JOIN user u ON f.id_user = u.id_user
WHERE f.id_post = {id_post}; -- placeholder post asli