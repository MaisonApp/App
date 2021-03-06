USE MaisonDW;
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'SAP_DT0_vbrp')
          AND type IN ( N'U' )
)
BEGIN
    CREATE TABLE [dbo].[SAP_DT0_vbrp]
    (
        [ID] [INT] IDENTITY(1, 1) NOT NULL,
        VBELN [NVARCHAR](2000) NULL,
        POSNR [NVARCHAR](2000) NULL,
        UEPOS [NVARCHAR](2000) NULL,
        FKIMG [NVARCHAR](2000) NULL,
        VRKME [NVARCHAR](2000) NULL,
        MEINS [NVARCHAR](2000) NULL,
        NTGEW [NVARCHAR](2000) NULL,
        BRGEW [NVARCHAR](2000) NULL,
        GEWEI [NVARCHAR](2000) NULL,
        VOLUM [NVARCHAR](2000) NULL,
        VOLEH [NVARCHAR](2000) NULL,
        PRSDT [NVARCHAR](2000) NULL,
        KURSK [NVARCHAR](2000) NULL,
        NETWR [NVARCHAR](2000) NULL,
        VGBEL [NVARCHAR](2000) NULL,
        VGPOS [NVARCHAR](2000) NULL,
        MATNR [NVARCHAR](2000) NULL,
        ARKTX [NVARCHAR](2000) NULL,
        CHARG [NVARCHAR](2000) NULL,
        MATKL [NVARCHAR](2000) NULL,
        PSTYV [NVARCHAR](2000) NULL,
        POSAR [NVARCHAR](2000) NULL,
        PRODH [NVARCHAR](2000) NULL,
        VSTEL [NVARCHAR](2000) NULL,
        SPART [NVARCHAR](2000) NULL,
        WERKS [NVARCHAR](2000) NULL,
        TAXM1 [NVARCHAR](2000) NULL,
        SKFBP [NVARCHAR](2000) NULL,
        KONDM [NVARCHAR](2000) NULL,
        KTGRM [NVARCHAR](2000) NULL,
        VKBUR [NVARCHAR](2000) NULL,
        SPARA [NVARCHAR](2000) NULL,
        SHKZG [NVARCHAR](2000) NULL,
        ERNAM [NVARCHAR](2000) NULL,
        ERDAT [NVARCHAR](2000) NULL,
        ERZET [NVARCHAR](2000) NULL,
        LGORT [NVARCHAR](2000) NULL,
        STAFO [NVARCHAR](2000) NULL,
        WAVWR [NVARCHAR](2000) NULL,
        KZWI1 [NVARCHAR](2000) NULL,
        KZWI2 [NVARCHAR](2000) NULL,
        KZWI3 [NVARCHAR](2000) NULL,
        KZWI4 [NVARCHAR](2000) NULL,
        KZWI5 [NVARCHAR](2000) NULL,
        KZWI6 [NVARCHAR](2000) NULL,
        PRCTR [NVARCHAR](2000) NULL,
        KVGR1 [NVARCHAR](2000) NULL,
        KVGR2 [NVARCHAR](2000) NULL,
        MVGR1 [NVARCHAR](2000) NULL,
        MVGR2 [NVARCHAR](2000) NULL,
        MATWA [NVARCHAR](2000) NULL,
        BONBA [NVARCHAR](2000) NULL,
        KOSTL [NVARCHAR](2000) NULL,
        PAOBJNR [NVARCHAR](2000) NULL,
        CMPRE [NVARCHAR](2000) NULL,
        BZIRK_AUFT [NVARCHAR](2000) NULL,
        KONDA_AUFT [NVARCHAR](2000) NULL,
        VKORG_AUFT [NVARCHAR](2000) NULL,
        VTWEG_AUFT [NVARCHAR](2000) NULL,
        AUTYP [NVARCHAR](2000) NULL,
        KNUMA_AG [NVARCHAR](2000) NULL,
        MWSBP [NVARCHAR](2000) NULL,
        AUGRU_AUFT [NVARCHAR](2000) NULL,
        BRTWR [NVARCHAR](2000) NULL,
        KURSK_DAT [NVARCHAR](2000) NULL,
        MSR_REFUND_CODE [NVARCHAR](2000) NULL,
        MSR_RET_REASON [NVARCHAR](2000) NULL,
        VGTYP [NVARCHAR](2000) NULL,
        AUBEL [NVARCHAR](2000) NULL,
        AUPOS [NVARCHAR](2000) NULL,
        PRSFD [NVARCHAR](2000) NULL,
        SKTOF [NVARCHAR](2000) NULL,
        VKGRP [NVARCHAR](2000) NULL
            CONSTRAINT [PK_SAP_DT0_vbrp]
            PRIMARY KEY CLUSTERED ([ID] ASC)
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON
                 ) ON [PRIMARY]
    ) ON [PRIMARY];
END;

GO
SET ANSI_PADDING OFF;
GO
