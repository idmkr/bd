USE master;
GO
DROP DATABASE IF EXISTS MusicGraphDB;
GO
CREATE DATABASE MusicGraphDB;
GO

USE MusicGraphDB;
GO

-- Создание таблиц узлов
-- Таблица музыкальных групп
CREATE TABLE Bands (
    BandId INT PRIMARY KEY,
    Name NVARCHAR(100),
    Genre NVARCHAR(50)
) AS NODE;

-- Таблица альбомов
CREATE TABLE Albums (
    AlbumId INT PRIMARY KEY,
    Title NVARCHAR(200),
    ReleaseYear INT
) AS NODE;

-- Таблица участников
CREATE TABLE Members (
    MemberId INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Instrument NVARCHAR(100)
) AS NODE;

-- Участник принадлежит группе
CREATE TABLE MemberOfBand AS EDGE;

-- Группа выпустила альбом
CREATE TABLE ReleasedAlbum AS EDGE;

-- Дружба между группами
CREATE TABLE Friends AS EDGE;

-- Группы
INSERT INTO Bands (BandId, Name, Genre) VALUES
(1, N'Нервы', 'Rock'),
(2, N'ЛСП', 'Rap'),
(3, N'Кис-Кис', 'Rock'),
(4, N'Пошлая Молли', 'Rock'),
(5, N'Nirvana', 'Grunge'),
(6, N'Папин Олимпос', 'Alternative Rock'),
(7, N'Полматери', 'Jazz'),
(8, N'Måneskin', 'Rock'),
(9, N'Go_A', 'Electro'),
(10, N'Валентин Стрыкало', 'Rock');

-- Альбомы
INSERT INTO Albums (AlbumId, Title, ReleaseYear) VALUES
(1, N'Слэм и депрессия', 2021),
(2, N'Tragic City', 2017),
(3, N'Весёлые песни о смерти', 2020),
(4, N'Грустная девочка с глазами как у собаки', 2018),
(5, N'Nevermind', 1991),
(6, N'Живи, люби, танцуй', 2021),
(7, N'Песни для девственников', 2022),
(8, N'Rush!', 2023),
(9, N'Культура', 2016),
(10, N'Свободное плавание', 2014);

-- Участники
INSERT INTO Members (MemberId, FullName, Instrument) VALUES
(1, N'Юрий Каплан', N'vocal/guitar'),
(2, N'Арина Окунева', N'vocal/bass'),
(3, N'Артём Мельников', N'guitar'),
(4, N'Алина Олешева', N'drums'),
(5, N'Kurt Cobain', N'vocals'),
(6, N'Костя Боровский', N'guitar'),
(7, N'Krist Novoselic', N'bass'),
(8, N'Dave Grohl', N'drums'),
(9, N'Женя Мильковский', N'vocals'),
(10, N'Сергей Ковальчук', N'bass');

-- Ребро: Участник состоит в группе
INSERT INTO MemberOfBand ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Members WHERE MemberId = 1), (SELECT $node_id FROM Bands WHERE BandId = 10)),
((SELECT $node_id FROM Members WHERE MemberId = 2), (SELECT $node_id FROM Bands WHERE BandId = 3)),
((SELECT $node_id FROM Members WHERE MemberId = 3), (SELECT $node_id FROM Bands WHERE BandId = 6)),
((SELECT $node_id FROM Members WHERE MemberId = 4), (SELECT $node_id FROM Bands WHERE BandId = 3)),
((SELECT $node_id FROM Members WHERE MemberId = 5), (SELECT $node_id FROM Bands WHERE BandId = 5)),
((SELECT $node_id FROM Members WHERE MemberId = 6), (SELECT $node_id FROM Bands WHERE BandId = 1)),
((SELECT $node_id FROM Members WHERE MemberId = 7), (SELECT $node_id FROM Bands WHERE BandId = 5)),
((SELECT $node_id FROM Members WHERE MemberId = 8), (SELECT $node_id FROM Bands WHERE BandId = 5)),
((SELECT $node_id FROM Members WHERE MemberId = 9), (SELECT $node_id FROM Bands WHERE BandId = 1)),
((SELECT $node_id FROM Members WHERE MemberId = 10), (SELECT $node_id FROM Bands WHERE BandId = 7));

