-- Challenge 1:
SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
authors.au_fname AS first_name, titles.title, publishers.pub_name AS publishers
FROM authors
LEFT JOIN titleauthor
ON authors.au_id=titleauthor.au_id
LEFT JOIN titles
ON titleauthor.title_id=titles.title_id
LEFT JOIN publishers
ON publishers.pub_id=titles.pub_id;

SELECT author_id, first_name, last_name, title, publishers.pub_name AS publishers
FROM (
	SELECT titles.title AS title, author_id, last_name, first_name, titles.pub_id
	FROM (
		SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
		authors.au_fname AS first_name, titleauthor.title_id
		FROM authors
		INNER JOIN titleauthor
		ON authors.au_id=titleauthor.au_id
	) AS author_info
	INNER JOIN titles
	ON author_info.title_id=titles.title_id
) AS title_info
INNER JOIN publishers
ON publishers.pub_id=title_info.pub_id;

-- Challenge 2:
SELECT author_id, first_name, last_name, publishers, COUNT (publishers)
FROM(
	SELECT author_id, first_name, last_name, title, publishers.pub_name AS publishers
	FROM (
		SELECT titles.title AS title, author_id, last_name, first_name, titles.pub_id
		FROM (
			SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
			authors.au_fname AS first_name, titleauthor.title_id
			FROM authors
			INNER JOIN titleauthor
			ON authors.au_id=titleauthor.au_id
		) AS author_info
		INNER JOIN titles
		ON author_info.title_id=titles.title_id
	) AS title_info
	INNER JOIN publishers
	ON publishers.pub_id=title_info.pub_id
) AS publishers_info
GROUP BY author_id, first_name, last_name, publishers
ORDER BY first_name;

-- Challenge 3:

SELECT author_id, first_name, last_name, SUM (qty) AS total
FROM (
	SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
		authors.au_fname AS first_name, titleauthor.title_id AS title_id
	FROM authors
	INNER JOIN titleauthor
	ON authors.au_id=titleauthor.au_id
) AS author_info
INNER JOIN sales
ON author_info.title_id=sales.title_id
GROUP BY author_id, first_name, last_name
ORDER BY total DESC
LIMIT 3;

-- Challenge 4:

SELECT author_id, first_name, last_name,  COALESCE(SUM (qty), 0) AS total
FROM (
	SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
			authors.au_fname AS first_name, titleauthor.title_id AS title_id
	FROM authors
	LEFT JOIN titleauthor
	ON authors.au_id=titleauthor.au_id
) AS author_info
LEFT JOIN sales
ON author_info.title_id=sales.title_id
GROUP BY author_id, first_name, last_name
ORDER BY total DESC;

-- Challenge 5:
-- step 1:

SELECT author_id, title_info.title_id, title_info.royalty, 
(title_info.price::FLOAT * sales.qty::FLOAT * title_info.royalty::FLOAT / 100 * royaltyper::FLOAT / 100) 
AS sales_royalty
FROM (
	SELECT author_id, titles.title_id, titles.royalty, titles.price, 
	author_info.royaltyper AS royaltyper
	FROM (
		SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
			authors.au_fname AS first_name, titleauthor.title_id, titleauthor.royaltyper
		FROM authors
		INNER JOIN titleauthor
		ON authors.au_id=titleauthor.au_id
		) AS author_info
	INNER JOIN titles
	ON author_info.title_id=titles.title_id
) AS title_info
INNER JOIN sales
ON title_info.title_id=sales.title_id
ORDER BY author_id;

-- step 2:

SELECT author_id, title_id, SUM (sales_royalty)
FROM (
	SELECT author_id, title_info.title_id AS title_id, title_info.royalty, 
	(title_info.price::FLOAT * sales.qty::FLOAT * title_info.royalty::FLOAT / 100 * royaltyper::FLOAT / 100) 
	AS sales_royalty
	FROM (
		SELECT author_id, titles.title_id, titles.royalty, titles.price, 
		author_info.royaltyper AS royaltyper
		FROM (
			SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
				authors.au_fname AS first_name, titleauthor.title_id, titleauthor.royaltyper
			FROM authors
			INNER JOIN titleauthor
			ON authors.au_id=titleauthor.au_id
			) AS author_info
		INNER JOIN titles
		ON author_info.title_id=titles.title_id
	) AS title_info
	INNER JOIN sales
	ON title_info.title_id=sales.title_id
) AS royalty
GROUP BY author_id, title_id
ORDER BY SUM (sales_royalty) DESC;

-- step 3:

SELECT author_id, title_id, SUM (sales_royalty) AS total_royalty, advance, 
	(SUM (sales_royalty)+advance:: FLOAT) AS profits
FROM (
	SELECT author_id, title_info.title_id AS title_id, title_info.royalty, 
	(title_info.price::FLOAT * sales.qty::FLOAT * title_info.royalty::FLOAT / 100 * royaltyper::FLOAT / 100) 
	AS sales_royalty, advance
	FROM (
		SELECT author_id, titles.title_id, titles.royalty, titles.price, 
		author_info.royaltyper AS royaltyper, titles.advance AS advance
		FROM (
			SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
				authors.au_fname AS first_name, titleauthor.title_id, titleauthor.royaltyper
			FROM authors
			INNER JOIN titleauthor
			ON authors.au_id=titleauthor.au_id
			) AS author_info
		INNER JOIN titles
		ON author_info.title_id=titles.title_id
	) AS title_info
	INNER JOIN sales
	ON title_info.title_id=sales.title_id
) AS royalty
GROUP BY author_id, title_id, advance
ORDER BY profits DESC
LIMIT 3;

-- Challenge 6:
-- usando temp tables:

SELECT authors.au_id AS author_id, authors.au_lname AS last_name, 
authors.au_fname AS first_name, titleauthor.title_id, titleauthor.royaltyper
INTO TEMP TABLE author_info
FROM authors
INNER JOIN titleauthor
ON authors.au_id=titleauthor.au_id

SELECT author_id, titles.title_id, titles.royalty, titles.price, 
author_info.royaltyper AS royaltyper, titles.advance AS advance
INTO TEMP TABLE title_info
FROM author_info
INNER JOIN titles
ON author_info.title_id=titles.title_id

SELECT author_id, title_info.title_id AS title_id, title_info.royalty, 
(title_info.price::FLOAT * sales.qty::FLOAT * title_info.royalty::FLOAT / 100 * royaltyper::FLOAT / 100) 
AS sales_royalty, advance
INTO TEMP TABLE royalty
FROM title_info
INNER JOIN sales
ON title_info.title_id=sales.title_id

SELECT author_id, title_id, SUM (sales_royalty) AS total_royalty, advance, 
(SUM (sales_royalty)+advance:: FLOAT) AS profits
FROM royalty
GROUP BY author_id, title_id, advance
ORDER BY profits DESC
LIMIT 3;
	
-- Challenge 7:

SELECT author_id, (SUM (sales_royalty)+advance:: FLOAT) AS profits
INTO TABLE most_profiting_authors
FROM royalty
GROUP BY author_id, title_id, advance
ORDER BY profits DESC
LIMIT 3;

SELECT *
FROM most_profiting_authors

SELECT *
FROM titleauthor