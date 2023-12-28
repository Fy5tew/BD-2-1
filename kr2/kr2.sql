-- Вариант №2


USE EXAM;
GO


-- Задание №1
DROP PROCEDURE N_EXPENSIVE;
GO

CREATE PROCEDURE N_EXPENSIVE
	@n int
AS BEGIN
	SELECT TOP (@n) PERCENT *
	FROM PRODUCTS
	ORDER BY PRICE DESC;
END;
GO

EXEC N_EXPENSIVE @n=20;


-- Задание №2
DROP FUNCTION GET_CUSTOMER_ORDERS_PRICE;
GO

CREATE FUNCTION GET_CUSTOMER_ORDERS_PRICE(
	@CustNum int
)
RETURNS decimal(9, 2)
AS BEGIN
	DECLARE @Amount decimal(9, 2) = (
		SELECT ISNULL(SUM(AMOUNT), -1)
		FROM ORDERS 
		WHERE CUST = @CustNum
	);
	RETURN @Amount;
END;
GO

DECLARE @Amount decimal(9, 2);
SET @Amount = dbo.GET_CUSTOMER_ORDERS_PRICE(2103);
PRINT 'Amount of customer 2103 orders: ' + cast(@Amount AS varchar(10));
SET @Amount = dbo.GET_CUSTOMER_ORDERS_PRICE(1);
PRINT 'Amount of customer 1 orders: ' + cast(@Amount AS varchar(10));
GO
