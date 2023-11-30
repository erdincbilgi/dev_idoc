@AbapCatalog.sqlViewName: 'ZEBILGIN_4692_01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Örnek'
define view ZEBILGIN_4692_CDS_001 
  as select from ekko 
    left outer join ekpo on ekko.ebeln = ekpo.ebeln 
    left outer join mara on mara.matnr = ekpo.matnr
    left outer join makt on makt.matnr = mara.matnr
                        and makt.spras = $session.system_language
    left outer join lfa1 on lfa1.lifnr = ekko.lifnr
{
    ekpo.ebeln,
    ekpo.ebelp,
    ekpo.matnr,
    makt.maktx,
    ekpo.werks,
    ekpo.lgort,
    ekpo.meins,
    lfa1.lifnr,
    concat(lfa1.stras,lfa1.mcod3 ) as satici_adresi

}
