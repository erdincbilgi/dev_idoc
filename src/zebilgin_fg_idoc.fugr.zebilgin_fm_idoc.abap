FUNCTION ZEBILGIN_FM_IDOC.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_KUNNR) LIKE  KNA1-KUNNR
*"  EXPORTING
*"     REFERENCE(ES_EXPORT) LIKE  ZEBILGIN_S_IDOC STRUCTURE
*"        ZEBILGIN_S_IDOC
*"----------------------------------------------------------------------

  select single "kunnr
         name1
         ort02
         stras
         ort01
         regio
         land1
    from kna1
    into es_export
   where kunnr = iv_KUNNR.

  "

ENDFUNCTION.
