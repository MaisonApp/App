IF NOT EXISTS (SELECT
    1
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'IMEX_JobSchedules')
  AND type IN (N'U'))
BEGIN
  CREATE TABLE [dbo].[IMEX_JobSchedules] (
    [ID] int IDENTITY (1, 1) NOT NULL,
    [Job] int not null,
    [Schedule] int NOT NULL, 
    CONSTRAINT [PK_IMEX_JobSchedules]
    PRIMARY KEY CLUSTERED (
    [ID] ASC
    )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON
    ) ON [PRIMARY]
  ) ON [PRIMARY];
END;

GO
SET ANSI_PADDING OFF;
GO