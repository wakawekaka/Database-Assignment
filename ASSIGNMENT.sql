create database Library;
use Library;

Create table MemberDetails
(MemberID nvarchar(50) Not Null Primary Key,
MemberName nvarchar(50));

Create table Tag
(TagID nvarchar(50) Not Null Primary Key,
TagColour nvarchar(50),
LoanPeriod nvarchar(50),
OverduePricePerDay decimal(10,2));
 
Create table BookDetails
(ISBN nvarchar(50) Not Null Primary Key,
BookDescription nvarchar(1000),
Publisher nvarchar(50),
Tag_ID nvarchar(50) Foreign Key References Tag(TagID),
BookName nvarchar(50));

Create table BookCopies
(BookID nvarchar(50) Not Null Primary Key,
ISBN nvarchar(50) Foreign Key References BookDetails(ISBN));

Create table LoanDetails
(LoanID nvarchar(50) Not Null Primary Key,
MemberID nvarchar(50) Foreign Key references MemberDetails(MemberID),
BookID nvarchar(50) Foreign Key references BookCopies(BookID),
OverdueStatus nvarchar(50),
StartDate date,
EndDate date);

Create table GenreDetails
(Genre_ID nvarchar(50) Not Null Primary Key,
Genre nvarchar(50));

Create table BookGenre
(ISBN nvarchar(50) Foreign Key References BookDetails(ISBN),
Genre_ID nvarchar(50) Foreign Key references GenreDetails(Genre_ID));


 insert into MemberDetails values
('M01','Nando'),
('M02','Vidi'),
('M03','Ismail'),
('M04','Julius'),
('M05','Jason'),
('M06','Matthew'),
('M07','Kent');

insert into Tag values
('T01','Green','12 Days','10'),
('T02','Yellow','10 Days','10'),
('T03','Red','8 Days','10');

insert into BookDetails values
('9780134484143','A classic fantasy novel about a group of hobbits who set out to destroy the One Ring, an evil artifact created by the Dark Lord Sauron.','Harper Perennial','T02','The Lord of the Rings'),
('9780375706474','A science fiction novel about a group of astronauts who are sent on a mission to Jupiter to investigate a mysterious black monolith.','Harper Perennial','T03','A Space Odyssey'),
('9780062316097','A mystery novel about Sherlock Holmes and Dr. Watson who investigate the death of Sir Charles Baskerville, who was found dead on his estate with the footprints of a gigantic hound nearby.',
'Azure Press','T01','The Hound of the Baskervilles'),
('9780571220950','A horror novel about a family who is haunted by the ghosts of the Overlook Hotel, where they are staying for the winter.','Azure Press','T01','The Shining'),
('9780439023491','A romance novel about a young couple who fall in love during World War II, but are separated by circumstances.','Azure Press','T03','The Notebook'),
('9781492001115','A non-fiction book about the science of habit formation and how to change your habits for the better.','Emberstone Books','T03','The Power of Habit'),
('9780316267980','A self-help book about the law of attraction, which is the belief that positive thoughts can bring positive experiences into your life.','Emberstone Books','T02','The Secret'),
('9780765366439','A childrens book about a cat who comes to visit two children while their mother is away.','Emberstone Books','T03','Persepolis'),
('9781481444763','A graphic novel about the authors childhood growing up in Iran during the Islamic Revolution.','Harper Perennial','T01','The Cat in the Hat'),
('9780330323903','dystopian novel, that is regarded as perhaps the greatest work by American author and has been praised for its stance against censorship and its defense of literature as necessary both to the humanity of individuals and to civilization.',
'Harper Perennial','T01','The Lancet');

insert into BookCopies values
('B01','9780134484143'),
('B02','9780375706474'),
('B03','9780062316097'),
('B04','9780571220950'),
('B05','9780439023491'),
('B06','9781492001115'),
('B07','9780316267980'),
('B08','9780765366439'),
('B09','9781481444763'),
('B10','9780330323903');

