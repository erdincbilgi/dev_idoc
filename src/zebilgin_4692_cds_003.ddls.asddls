@AbapCatalog.sqlViewName: 'ZEBILGIN_4692_03'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Örnek3'
define view ZEBILGIN_4692_CDS_003 
  as select from zebilgin_4692_02 as cds
  inner join vbrk as k on k.vbeln = cds.vbeln
{
    cds.vbeln,
    cds.kunnrad,
    @Semantics.amount.currencyCode: 'VBRK.WAERK'
    sum(cds.conversion_netwr) as conversion_netwr_sum,
    count(*) as count_fatura,
    @Semantics.amount.currencyCode: 'VBRK.WAERK'
    division( cast( sum(cds.conversion_netwr) as netwr), cast ( count(*) as abap.int4 ), 2) as ort_netwr,
    substring(cds.fkdat,1,4) as fkdat_year,
    substring(cds.fkdat,5,2) as fkdat_month,
    substring(cds.fkdat,7,2) as fkdat_day,
    substring(k.inco2_l,1,3) as inco2_l
}
  group by cds.vbeln,
           cds.kunnrad,
           cds.fkdat,
           k.inco2_l
