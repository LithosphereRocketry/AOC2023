CREATE TEMPORARY TABLE CsvData(
    row VARCHAR(200)
);

-- A separator that will never exist so we just get rows
.separator '~'
.import input.txt CsvData
.separator ','

CREATE TEMPORARY TABLE NumbererdRows(
    id INT PRIMARY KEY,
    txt VARCHAR(200)
);

INSERT INTO NumbererdRows
SELECT CAST(SUBSTRING(row, 5, instr(row, ":")-5) AS INT),
       REPLACE(SUBSTRING(row, instr(row, ":")+2), ';', ',')
FROM CsvData WHERE true;

CREATE TEMPORARY TABLE Draws(
    id INT,
    color char(1),
    value INT
);

WITH RECURSIVE CteRows(id, txt, color, value) AS (
        SELECT id, txt, ' ', -1
        FROM NumbererdRows

        UNION ALL
        
        SELECT
            id,
            IIF(INSTR(txt, ",")=0,
                NULL,
                SUBSTRING(txt, INSTR(txt, ",")+2)),
            SUBSTRING(txt, INSTR(txt, " ")+1, 1),
            CAST(SUBSTRING(txt, 0, INSTR(txt, " ")) AS INT)
        FROM CteRows
        WHERE txt NOT NULL
    )
INSERT INTO Draws
SELECT id, color, value FROM CteRows
WHERE value >= 0;

CREATE TEMPORARY TABLE Games(
    id INT PRIMARY KEY,
    red INT DEFAULT 0,
    green INT DEFAULT 0,
    blue INT DEFAULT 0
);

INSERT INTO Games
SELECT id, MAX(IIF(color='r', value, 0)),
           MAX(IIF(color='g', value, 0)),
           MAX(IIF(color='b', value, 0))
FROM Draws
WHERE true
GROUP BY id;

CREATE TEMPORARY TABLE ValidGames(
    id INT PRIMARY KEY,
    red INT DEFAULT 0,
    green INT DEFAULT 0,
    blue INT DEFAULT 0
);

INSERT INTO ValidGames
SELECT * FROM Games
WHERE red <= 12 AND green <= 13 AND blue <= 14;

SELECT SUM(id) FROM ValidGames;