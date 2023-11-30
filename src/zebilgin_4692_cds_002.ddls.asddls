@AbapCatalog.sqlViewName: 'ZEBILGIN_4692_02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Örnek2'
define view ZEBILGIN_4692_CDS_002 
  as select from vbrp
  inner join vbrk on vbrp.mandt = vbrk.mandt
                 and vbrp.vbeln = vbrk.vbeln
  inner join mara on mara.mandt = vbrp.mandt
                 and mara.matnr = vbrp.matnr
   left outer join vbak on vbrp.mandt = vbak.mandt
                       and vbak.vbeln = vbrp.aubel
   left outer join kna1 on kna1.mandt = vbrp.mandt
                       and kna1.kunnr = vbak.kunnr
   left outer join makt on makt.mandt = vbrp.mandt
                       and makt.matnr = mara.matnr
                       and makt.spras = $session.system_language
  
{
    key vbrp.vbeln,
    key vbrp.posnr,
        vbrp.aubel,
        vbrp.aupos,
        vbak.kunnr,
        concat_with_space(kna1.name1,kna1.name2,1) as kunnrAd,
        currency_conversion( amount             => vbrp.netwr,
                             source_currency    => vbrk.waerk,
                             target_currency    => cast('EUR' as abap.cuky), // waerk data elementi
                             exchange_rate_Date => vbrk.fkdat
                           ) as conversion_netwr,
        left(kna1.kunnr,3) as kunnr_lft,
        length(mara.matnr) as matnr_lngth,
        case 
          when vbrk.fkart = 'FAS'
            then 'Peşinat talebi iptali'
          when vbrk.fkart = 'FAZ'
            then 'Peşinat talebi'
          else 'Fatura'
        end as ftr_tr,
        vbrk.fkdat
}

