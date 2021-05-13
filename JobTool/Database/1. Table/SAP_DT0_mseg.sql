USE MaisonDW;
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'SAP_DT0_mseg')
          AND type IN ( N'U' )
)
BEGIN
    CREATE TABLE [dbo].[SAP_DT0_mseg]
    (
        [ID] [INT] IDENTITY(1, 1) NOT NULL,
        MBLNR [NVARCHAR](2000) NULL,
        MJAHR [NVARCHAR](2000) NULL,
        ZEILE [NVARCHAR](2000) NULL,
        LINE_ID [NVARCHAR](2000) NULL,
        PARENT_ID [NVARCHAR](2000) NULL,
        LINE_DEPTH [NVARCHAR](2000) NULL,
        BWART [NVARCHAR](2000) NULL,
        MATNR [NVARCHAR](2000) NULL,
        WERKS [NVARCHAR](2000) NULL,
        LGORT [NVARCHAR](2000) NULL,
        CHARG [NVARCHAR](2000) NULL,
        SHKZG [NVARCHAR](2000) NULL,
        WAERS [NVARCHAR](2000) NULL,
        DMBTR [NVARCHAR](2000) NULL,
        MENGE [NVARCHAR](2000) NULL,
        MEINS [NVARCHAR](2000) NULL,
        ERFMG [NVARCHAR](2000) NULL,
        ERFME [NVARCHAR](2000) NULL,
        EBELN [NVARCHAR](2000) NULL,
        KOKRS [NVARCHAR](2000) NULL,
        GJAHR [NVARCHAR](2000) NULL,
        BUKRS [NVARCHAR](2000) NULL,
        BELNR [NVARCHAR](2000) NULL,
        KZSTR [NVARCHAR](2000) NULL,
        PRCTR [NVARCHAR](2000) NULL,
        SAKTO [NVARCHAR](2000) NULL,
        EXBWR [NVARCHAR](2000) NULL,
        VFDAT [NVARCHAR](2000) NULL,
        MATBF [NVARCHAR](2000) NULL,
        URZEI [NVARCHAR](2000) NULL,
        HSDAT [NVARCHAR](2000) NULL,
        KUNNR [NVARCHAR](2000) NULL,
        SJAHR [NVARCHAR](2000) NULL,
        SMBLN [NVARCHAR](2000) NULL,
        SMBLP [NVARCHAR](2000) NULL,
        LFBNR [NVARCHAR](2000) NULL,
        XAUTO [NVARCHAR](2000) NULL
            CONSTRAINT [PK_SAP_DT0_mseg]
            PRIMARY KEY CLUSTERED ([ID] ASC)
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON
                 ) ON [PRIMARY]
    ) ON [PRIMARY];
END;

GO
SET ANSI_PADDING OFF;
GO
