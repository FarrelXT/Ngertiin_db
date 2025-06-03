-- cek admin dari fungsi database
IF can_access_info(user_id) THEN
    SELECT * FROM info;
ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied';
END IF;