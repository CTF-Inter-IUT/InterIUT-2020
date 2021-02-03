# Backup SQL database
`docker exec skull_db /usr/bin/mysqldump -u root --password=root database > backup.sql`

# Restore backup
`cat backup.sql | docker exec -it skull_db /usr/bin/mysql -u root --password=root database`
