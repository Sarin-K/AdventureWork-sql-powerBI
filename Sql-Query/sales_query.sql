-- Create total sales table used for analysis
SELECT [ProductKey]
      ,[OrderDateKey]
      -- ,[DueDateKey]
      ,[ShipDateKey]
      ,[CustomerKey]
      -- ,[PromotionKey]
      -- ,[CurrencyKey]
      ,[SalesTerritoryKey]
      -- ,[SalesOrderNumber]
      -- ,[SalesOrderLineNumber]
      -- ,[RevisionNumber]
      ,[OrderQuantity]
      ,[UnitPrice]
      -- ,[ExtendedAmount]
      -- ,[UnitPriceDiscountPct]
      -- ,[DiscountAmount]
      -- ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      -- ,[TaxAmt]
      -- ,[Freight]
      -- ,[CarrierTrackingNumber]
      -- ,[CustomerPONumber]
      -- ,[OrderDate]
      -- ,[DueDate]
      -- ,[ShipDate]
  INTO analysis_internet_sales
  FROM [AdventureWorksDW2022].[dbo].[FactInternetSales] in_sales
  LEFT JOIN [AdventureWorksDW2022].[dbo].[DimDate] date
  ON in_sales.OrderDateKey = date.DateKey
  WHERE date.CalendarYear >= YEAR(GETDATE()) - 5;

  -- Add channel column
  ALTER TABLE analysis_internet_sales
  ADD Channel VARCHAR(30);

  -- Add "Channel" tag "Reseller"
  UPDATE analysis_internet_sales
  SET Channel = 'Online';

  SELECT TOP(1000) *
  FROM analysis_internet_sales
  
  -- Now the same step is apply for reseller sales
 
 SELECT [ProductKey]
      ,[OrderDateKey]
      -- ,[DueDateKey]
      ,[ShipDateKey]
      ,[ResellerKey]
      ,[EmployeeKey]
      -- ,[PromotionKey]
      -- ,[CurrencyKey]
      ,[SalesTerritoryKey]
      -- ,[SalesOrderNumber]
      -- ,[SalesOrderLineNumber]
      -- ,[RevisionNumber]
      ,[OrderQuantity]
      ,[UnitPrice]
      -- ,[ExtendedAmount]
      -- ,[UnitPriceDiscountPct]
      -- ,[DiscountAmount]
      -- ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      -- ,[TaxAmt]
      -- ,[Freight]
      -- ,[CarrierTrackingNumber]
      -- ,[CustomerPONumber]
      -- ,[OrderDate]
      -- ,[DueDate]
      -- ,[ShipDate]
  INTO analysis_reseller_sales
  FROM [AdventureWorksDW2022].[dbo].[FactResellerSales] AS rs
  LEFT JOIN [AdventureWorksDW2022].[dbo].[DimDate] date
  ON rs.OrderDateKey = date.DateKey
  WHERE date.CalendarYear >= YEAR(GETDATE()) - 5;

    -- Add channel column
  ALTER TABLE analysis_reseller_sales
  ADD Channel VARCHAR(30);

  -- Add "Channel" tag "Reseller"
  UPDATE analysis_reseller_sales
  SET Channel = 'Reseller';
 
-- Now transform reseller and online sales are obtained.
