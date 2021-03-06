USE [ETPEASV55];
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
           WHERE   type = 'P'
                   AND name = 'CHK_SalesPriceListEAS_Update' )
   DROP PROCEDURE CHK_SalesPriceListEAS_Update;
GO
CREATE PROCEDURE [dbo].[CHK_SalesPriceListEAS_Update]
AS
BEGIN

    TRUNCATE TABLE [CHK_SalesPriceListEAS];

    SELECT a.Company,
           a.Division,
           WareHouse = Entitycode1,
           ItemNumber,
           UOM = ISNULL(UOM, ''),
           SalesPrice,
           ValidFrom,
           RowNum = ROW_NUMBER() OVER (PARTITION BY Entitycode1,
                                                    ItemNumber
                                       ORDER BY ValidFrom DESC,
                                                CreateDate DESC,
                                                CreateTime DESC
                                      )
    INTO #tmpSalesPriceList
    FROM [10.8.1.123].[ETPEASV55].dbo.SalesPriceList a (NOLOCK)
    WHERE ValidFrom < CONVERT(VARCHAR(10), GETDATE(), 112);

    DELETE FROM #tmpSalesPriceList
    WHERE RowNum <> 1;

    -- Lay ngay valid cua gia cuoi cung
    INSERT INTO [dbo].[CHK_SalesPriceListEAS]
    (
        [Company],
        [Division],
        [WareHouse],
        [ItemNumber],
        [UOM],
        [SalesPrice],
        [ValidFrom]
    )
    SELECT a.Company,
           a.Division,
           WareHouse,
           ItemNumber,
           UOM,
           SalesPrice,
           ValidFrom
    FROM #tmpSalesPriceList a
    WHERE EXISTS
    (
        SELECT TOP 1 1 FROM CHK_Connection WHERE ConnectionName = a.WareHouse
    );

    SELECT [Company] = '100',
           [Division] = '100',
           [WareHouse] = 'SAP',
           [ItemNumber] = [Article],
           [UOM] = [Sales unit],
           [ValidFrom] = NULL,
           [SalesPrice] = [Amount],
           RN = ROW_NUMBER() OVER (PARTITION BY [Article],
                                                [Sales unit]
                                   ORDER BY nolock.[Valid From] DESC
                                  )
    INTO #tmpSAPPrice
    FROM [dbo].[SAPPrice] nolock;

    DELETE FROM #tmpSAPPrice
    WHERE RN <> 1;

    INSERT INTO [dbo].[CHK_SalesPriceListEAS]
    (
        [Company],
        [Division],
        [WareHouse],
        [ItemNumber],
        [UOM],
        [SalesPrice],
        [ValidFrom]
    )
    SELECT [Company],
           [Division],
           [WareHouse],
           [ItemNumber],
           [UOM],
           [SalesPrice],
           [ValidFrom]
    FROM #tmpSAPPrice a;

    UPDATE a
    SET a.SapSalesPrice = b.SalesPrice
    FROM [CHK_SalesPriceListEAS] a
        JOIN [CHK_SalesPriceListEAS] b
            ON a.Company = b.Company
               AND a.Division = b.Division
               AND a.ItemNumber = b.ItemNumber
               AND a.UOM = b.UOM
    WHERE a.WareHouse <> 'SAP'
          AND b.WareHouse = 'SAP';

    UPDATE a
    SET a.SapSalesPrice = b.SalesPrice
    FROM [CHK_SalesPriceListEAS] a
        JOIN [CHK_SalesPriceListEAS] b
            ON a.Company = b.Company
               AND a.Division = b.Division
               AND a.ItemNumber = b.ItemNumber
               AND a.UOM = ''
    WHERE a.WareHouse <> 'SAP'
          AND b.WareHouse = 'SAP';

    UPDATE a
    SET IsPriceValid = (CASE
                            WHEN a.SapSalesPrice != SalesPrice
                                 AND SapSalesPrice IS NOT NULL THEN
                                0
                            ELSE
                                1
                        END
                       )
    FROM [CHK_SalesPriceListEAS] a;

    UPDATE a
    SET StockInStore = b.SOH
    FROM [CHK_SalesPriceListEAS] a
        JOIN
        (
            SELECT Company,
                   Warehouse,
                   ItemNumber,
                   SOH = SUM(BalanceApproved)
            FROM [10.8.1.123].[ETPEASV55].[dbo].ProductLocationBalance nolock
            WHERE Location = 'L001'
                  AND BalanceApproved <> 0
            GROUP BY Company,
                     Warehouse,
                     ItemNumber
        ) b
            ON a.Company = b.Company
               AND a.WareHouse = b.WareHouse
               AND a.ItemNumber = b.ItemNumber
    WHERE a.WareHouse <> 'SAP';

    UPDATE a
    SET StockAll = b.SOH
    FROM [CHK_SalesPriceListEAS] a
        JOIN
        (
            SELECT Company,
                   ItemNumber,
                   SOH = SUM(BalanceApproved)
            FROM [10.8.1.123].[ETPEASV55].[dbo].ProductLocationBalance a (NOLOCK)
            WHERE Location = 'L001'
                  AND BalanceApproved <> 0
                  AND EXISTS
            (
                SELECT TOP 1 1 FROM CHK_Connection WHERE ConnectionName = a.Warehouse
            )
            GROUP BY Company,
                     ItemNumber
        ) b
            ON a.Company = b.Company
               AND a.ItemNumber = b.ItemNumber
    WHERE a.WareHouse <> 'SAP';

    SELECT Company,
           Warehouse,
           ItemNumber,
           LocalAmount = SUM(LocalAmount)
    INTO #tmp
    FROM
    (
        SELECT Company,
               Warehouse,
               ItemNumber,
               LocalAmount
        FROM [10.8.1.123].[ETPEASV55].[dbo].CashOrderTrn nolock
        WHERE InvoiceYear = 2021
              AND InvoiceType = '31'
        UNION ALL
        SELECT Company,
               Warehouse,
               ReturnItemNumber,
               -1 * LocalAmount
        FROM [10.8.1.123].[ETPEASV55].[dbo].SalesReturnTrn nolock
        WHERE InvoiceYear = 2021
              AND InvoiceType = '31'
    ) a
    GROUP BY Company,
             Warehouse,
             ItemNumber;

    UPDATE a
    SET SalesIn2021 = b.LocalAmount
    FROM [CHK_SalesPriceListEAS] a
        JOIN #tmp b
            ON a.Company = b.Company
               AND a.WareHouse = b.Warehouse
               AND a.ItemNumber = b.ItemNumber
    WHERE a.WareHouse <> 'SAP';

    DROP TABLE #tmp;
    DROP TABLE #tmpSalesPriceList;
    DROP TABLE #tmpSAPPrice;