insert into LoanDetails values
('L01','M04','B09','COMPLETED','2022-3-2','2022-3-3'),
('L02','M06','B10','COMPLETED','2022-5-1','2022-5-10'),
('L03','M02','B08','COMPLETED','2022-9-3','2022-9-11'),
('L04','M02','B05','LATE','2023-1-1','2023-1-11'),
('L05','M03','B03','LATE','2023-1-3','2023-1-13'),
('L06','M04','B04','EARLY','2023-1-5','2023-1-15'),
('L07','M02','B02','EARLY','2023-1-7','2023-1-17'),
('L08','M01','B01','EARLY','2023-1-9','2023-1-19'),
('L09','M06','B06','EARLY','2023-1-9','2023-1-20'),
('L10','M07','B07','EARLY','2023-1-13','2023-1-23');

insert into GenreDetails values
('G01','Fantsy'),
('G02','Mystery'),
('G03','Self-help'),
('G04','Science Fiction'),
('G05','Horror'),
('G06','Romance'),
('G07','Non-Fiction');

insert into BookGenre values
('9780134484143','G01'),
('9780134484143','G02'),
('9780134484143','G03'),
('9780375706474','G04'),
('9780062316097','G02'),
('9780571220950','G05'),
('9780439023491','G06'),
('9781492001115','G07'),
('9780316267980','G03');

--Question 1: For each memeber who has borrowed more than 2 books, list the member names and the total number of books currently on loan to them. 
--            List the results in descending order of the total number.
select MemberDetails.MemberName, count(LoanDetails.BookID) as BookCount
from MemberDetails join LoanDetails on MemberDetails.MemberID = LoanDetails.MemberID
group by MemberName
having count(LoanDetails.BookID)>2
order by BookCount desc;



--Question 2: List the total number of books available in each category. List the results in decending order of the total number.
select GenreDetails.Genre, count(BookGenre.ISBN) as TotalBookCount
from GenreDetails left join BookGenre on GenreDetails.Genre_ID = BookGenre.Genre_ID
group by Genre
order by TotalBookCount desc;


--Question 3: Find the genre which has the highest number of books.
select top 1 Genre, count(*) as BookCount
from GenreDetails
join BookGenre on GenreDetails.Genre_ID = BookGenre.Genre_ID
group by Genre
order by BookCount desc

--Question 4:Show the books which are currently available for loan.
select Details.ISBN, Details.BookName
from BookDetails Details
join BookCopies Copies on Details.ISBN = Copies.ISBN
join LoanDetails Loan on Copies.BookID = Loan.BookID
where Loan.OverdueStatus = 'Completed';

--Question 5: List the member(s) who had made more than 2 loans.
select MemberName
from MemberDetails
join LoanDetails on MemberDetails.MemberID = LoanDetails.MemberID
group by MemberName
having count(LoanDetails.LoanID) > 2;

--Question 6 List the books which are written by more than 2 authors.
select BookName
from BookDetails
Group by BookName
having count(distinct Bookdetails.Publisher) > 2;

--Question 7 Find the member(s) which has overdue loan.
select MemberName
from MemberDetails
join LoanDetails
on MemberDetails.MemberID = LoanDetails.MemberID
where LoanDetails.OverdueStatus = 'late';

--Question 8:Fint the most frequently Loaned book(s)
SELECT BookDetails.BookName, COUNT(*) AS LoanCount
FROM BookDetails
JOIN BookCopies ON BookDetails.ISBN = BookCopies.ISBN
JOIN LoanDetails ON BookCopies.BookID = LoanDetails.BookID
GROUP BY BookDetails.BookName
ORDER BY LoanCount DESC;

--Question 9:Find the total number of books published by each publisher
SELECT Publisher, COUNT(*) AS TotalBooks
FROM BookDetails
GROUP BY Publisher;

--Question 10: List the books which are crrently under reserevation. 
--             Show the result in alphabetical orde of book name.
select BookDetails.BookName
from LoanDetails
join BookCopies on LoanDetails.BookID = BookCopies.BookID
join BookDetails on BookCopies.ISBN = BookDetails.ISBN
where LoanDetails.EndDate IS NULL
order by BookDetails.BookName asc;

select count(*) as BookCount from BookDetails BD 
join BookGenre BG on BD.ISBN = BG.ISBN
join GenreDetails GD on GD.Genre_ID = BG.Genre_ID
join Tag T on BD.Tag_ID = T.TagID
where (GD.Genre = 'Science Fiction') or (GD.Genre = 'Non-Fiction') and (TagColour = 'Green');