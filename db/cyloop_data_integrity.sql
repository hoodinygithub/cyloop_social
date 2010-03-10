SELECT 'Starting data validation script...' AS ' ';
SELECT 'Accounts' AS ' ';
SET @accounts_count = (SELECT COUNT(*) FROM accounts);
SELECT CONCAT(@accounts_count, ' accounts in table. ' ) AS ' ';
SELECT type as ' ', count(*) AS '  ' FROM accounts GROUP BY 1;

SELECT '/*********************************************************/' AS ' ';

SELECT 'Albums' AS ' ';
SET @albums_count = (SELECT COUNT(*) FROM albums);
SELECT CONCAT(@albums_count, ' albums in table.') AS ' ';
SET @albums_fk_accounts = (SELECT count(*) FROM albums al LEFT JOIN accounts a ON al.owner_id = a.id WHERE a.id IS NULL);

SELECT IF(@albums_fk_accounts > 0, CONCAT(@albums_fk_accounts, ' orphaned records on albums.owner_id = accounts.id'), 'No orphaned blocks on owner_id.') AS '';

SELECT '/*********************************************************/' AS ' ';
SELECT 'Blocks' AS ' ';
SET @blocks_count = (SELECT COUNT(*) FROM blocks);
SELECT CONCAT(@blocks_count, ' blocks in table.') AS ' ';
SET @blocks_fk_blocker = (SELECT count(*) FROM blocks b LEFT JOIN accounts a ON b.blocker_id = a.id WHERE a.id IS NULL);
SET @blocks_fk_blockee = (SELECT count(*) FROM blocks b LEFT JOIN accounts a ON b.blockee_id = a.id WHERE a.id IS NULL);

