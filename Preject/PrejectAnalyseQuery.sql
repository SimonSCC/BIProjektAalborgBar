/* Analyse af Member tabellen */
SELECT * FROM Member WHERE active = 0 
SELECT * FROM Member WHERE active = 1

SELECT * FROM Member WHERE [year] = 2007
SELECT * FROM Member WHERE [year] = 2006

SELECT * FROM Member WHERE [year] = 0

SELECT * FROM Payment WHERE member_id = 61

/*
Normal konto
*/
SELECT * FROM Member where id = 2321
SELECT * FROM Payment WHERE member_id = 2321
/**/


SELECT * FROM Payment WHERE id = 1060
SELECT * FROM Member Where id = 1060
SELECT * FROM Sale WHERE id = 1060

SELECT * FROM Member WHERE balance < 0 

/*Payment Analyse*/
SELECT * FROM Payment 

SELECT * FROM Payment where member_id = 878
SELECT * FROM Member where id = 878

SELECT * FROM Payment where [timestamp] = '1996-11-29 12:48:02.000'
SELECT * FROM Sale Where [timestamp]=  '1996-11-29 12:48:02.000'
SELECT * FROM Sale where member_id = 878

SELECT * FROM Member WHERE id = 967
SELECT * FROM Payment where member_id = 967
SELECT * FROM Sale where [timestamp] = '2000-05-26 14:19:21.000'
SELECT * FROM Sale where [timestamp] = '2001-10-05 12:58:57.000'
SELECT * FROm Sale where member_id = 967


/*Sale Analyse*/
SELECT * FROM Sale

SELECT * FROM Sale WHERE room_id = 2

SELECT * FROM Member
SELECT * FROM Payment
SELECT * FROM Product
SELECT * FROM Room
SELECT * FROM Sale
SELECT * FROM SemesterGroups






