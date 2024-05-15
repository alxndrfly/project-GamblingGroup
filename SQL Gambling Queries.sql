USE sportsbetting;
/* Question 1 */
select Title, FirstName, LastName, DateOfBirth from customer;

/* Question 2 */
select CustomerGroup, count(CustId) from customer group by CustomerGroup;

/* Question 3 */
select c.*, a.CurrencyCode from customer c left join account a on c.CustId = a.CustId;

/* Question 4 */
select Product, BetDate, sum(Bet_Amt) as TotalBet from betting  group by Product, BetDate ORDER BY Product, BetDate;

/* Question 5 */
select Product, BetDate, sum(Bet_Amt) from betting where STR_TO_DATE(BetDate, '%d/%m/%Y') >= '2012-11-01' && Product = 'Sportsbook' group by Product, BetDate ORDER By STR_TO_DATE(BetDate, '%d/%m/%Y');

/* Question 6 */
select b.Product, a.CurrencyCode, c.CustomerGroup, sum(b.Bet_Amt) as TotalBet from betting b left join account a on b.AccountNo = a.AccountNo left join customer c on c.CustId = a.CustId where STR_TO_DATE(BetDate, '%d/%m/%Y') >= '2012-11-01' group by Product, CurrencyCode, CustomerGroup
ORDER BY Product, CurrencyCode;

/* Question 7 */
select Title, FirstName, LastName, sum(Bet_Amt) as BetTotalNovember from customer c left join account a on c.CustId = a.CustId left join betting b on b.AccountNo = a.AccountNo 
where STR_TO_DATE(BetDate, '%d/%m/%Y') >= '2012-11-01' && STR_TO_DATE(BetDate, '%d/%m/%Y') < '2012-12-01' group by Title, FirstName, LastName;

/* Question 8 */
/* number of products per player */
select a.AccountNo, count(distinct Product) as nºProducts from account a left join betting b on a.AccountNo = b.AccountNo group by AccountNo order by nºProducts desc;

/* players who play both Sportsbook and Vegas */
SELECT Title, FirstName, LastName FROM customer INNER JOIN account ON customer.CustId = account.CustId INNER JOIN betting ON account.AccountNo = betting.AccountNo WHERE betting.Product IN ('Sportsbook', 'Vegas') 
GROUP BY Title, FirstName, LastName HAVING COUNT(DISTINCT product) = 2 ORDER BY Title, FirstName, LastName;

/* Question 9 */
/* players who only play at sportsbook with a bet ammount higher than 0*/
Select c.Title, c.FirstName, c.LastName, sum(b.Bet_Amt) as BetTotal from customer c join account a on c.CustId = a.CustId join betting b on b.AccountNo = a.AccountNo where a.AccountNo in 
(SELECT DISTINCT AccountNo FROM betting  WHERE Product = 'Sportsbook' AND AccountNo NOT IN ( SELECT AccountNo FROM betting WHERE Product <> 'Sportsbook' and Bet_Amt > 0)) 
GROUP BY c.Title, c.FirstName, c.LastName
ORDER BY c.LastName, c.FirstName;

/* sum of bets for players who play at Vegas and Sportsbook*/
SELECT Title, FirstName, LastName, sum(betting.Bet_Amt) as SumBetsVegasAndSportsbook FROM customer INNER JOIN account ON customer.CustId = account.CustId INNER JOIN betting ON account.AccountNo = betting.AccountNo WHERE betting.Product IN ('Sportsbook', 'Vegas') 
GROUP BY Title, FirstName, LastName HAVING COUNT(DISTINCT product) = 2 ORDER BY Title, FirstName, LastName;

/* Question 10 */
/* sum of bets for each product for each customer */
SELECT Title, FirstName, LastName, Product, sum(betting.Bet_Amt) FROM customer INNER JOIN account ON customer.CustId = account.CustId INNER JOIN betting ON account.AccountNo = betting.AccountNo 
group by Title, FirstName, LastName, Product order by FirstName;

/* Product with the highest bet total per each customer */
SELECT c.Title, c.FirstName, c.LastName, b.Product, b.BetTotal
FROM customer c 
INNER JOIN account a ON c.CustId = a.CustId 
INNER JOIN (SELECT a.CustId, b.Product, SUM(b.Bet_Amt) AS BetTotal FROM account a INNER JOIN betting b ON a.AccountNo = b.AccountNo GROUP BY a.CustId, b.Product) b ON c.CustId = b.CustId
INNER JOIN (SELECT CustId, MAX(BetTotal) AS MaxBetTotal FROM (SELECT a.CustId, b.Product, SUM(b.Bet_Amt) AS BetTotal FROM account a 
INNER JOIN betting b ON a.AccountNo = b.AccountNo GROUP BY a.CustId, b.Product) sub GROUP BY CustId) max_bet ON b.CustId = max_bet.CustId AND b.BetTotal = max_bet.MaxBetTotal
ORDER BY c.FirstName;

/* Question 11 */
use school_students;
select student_id, GPA from student order by GPA desc limit 5;

/* Question 12 */
select school_name, COUNT(student_id) as nºOfStudents from school sc left join student st on sc.school_id = st.school_id group by school_name order by nºOfStudents desc;

/* Question 13 */
select school_name, student_id, GPA from school sc left join student st on sc.school_id = st.school_id group by school_name, student_id, GPA order by school_name, GPA desc ;

SELECT school_name, student_id, GPA FROM ( SELECT school_name, student_id, GPA, ROW_NUMBER() OVER (PARTITION BY sc.school_id ORDER BY GPA DESC) AS row_num 
FROM school sc LEFT JOIN student st ON sc.school_id = st.school_id ) AS ranked_data
WHERE row_num <= 3;