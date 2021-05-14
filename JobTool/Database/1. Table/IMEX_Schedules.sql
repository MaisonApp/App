IF NOT EXISTS (SELECT
    1
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'IMEX_Schedules')
  AND TYPE IN (N'U'))
BEGIN
  CREATE TABLE [dbo].[IMEX_Schedules] (
    [ID] int IDENTITY (1,
    1) NOT NULL,
    [Name] nvarchar(255),
    [RecurringType] nvarchar(5) NOT NULL, -- Định kỳ (D)aily (W)eekly (M)onthly
    [RecursEvery] int NOT NULL, -- Định kỳ bao lâu 1 lần
    [DayOfMonth] int NULL, -- Ngày trong tháng
    [DayOfWeek] nvarchar(7) NULL, -- Ngày trong tuần định dạng 0000000, VD: thứ 2 và 4 => 0101000
    [Occurs] nvarchar(max) NULL, -- Xảy ra (O)nce hay (E)very
    [OccursType] nvarchar(5) NULL, -- Xảy ra theo (H)ours hay (M)inutes
    [OccursEvery] int NULL, -- Xảy ra bao lâu 1 lần minute
    [StartingAt] time(7) NOT NULL, -- Bắt đầu xảy ra
    [EndingAt] time(7) NULL, --Kết thúc xảy ra default 23:59:59
    [StartDate] date NOT NULL, -- Bắt đầu định kỳ
    [EndDate] date NULL -- Kết thúc định kỳ
    CONSTRAINT [PK_IMEX_Schedules] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    IGNORE_DUP_KEY = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
  ) ON [PRIMARY];

END;

IF EXISTS (SELECT
    1
  FROM sys.default_constraints
  WHERE name = 'DF_EndingAt')
BEGIN
  ALTER TABLE dbo.IMEX_Schedules
  DROP CONSTRAINT DF_EndingAt;
END
ALTER TABLE dbo.IMEX_Schedules ADD CONSTRAINT DF_EndingAt DEFAULT '23:59:59'
FOR [EndingAt]