--PROCEDURE TEMPLATE
CREATE PROCEDURE PROC1 
AS
SELECT * FROM BALANCE;


-- FOR AOM 

-- GET PACKAGE NAME BY MSISDN
CREATE PROCEDURE GET_PACKAGE_NAME_BY_MSISDN
AS
SELECT PACKAGE_NAME  
FROM PACKAGE 
WHERE PACKAGE_ID = (
    SELECT PACKAGE_ID 
    FROM BALANCE 
    WHERE CUST_ID = (
        SELECT CUST_ID 
        FROM CUSTOMER 
        WHERE MSISDN = ?
    )
);

-- GET CUSTOMER INFO BY MSISDN
CREATE PROCEDURE  GET_CUSTOMER_INFO_BY_MSISDN 
AS
SELECT CUST_ID, MSISDN, NAME, SURNAME, EMAIL, SDATE, TC_NO
FROM CUSTOMER
WHERE MSISDN = ?;


-- GET PACKAGE NAME BY PACKAGE ID
CREATE PROCEDURE GET_PACKAGE_NAME_BY_PACKAGE_ID
AS
SELECT PACKAGE_NAME 
FROM PACKAGE
WHERE PACKAGE_ID = ?;


-- GET PACKAGE ID BY PACKAGE NAME
CREATE PROCEDURE GET_PACKAGE_ID_BY_PACKAGE_NAME
AS
SELECT PACKAGE_ID 
FROM PACKAGE
WHERE PACKAGE_NAME = ?;


-- GET MAX CUSTOMER ID 
CREATE PROCEDURE GET_MAX_CUSTOMER_ID 
AS
SELECT MAX(CUST_ID) AS MAX_CUST_ID 
FROM CUSTOMER;


-- GET MAX BALANCE ID 
CREATE PROCEDURE GET_MAX_BALANCE_ID 
AS
SELECT MAX(BALANCE_ID) AS MAX_BALANCE_ID 
FROM BALANCE;


-- INSERT BALANCE TO CUSTOMER
CREATE PROCEDURE INSERT_BALANCE_TO_CUSTOMER 
AS 
INSERT INTO BALANCE (BALANCE_ID, CUST_ID, PACKAGE_ID, BAL_LVL_MINUTES, BAL_LVL_SMS, BAL_LVL_DATA, SDATE, EDATE)
VALUES (?, ?, ?, ?, ?, ?, ?, ?);

-- INSERT NEW CUSTOMER
CREATE PROCEDURE INSERT_NEW_CUSTOMER
AS
INSERT INTO CUSTOMER (CUST_ID, NAME, SURNAME, MSISDN, EMAIL, PASSWORD, SDATE, TC_NO) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?);

-- UPDATE CUSTOMER PASSWORD
CREATE PROCEDURE UPDATE_CUSTOMER_PASSWORD 
AS
UPDATE CUSTOMER
SET PASSWORD = ?
WHERE EMAIL = ? AND TC_NO = ?;

-- CHECK IF CUSTOMER EXISTS
CREATE PROCEDURE CHECK_CUSTOMER_EXISTS_BY_MAIL_AND_TCNO 
AS
SELECT COUNT(*)
FROM CUSTOMER
WHERE EMAIL = ? AND TC_NO = ?;

-- INSERT NOTIFICATION LOG
CREATE PROCEDURE INSERT_NOTIFICATION_LOG 
AS
INSERT INTO NOTIFICATION_LOGS (NOTIFICATION_ID, NOTIFICATION_TYPE, NOTIFICATION_TIME, CUSTOMER_ID)
VALUES (?, ?, ?, ?);

-- GET MAX NOTIFICATION ID 
CREATE PROCEDURE GET_MAX_NOTIFICATION_ID 
AS
SELECT MAX(NOTIFICATION_ID) AS MAX_NOTIFICATION_ID 
FROM NOTIFICATION_LOGS;

-- GET CUSTOMER ID BY MAIL AND TCNO
CREATE PROCEDURE GET_CUSTOMER_ID_BY_MAIL_AND_TCNO 
AS
SELECT CUST_ID
FROM CUSTOMER
WHERE EMAIL = ? AND TC_NO = ?;

-- GET REMAINING CUSTOMER BALANCE BY MSISDN
CREATE PROCEDURE GET_REMAINING_CUSTOMER_BALANCE_BY_MSISDN 
AS 
SELECT 
    c.MSISDN,
    b.BAL_LVL_DATA, 
    b.BAL_LVL_SMS, 
    b.BAL_LVL_MINUTES, 
    b.SDATE, 
    b.EDATE
FROM BALANCE b
JOIN CUSTOMER c ON b.CUST_ID = c.CUST_ID
WHERE c.MSISDN = ?;

-- GET CUSTOMER PASSWORD BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_PASSWORD_BY_MSISDN 
AS 
SELECT PASSWORD 
FROM CUSTOMER 
WHERE MSISDN = ?;



-- FOR CHF

-- GET PACKAGE NAME BY MSISDN
CREATE PROCEDURE GET_PACKAGE_NAME_BY_MSISDN
AS
SELECT PACKAGE_NAME  
FROM PACKAGE 
WHERE PACKAGE_ID = (
    SELECT PACKAGE_ID 
    FROM BALANCE 
    WHERE CUST_ID = (
        SELECT CUST_ID 
        FROM CUSTOMER 
        WHERE MSISDN = ?
    )
);