SELECT IF(@blocks_fk_blocker > 0, CONCAT(@blocks_fk_blocker, ' orphaned records on blocks.blocker_id = accounts.id'), 'No orphaned blocks on blocker_id.') AS '';
SELECT IF(@blocks_fk_blockee > 0, CONCAT(@blocks_fk_blockee, ' orphaned records on blocks.blockee_id = accounts.id.'), 'No orphaned blocks on blockee_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Cities' AS ' ';

SET @cities_count = (SELECT COUNT(*) FROM cities);
SELECT CONCAT(@cities_count, ' cities in table.') AS ' ';
SET @cities_fk_accounts = (SELECT count(*) FROM accounts a LEFT JOIN cities c  ON a.city_id = c.id WHERE c.id IS NULL);
SET @null_cities_in_accounts = (SELECT count(*) FROM accounts a WHERE city_id IS NULL);

SELECT IF(@null_cities_in_accounts > 0, CONCAT(@null_cities_in_accounts, ' NULL cities in accounts table.'), 'No orphaned records in cities.') AS '';
SELECT IF(@cities_fk_accounts > 0, CONCAT(@cities_fk_accounts, ' orphaned records in cities on accounts.city_id = cities.id.'), 'No orphaned records in cities.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Countries' AS ' ';

SET @countries_count = (SELECT COUNT(*) FROM countries);
SELECT CONCAT(@countries_count, ' countries in table.') AS ' ';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Followings' AS ' ';

SET @followings_count = (SELECT COUNT(*) FROM followings);
SELECT CONCAT(@followings_count, ' followings in table.') AS ' ';

SET @followings_fk_follower = (SELECT count(*) FROM followings f LEFT JOIN accounts a ON f.follower_id = a.id WHERE a.id IS NULL);
SET @followings_fk_followee = (SELECT count(*) FROM followings f LEFT JOIN accounts a ON f.followee_id = a.id WHERE a.id IS NULL);

SELECT IF(@followings_fk_follower > 0, CONCAT(@followings_fk_follower, ' orphaned records on followings.follower_id = accounts.id.'), 'No orphaned records on followings.follower_id.') AS '';
SELECT IF(@followings_fk_followee > 0, CONCAT(@followings_fk_followee, ' orphaned records on followings.followee_id = accounts.id.'), 'No orphaned records on followings.followee_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Locales' AS ' ';

SET @locales_count = (SELECT COUNT(*) FROM locales);
SELECT CONCAT(@locales_count, ' locales in table.') AS ' ';

SET @locales_fk_countries = (SELECT count(*) FROM locales l LEFT JOIN countries c ON l.country_id = c.id WHERE c.id IS NULL);

SELECT IF(@locales_fk_countries > 0, CONCAT(@locales_fk_countries, ' orphaned records on locales.country_id = locales.id.'), 'No orphaned records on locales.country_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Genres' AS ' ';

SET @locales_count = (SELECT COUNT(*) FROM genres);
SELECT CONCAT(@locales_count, ' locales in table.') AS ' ';

SET @genres_fk_accounts = (SELECT count(*) FROM accounts a LEFT JOIN genres g ON a.genre_id = g.id WHERE g.id IS NULL);
SET @null_genres_in_accounts = (SELECT count(*) FROM accounts a WHERE genre_id IS NULL);

SELECT IF(@null_genres_in_accounts > 0, CONCAT(@null_genres_in_accounts, ' NULL genres in accounts table.'), 'No orphaned records in genres.') AS '';
SELECT IF(@genres_fk_accounts > 0, CONCAT(@genres_fk_accounts, ' orphaned records in cities on accounts.genre_id = genre.id.'), 'No orphaned records in genres.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Playlists' AS ' ';

SET @playlists_count = (SELECT COUNT(*) FROM playlists);
SELECT CONCAT(@playlists_count, ' playlists in table.') AS ' ';

SET @playlists_fk = (SELECT count(*) FROM playlists p LEFT JOIN accounts a ON p.owner_id = a.id WHERE a.id IS NULL);

SELECT IF(@playlists_fk > 0, CONCAT(@playlists_fk, ' orphaned records on playlists.owner_id = accounts.id.'), 'No orphaned records on playlists.owner_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Playlist_Items' AS ' ';

SET @playlistitems_count = (SELECT COUNT(*) FROM playlist_items);
SELECT CONCAT(@playlistitems_count, ' playlist_items in table.') AS ' ';

SET @playlistitems_fk_playlists = (SELECT count(*) FROM playlist_items pi LEFT JOIN playlists p ON pi.playlist_id = p.id WHERE p.id IS NULL);
SET @playlistitems_fk_songs = (SELECT count(*) FROM playlist_items pi LEFT JOIN songs s ON pi.song_id = s.id WHERE s.id IS NULL);

SELECT IF(@playlistitems_fk_playlists > 0, CONCAT(@playlistitems_fk_playlists, ' orphaned records on playlist_items.playlist_id = playlists.id.'), 'No orphaned records on playlist_items.playlist_id.') AS '';
SELECT IF(@playlistitems_fk_playlists > 0, CONCAT(@playlistitems_fk_playlists, ' orphaned records on playlist_items.song_id = songs.id.'), 'No orphaned records on playlist_items.song_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Regions' AS ' ';

SET @regions_count = (SELECT COUNT(*) FROM regions);
SELECT CONCAT(@regions_count, ' regions in table.') AS ' ';

SET @regions_fk_countries = (SELECT count(*) FROM regions r LEFT JOIN countries c ON r.country_id = c.id WHERE c.id IS NULL);

SELECT IF(@regions_fk_countries > 0, CONCAT(@regions_fk_countries, ' orphaned records on regions.country_id = countries.id.'), 'No orphaned records on regions.country_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Sites' AS ' ';

SET @sites_count = (SELECT COUNT(*) FROM sites);
SELECT CONCAT(@sites_count, ' sites in table.') AS ' ';

SELECT '/*********************************************************/' AS ' ';

SELECT 'SiteLocales' AS ' ';

SET @site_locales_count = (SELECT COUNT(*) FROM site_locales);
SELECT CONCAT(@site_locales_count, ' site_locales in table.') AS ' ';

SET @site_locales_fk_sites = (SELECT count(*) FROM site_locales sl LEFT JOIN sites s ON sl.site_id = s.id WHERE s.id IS NULL);
SET @site_locales_fk_locales = (SELECT count(*) FROM site_locales sl LEFT JOIN locales l ON sl.locale_id = l.id WHERE l.id IS NULL);

SELECT IF(@site_locales_fk_sites > 0, CONCAT(@site_locales_fk_sites, ' orphaned records on site_locales.site_id = sites.id.'), 'No orphaned records on site_locales.site_id.') AS '';
SELECT IF(@site_locales_fk_locales > 0, CONCAT(@site_locales_fk_locales, ' orphaned records on site_locales.locale_id = locales.id.'), 'No orphaned records on site_locales.locale_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'SongGenres' AS ' ';

SET @song_genres_count = (SELECT COUNT(*) FROM song_genres);
SELECT CONCAT(@song_genres_count, ' song_genres in table.') AS ' ';

SET @song_genres_fk_songs = (SELECT count(*) FROM song_genres sg LEFT JOIN songs s ON sg.song_id = s.id WHERE s.id IS NULL);
SET @song_genres_fk_genres = (SELECT count(*) FROM song_genres sg LEFT JOIN genres g ON sg.genre_id = g.id WHERE g.id IS NULL);

SELECT IF(@song_genres_fk_songs > 0, CONCAT(@song_genres_fk_songs, ' orphaned records on song_genres.song_id = songs.id.'), 'No orphaned records on song_genres.song_id.') AS '';
SELECT IF(@song_genres_fk_genres > 0, CONCAT(@song_genres_fk_genres, ' orphaned records on song_genres.genre_id = genres.id.'), 'No orphaned records on song_genres.genre_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Song_Listens' AS ' ';

SET @songlistens_count = (SELECT COUNT(*) FROM song_listens);
SELECT CONCAT(@songlistens_count, ' song_listens in table.') AS ' ';

SET @songlistens_fk_accounts_listeners = (SELECT count(*) FROM song_listens sl LEFT JOIN accounts a ON sl.listener_id = a.id WHERE a.id IS NULL);
SET @songlistens_fk_songs = (SELECT count(*) FROM song_listens sl LEFT JOIN songs s ON sl.song_id = s.id WHERE s.id IS NULL);
SET @songlistens_fk_accounts_artists = (SELECT count(*) FROM song_listens sl LEFT JOIN accounts a ON sl.artist_id = a.id WHERE a.id IS NULL);
SET @songlistens_fk_sites = (SELECT count(*) FROM song_listens sl LEFT JOIN sites s ON sl.site_id = s.id WHERE s.id IS NULL);

SELECT IF(@songlistens_fk_accounts_listeners > 0, CONCAT(@songlistens_fk_accounts_listeners, ' orphaned records on song_listens.listener_id = accounts.id.'), 'No orphaned records on song_listens.listener_id.') AS '';
SELECT IF(@songlistens_fk_songs > 0, CONCAT(@songlistens_fk_songs, ' orphaned records on song_listens.song_id = songs.id.'), 'No orphaned records on song_listens.song_id.') AS '';
SELECT IF(@songlistens_fk_accounts_artists > 0, CONCAT(@songlistens_fk_accounts_artists, ' orphaned records on song_listens.artist_id = accounts.id.'), 'No orphaned records on song_listens.artist_id.') AS '';
SELECT IF(@songlistens_fk_sites > 0, CONCAT(@songlistens_fk_sites, ' orphaned records on song_listens.site_id = sites.id.'), 'No orphaned records on song_listens.site_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Raw_Song_Plays' AS ' ';

SET @songplays_count = (SELECT COUNT(*) FROM raw_song_plays);
SELECT CONCAT(@songplays_count, ' raw song_plays in table.') AS ' ';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Songs' AS ' ';

SET @songs_count = (SELECT COUNT(*) FROM songs);
SELECT CONCAT(@songs_count, ' songs in table.') AS ' ';

SET @songs_fk_accounts = (SELECT count(*) FROM songs s LEFT JOIN accounts a ON s.artist_id = a.id WHERE a.id IS NULL);
SET @songs_fk_albums = (SELECT count(*) FROM songs s LEFT JOIN albums a ON s.album_id = a.id WHERE a.id IS NULL);

SELECT IF(@songs_fk_accounts > 0, CONCAT(@songs_fk_account, ' orphaned records on songs.artist_id = accounts.id.'), 'No orphaned records on songs.artist_id.') AS '';
SELECT IF(@songs_fk_albums > 0, CONCAT(@songs_fk_albums, ' orphaned records on songs.album_id = albums.id.'), 'No orphaned records on songs.album_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'Stations' AS ' ';

SET @stations_count = (SELECT COUNT(*) FROM stations);
SELECT CONCAT(@stations_count, ' stations in table.') AS ' ';

SET @stations_fk_accounts = (SELECT count(*) FROM stations s LEFT JOIN accounts a ON s.artist_id = a.id WHERE a.id IS NULL AND s.artist_id IS NOT NULL);

SELECT IF(@stations_fk_accounts > 0, CONCAT(@stations_fk_accounts, ' orphaned records on stations.artist_id = accounts.id.'), 'No orphaned records on stations.artist_id.') AS '';

SELECT '/*********************************************************/' AS ' ';

SELECT 'User_Stations' AS ' ';

SET @userstations_count = (SELECT COUNT(*) FROM user_stations);
SELECT CONCAT(@userstations_count, ' user_stations in table.') AS ' ';

SET @userstations_fk_stations = (SELECT count(*) FROM user_stations us LEFT JOIN stations s ON us.station_id = s.id WHERE s.id IS NULL);
SET @userstations_fk_accounts = (SELECT count(*) FROM user_stations us LEFT JOIN accounts a ON us.owner_id = a.id WHERE a.id IS NULL);
SET @userstations_fk_sites = (SELECT count(*) FROM user_stations us LEFT JOIN sites s ON us.site_id = s.id WHERE s.id IS NULL);

SELECT IF(@userstations_fk_stations > 0, CONCAT(@userstations_fk_stations, ' orphaned records on user_stations.station_id = stations.id.'), 'No orphaned records on user_stations.station_id.') AS '';
SELECT IF(@userstations_fk_accounts > 0, CONCAT(@userstations_fk_accounts, ' orphaned records on user_stations.owner_id = accounts.id.'), 'No orphaned records on user_stations.owner_id.') AS '';
SELECT IF(@userstations_fk_sites > 0, CONCAT(@userstations_fk_sites, ' orphaned records on user_stations.site_id = sites.id.'), 'No orphaned records on user_stations.site_id.') AS '';





