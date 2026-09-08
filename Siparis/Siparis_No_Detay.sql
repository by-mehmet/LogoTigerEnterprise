/*
=========================================================
LOGO TIGER ENTERPRISE
Rapor       : Sipariş Numarası Detay Sorgusu
Firma       : 001
Dönem       : 01

Açıklama:
Sipariş numarasına göre;
- Sipariş bilgileri
- Cari bilgileri
- Ürünler
- Sipariş miktarı
- Sevk edilen miktar
- Kalan miktar
bilgilerini getirir.
=========================================================
*/

DECLARE @SiparisNo VARCHAR(50) = 'SIPARIS_NUMARASI';

SELECT
    ORF.LOGICALREF                 AS SIPARIS_REF,
    ORF.FICHENO                    AS SIPARIS_NO,
    ORF.DATE_                      AS SIPARIS_TARIHI,
    ORF.DOCODE                     AS BELGE_NO,
    ORF.SPECODE                    AS SIPARIS_OZEL_KODU,

    /* CARİ */
    CL.LOGICALREF                  AS CARI_REF,
    CL.CODE                        AS CARI_KODU,
    CL.DEFINITION_                 AS CARI_UNVANI,
    CL.TAXOFFICE                   AS VERGI_DAIRESI,
    CL.TAXNR                       AS VERGI_NO,
    CL.TCKNO                       AS TC_KIMLIK_NO,
    CL.TELNRS1                     AS TELEFON,
    CL.EMAILADDR                   AS EMAIL,
    CL.ADDR1                       AS ADRES,
    CL.TOWN                        AS ILCE,
    CL.CITY                        AS IL,

    /* ÜRÜN */
    ORL.LINENO_                    AS SATIR_NO,
    ITM.CODE                       AS URUN_KODU,
    ITM.NAME                       AS URUN_ADI,

    ORL.AMOUNT                     AS SIPARIS_MIKTARI,
    ORL.PRICE                      AS BIRIM_FIYAT,
    ORL.TOTAL                      AS BRUT_TUTAR,
    ORL.VAT                        AS KDV_ORANI,
    ORL.VATAMNT                    AS KDV_TUTARI,
    ORL.LINENET                    AS NET_TUTAR,

    /* SEVK */
    ORL.SHIPPEDAMOUNT              AS SEVK_EDILEN_MIKTAR,
    ORL.AMOUNT - ORL.SHIPPEDAMOUNT AS KALAN_MIKTAR

FROM LG_001_01_ORFICHE ORF

INNER JOIN LG_001_01_ORFLINE ORL
    ON ORL.ORDFICHEREF = ORF.LOGICALREF

LEFT JOIN LG_001_CLCARD CL
    ON CL.LOGICALREF = ORF.CLIENTREF

LEFT JOIN LG_001_ITEMS ITM
    ON ITM.LOGICALREF = ORL.STOCKREF

WHERE
    ORF.FICHENO = @SiparisNo
    AND ORF.TRCODE = 1
    AND ORF.CANCELLED = 0
    AND ORL.LINETYPE = 0

ORDER BY
    ORL.LINENO_;