-- GET CUSTOMER ID BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_ID_BY_MSISDN
AS
SELECT CUST_ID 
FROM CUSTOMER 
WHERE MSISDN = ?;

-- GET AMOUNT MINUTES BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_PACKAGE_MINUTES_BY_MSISDN 
AS 
SELECT AMOUNT_MINUTES 
FROM PACKAGE
WHERE PACKAGE_ID = (
    SELECT PACKAGE_ID 
    FROM BALANCE 
    WHERE CUST_ID = (
        SELECT CUST_ID 
        FROM CUSTOMER 
        WHERE MSISDN = ?
    )
);

-- UPDATE AMOUNT MINUTES BY MSISDN
CREATE PROCEDURE UPDATE_CUSTOMER_AMOUNT_MINUTES_BY_MSISDN
AS
UPDATE BALANCE 
SET BAL_LVL_MINUTES = ?
WHERE CUST_ID = (
    SELECT CUST_ID 
    FROM CUSTOMER 
    WHERE MSISDN = ?
);

-- GET AMOUNT SMS BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_PACKAGE_SMS_BY_MSISDN 
AS 
SELECT AMOUNT_SMS
FROM PACKAGE
WHERE PACKAGE_ID = (
    SELECT PACKAGE_ID 
    FROM BALANCE 
    WHERE CUST_ID = (
        SELECT CUST_ID 
        FROM CUSTOMER 
        WHERE MSISDN = ?
    )
);

-- UPDATE AMOUNT SMS BY MSISDN
CREATE PROCEDURE UPDATE_CUSTOMER_AMOUNT_SMS_BY_MSISDN
AS
UPDATE BALANCE 
SET BAL_LVL_SMS = ?
WHERE CUST_ID = (
    SELECT CUST_ID 
    FROM CUSTOMER 
    WHERE MSISDN = ?
);

-- GET AMOUNT DATA BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_PACKAGE_DATA_BY_MSISDN 
AS 
SELECT AMOUNT_DATA
FROM PACKAGE
WHERE PACKAGE_ID = (
    SELECT PACKAGE_ID 
    FROM BALANCE 
    WHERE CUST_ID = (
        SELECT CUST_ID 
        FROM CUSTOMER 
        WHERE MSISDN = ?
    )
);

-- UPDATE AMOUNT DATA BY MSISDN
CREATE PROCEDURE UPDATE_CUSTOMER_AMOUNT_DATA_BY_MSISDN
AS
UPDATE BALANCE 
SET BAL_LVL_DATA = ?
WHERE CUST_ID = (
    SELECT CUST_ID 
    FROM CUSTOMER 
    WHERE MSISDN = ?
);

-- GET REMAINING MINUTES BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_REMAINING_MINUTES_BY_MSISDN
AS
SELECT BAL_LVL_MINUTES
FROM BALANCE
WHERE CUST_ID = (
    SELECT CUST_ID 
    FROM CUSTOMER 
    WHERE MSISDN = ?
);

-- GET REMAINING SMS BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_REMAINING_SMS_BY_MSISDN
AS
SELECT BAL_LVL_SMS
FROM BALANCE
WHERE CUST_ID = (
    SELECT CUST_ID 
    FROM CUSTOMER 
    WHERE MSISDN = ?
);

-- GET REMAINING DATA BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_REMAINING_DATA_BY_MSISDN
AS
SELECT BAL_LVL_DATA
FROM BALANCE
WHERE CUST_ID = (
    SELECT CUST_ID 
    FROM CUSTOMER 
    WHERE MSISDN = ?
);

-- GET PACKAGE INFO BY MSISDN
CREATE PROCEDURE GET_PACKAGE_INFO_BY_MSISDN
AS
SELECT *  
FROM PACKAGE 
WHERE PACKAGE_ID = (
    SELECT PACKAGE_ID 
    FROM BALANCE 
    WHERE CUST_ID = (
        SELECT CUST_ID 
        FROM CUSTOMER 
        WHERE MSISDN = ?
    )
);

-- GET CUSTOMER EMAIL BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_EMAIL_BY_MSISDN
AS
SELECT EMAIL 
FROM CUSTOMER 
WHERE MSISDN = ?;

-- GET CUSTOMER NAME BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_NAME_BY_MSISDN
AS
SELECT NAME 
FROM CUSTOMER 
WHERE MSISDN = ?;

-- GET CUSTOMER SURNAME BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_SURNAME_BY_MSISDN
AS
SELECT SURNAME 
FROM CUSTOMER 
WHERE MSISDN = ?;

-- GET CUSTOMER INFO & PACKAGE BY MSISDN
CREATE PROCEDURE GET_CUSTOMER_INFO_PACKAGE_BY_MSISDN 
AS
SELECT 
    C.NAME,
    C.SURNAME,
    C.EMAIL,
    P.PACKAGE_ID 
FROM 
    CUSTOMER C
JOIN 
    BALANCE B ON C.CUST_ID = B.CUST_ID
JOIN 
    PACKAGE P ON B.PACKAGE_ID = P.PACKAGE_ID
WHERE C.MSISDN = ?;









