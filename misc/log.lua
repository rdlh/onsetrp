function Log(player, type, content)

    local created_at = tostring(os.time(os.date("!*t")))

    local query = mariadb_prepare(sql, "INSERT INTO logs (`id`, `player`, `type`, `content`, `created_at`) VALUES (NULL, '?', '?', '?', '?');",
        tostring(player), type, content, created_at)

    mariadb_async_query(sql, query)
end