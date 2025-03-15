/******************* In the Library *********************/

/*******************************************************/
/* find the number of availalbe copies of the book (Dracula)      */
/*******************************************************/

/* check total copies of the book */
-- your code
SELECT COUNT(*) AS Total_Copies FROM Books
WHERE Title = 'Dracula';

/* current total loans of the book */
-- your code
SELECT COUNT(*) AS Loaned_Copies FROM Loans AS l
INNER JOIN Books AS b ON l.BookID = b.BookID
WHERE b.Title = 'Dracula' AND l.ReturnedDate IS NULL;

/* total available books of dracula */
-- your code
SELECT 
    (SELECT COUNT(*) AS Total_Copies FROM Books
	WHERE Title = 'Dracula') - 
    (SELECT COUNT(*) AS Loaned_Copies FROM Loans AS l
	INNER JOIN Books AS b ON l.BookID = b.BookID
	WHERE b.Title = 'Dracula' AND l.ReturnedDate IS NULL) AS Available_Copies;


/*******************************************************/
/* Add new books to the library                        */
/*******************************************************/
-- your code
INSERT INTO Books VALUES (201, 'Rich Dad Poor Dad', 'Robert Kiyosaki', 1997, 1234567890);


/*******************************************************/
/* Check out Books: books(4043822646, 2855934983) whose patron_email(jvaan@wisdompets.com), loandate=2020-08-25, duedate=2020-09-08, loanid=by_your_choice*/
/*******************************************************/
-- your code
INSERT INTO Loans (LoanID,BookID,PatronID,LoanDate,DueDate,ReturnedDate)
VALUES 
(
	2001,
	(SELECT BookID FROM Books WHERE Barcode = 4043822646),
	(SELECT PatronID FROM Patrons WHERE Email = 'jvaan@wisdompets.com'),
    '2020-08-25',
    '2020-09-08',
    NULL
),
(
	2002,
	(SELECT BookID FROM Books WHERE Barcode = 2855934983),
	(SELECT PatronID FROM Patrons WHERE Email = 'jvaan@wisdompets.com'),
    '2020-08-25',
    '2020-09-08',
    NULL
);


/********************************************************/
/* Check books for Due back                             */
/* generate a report of books due back on July 13, 2020 */
/* with patron contact information                      */
/********************************************************/
-- your code
SELECT p.PatronID, p.FirstName, p.LastName, p.Email, b.BookID, b.Title, l.DueDate FROM Loans AS l
INNER JOIN Books AS b ON l.BookID = b.BookID
INNER JOIN Patrons AS p ON l.PatronID = p.PatronID
WHERE l.DueDate = '2020-07-13' AND l.ReturnedDate IS NULL;


/*******************************************************/
/* Return books to the library (which have barcode=6435968624) and return this book at this date(2020-07-05)                    */
/*******************************************************/
-- your code
UPDATE Loans 
SET ReturnedDate = '2020-07-05'
WHERE BookID = (SELECT BookID FROM Books WHERE Barcode = 6435968624) AND ReturnedDate IS NULL;


/*******************************************************/
/* Encourage Patrons to check out books                */
/* generate a report of showing 10 patrons who have
checked out the fewest books.                          */
/*******************************************************/
-- your code
SELECT p.PatronID, p.FirstName, p.LastName, p.Email, COUNT(l.LoanID) AS books_borrowed FROM Patrons AS p
LEFT JOIN Loans AS l ON p.PatronID = l.PatronID
GROUP BY p.PatronID
ORDER BY books_borrowed ASC
LIMIT 10;


/*******************************************************/
/* Find books to feature for an event                  
 create a list of books from 1890s that are
 currently available                                    */
/*******************************************************/
-- your code
SELECT * FROM Books
WHERE Published BETWEEN 1890 AND 1899 AND BookID NOT IN (SELECT BookID FROM Loans WHERE ReturnedDate IS NULL);


/*******************************************************/
/* Book Statistics 
/* create a report to show how many books were 
published each year.                                    */
/*******************************************************/
SELECT Published, COUNT(DISTINCT(Title)) AS TotalNumberOfPublishedBooks FROM Books
GROUP BY Published
ORDER BY TotalNumberOfPublishedBooks DESC;


/*************************************************************/
/* Book Statistics                                           */
/* create a report to show 5 most popular Books to check out */
/*************************************************************/
SELECT b.BookID, b.Title, b.Author, b.Published, COUNT(l.LoanID) AS TotalTimesOfLoans FROM Books b
JOIN Loans l ON b.BookID = l.BookID
GROUP BY b.BookID
ORDER BY 4 DESC
LIMIT 5;


-- BONUS
-- 15. Select shipper together with the total price of proceed orders
SELECT s.ShipperName, SUM(od.Quantity * p.Price) AS Total_Price FROM orders as o
INNER JOIN shippers as s ON o.ShipperID = s.ShipperID
INNER JOIN order_details as od ON o.OrderID = od.OrderID
INNER JOIN products as p ON od.ProductID = p.ProductID
GROUP BY s.ShipperName;

