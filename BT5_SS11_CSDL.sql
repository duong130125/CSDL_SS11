-- 3
CREATE VIEW View_Album_Artist AS
SELECT 
    a.AlbumId AS Album_ID, 
    a.Title AS Album_Title, 
    ar.Name AS Artist_Name
FROM Album a
JOIN Artist ar ON a.ArtistId = ar.ArtistId;

-- 4
CREATE VIEW View_Customer_Spending AS
SELECT 
    c.CustomerId, 
    c.FirstName, 
    c.LastName, 
    c.Email, 
    COALESCE(SUM(i.Total), 0) AS Total_Spending
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Email;

-- 5
CREATE INDEX idx_Employee_LastName ON Employee (LastName);
EXPLAIN SELECT * FROM Employee WHERE LastName = 'King';

-- 6
DELIMITER //
CREATE PROCEDURE GetTracksByGenre(IN GenreId INT)
BEGIN
    SELECT 
        t.TrackId AS Track_ID, 
        t.Name AS Track_Name, 
        a.Title AS Album_Title, 
        ar.Name AS Artist_Name
    FROM Track t
    LEFT JOIN Album a ON t.AlbumId = a.AlbumId
    LEFT JOIN Artist ar ON a.ArtistId = ar.ArtistId
    WHERE t.GenreId = GenreId;
END //
DELIMITER ;
--
CALL GetTracksByGenre(7);

-- 7
DELIMITER //
CREATE PROCEDURE GetTrackCountByAlbum(IN p_AlbumId INT)
BEGIN
    SELECT 
        COUNT(*) AS Total_Tracks
    FROM Track 
    WHERE AlbumId = p_AlbumId;
END //
DELIMITER ;
--
CALL GetTrackCountByAlbum(7);

-- 8
DROP VIEW IF EXISTS View_Album_Artist;
DROP VIEW IF EXISTS View_Customer_Spending;
DROP PROCEDURE IF EXISTS GetTracksByGenre;
DROP PROCEDURE IF EXISTS GetTrackCountByAlbum;
DROP INDEX idx_Employee_LastName ON Employee;