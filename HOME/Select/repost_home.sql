SELECT
    r.isi_repost,
    p.isi_post
From repost r
JOIN feedback f ON r.id_feedback = f.id_feedback
JOIN post p ON f.id_post = p.id_post
WHERE f.id_post = {id_post}; -- placeholder post asli