-- Ребро: Группа выпустила альбом
INSERT INTO ReleasedAlbum ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Bands WHERE BandId = 1), (SELECT $node_id FROM Albums WHERE AlbumId = 1)),
((SELECT $node_id FROM Bands WHERE BandId = 2), (SELECT $node_id FROM Albums WHERE AlbumId = 2)),
((SELECT $node_id FROM Bands WHERE BandId = 3), (SELECT $node_id FROM Albums WHERE AlbumId = 3)),
((SELECT $node_id FROM Bands WHERE BandId = 4), (SELECT $node_id FROM Albums WHERE AlbumId = 4)),
((SELECT $node_id FROM Bands WHERE BandId = 5), (SELECT $node_id FROM Albums WHERE AlbumId = 5)),
((SELECT $node_id FROM Bands WHERE BandId = 6), (SELECT $node_id FROM Albums WHERE AlbumId = 6)),
((SELECT $node_id FROM Bands WHERE BandId = 7), (SELECT $node_id FROM Albums WHERE AlbumId = 7)),
((SELECT $node_id FROM Bands WHERE BandId = 8), (SELECT $node_id FROM Albums WHERE AlbumId = 8)),
((SELECT $node_id FROM Bands WHERE BandId = 9), (SELECT $node_id FROM Albums WHERE AlbumId = 9)),
((SELECT $node_id FROM Bands WHERE BandId = 10), (SELECT $node_id FROM Albums WHERE AlbumId = 10));

-- Ребро: Дружба между группами (взаимно)
INSERT INTO Friends ($from_id, $to_id)
VALUES
-- Нервы дружат с
((SELECT $node_id FROM Bands WHERE BandId = 1), (SELECT $node_id FROM Bands WHERE BandId = 6)),
((SELECT $node_id FROM Bands WHERE BandId = 1), (SELECT $node_id FROM Bands WHERE BandId = 10)),
((SELECT $node_id FROM Bands WHERE BandId = 1), (SELECT $node_id FROM Bands WHERE BandId = 3)),
((SELECT $node_id FROM Bands WHERE BandId = 1), (SELECT $node_id FROM Bands WHERE BandId = 4)),
-- Ответные рёбра
((SELECT $node_id FROM Bands WHERE BandId = 6), (SELECT $node_id FROM Bands WHERE BandId = 1)),
((SELECT $node_id FROM Bands WHERE BandId = 10), (SELECT $node_id FROM Bands WHERE BandId = 1)),
((SELECT $node_id FROM Bands WHERE BandId = 3), (SELECT $node_id FROM Bands WHERE BandId = 1)),
((SELECT $node_id FROM Bands WHERE BandId = 4), (SELECT $node_id FROM Bands WHERE BandId = 1)),

-- Пошлая Молли дружит с
((SELECT $node_id FROM Bands WHERE BandId = 4), (SELECT $node_id FROM Bands WHERE BandId = 5)),
((SELECT $node_id FROM Bands WHERE BandId = 4), (SELECT $node_id FROM Bands WHERE BandId = 7)),
-- Ответные рёбра
((SELECT $node_id FROM Bands WHERE BandId = 5), (SELECT $node_id FROM Bands WHERE BandId = 4)),
((SELECT $node_id FROM Bands WHERE BandId = 7), (SELECT $node_id FROM Bands WHERE BandId = 4)),

-- Måneskin и Go_A
((SELECT $node_id FROM Bands WHERE BandId = 8), (SELECT $node_id FROM Bands WHERE BandId = 9)),
((SELECT $node_id FROM Bands WHERE BandId = 9), (SELECT $node_id FROM Bands WHERE BandId = 8));

SELECT m.FullName, m.Instrument
FROM Members AS m, MemberOfBand AS mb, Bands AS b
WHERE MATCH(m-(mb)->b) AND b.Name = N'Nirvana';

SELECT a.Title, a.ReleaseYear
FROM Albums AS a, ReleasedAlbum AS ra, Bands AS b
WHERE MATCH(b-(ra)->a) AND b.Name = N'Кис-Кис';

SELECT b2.Name
FROM Bands AS b1, Friends AS f, Bands AS b2
WHERE MATCH(b1-(f)->b2) AND b1.Name = N'Нервы';

SELECT b.Name AS BandName, a.Title AS AlbumTitle
FROM Bands AS b, ReleasedAlbum AS ra, Albums AS a
WHERE MATCH(b-(ra)->a) AND a.ReleaseYear = 2021;

SELECT m.FullName, m.Instrument, b.Name AS Band
FROM Members AS m, MemberOfBand AS mb, Bands AS b
WHERE MATCH(m-(mb)->b) AND b.Genre = 'Rock';

SELECT Band1.Name AS BandName,
       STRING_AGG(Band2.Name, '->') WITHIN GROUP (GRAPH PATH) AS FriendsPath
FROM Bands AS Band1,
     Friends FOR PATH AS i,
     Bands FOR PATH AS Band2
WHERE MATCH(SHORTEST_PATH(Band1(-(i)->Band2)+))
  AND Band1.Name = N'Нервы';

SELECT Band1.Name AS BandName,
       STRING_AGG(Band2.Name, '->') WITHIN GROUP (GRAPH PATH) AS FriendsPath
FROM Bands AS Band1,
     Friends FOR PATH AS i,
     Bands FOR PATH AS Band2
WHERE MATCH(SHORTEST_PATH(Band1(-(i)->Band2){1,3}))
  AND Band1.Name = N'Пошлая Молли';