--SELECT *
--  FROM [CHK_SalesPriceListEAS] a
-- WHERE ISNULL(IsPriceValid,0)!=1
--   AND StockInStore IS NOT NULL
--   AND StockAll IS NOT NULL
--   AND StockAll IS NOT NULL
END;

/*
-- khong co gia tren SAP
	SELECT *
	  FROM [CHK_SalesPriceListEAS] a
	 WHERE IsPriceValid is null
	   AND (StockInStore IS NOT NULL
	   OR StockAll IS NOT NULL
	   OR SalesIn2021 IS NOT NULL)
	   AND ItemNumber LIKE '1%'
	 ORDER BY ItemNumber

	 --Sai gia
	 SELECT *
	  FROM [CHK_SalesPriceListEAS] a
	 WHERE IsPriceValid=0
	   AND (StockInStore IS NOT NULL
	   OR StockAll IS NOT NULL
	   OR SalesIn2021 IS NOT NULL)
	 ORDER BY Warehouse,ItemNumber
	 
	 --Sai gia
	 SELECT *
	  FROM [CHK_SalesPriceListEAS] a
	 WHERE IsPriceValid=0
	   AND (StockInStore IS NULL
	   AND StockAll IS NULL
	   AND SalesIn2021 IS NULL)
	 ORDER BY validfrom, Warehouse,ItemNumber
*/