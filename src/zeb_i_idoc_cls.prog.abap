*&---------------------------------------------------------------------*
*& Include          ZEB_I_IDOC_CLS
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    "  CLASS-DATA:

    CLASS-METHODS:
      get_data.

ENDCLASS.
CLASS lcl_main IMPLEMENTATION.

  METHOD get_data.

    DATA: lt_edidd TYPE TABLE OF edidd,
          lt_edidc TYPE TABLE OF edidc.
    DATA ls_kna1 TYPE  ZEBILGIN_S_IDOC.

    CLEAR : lt_edidc, lt_edidd.

*    SELECT SINGLE kunnr,
*                  NAME1,
*                  ORT02,
*                  STRAS,
*                  ORT01,
*                  REGIO,
*                  LAND1
*       FROM kna1
*      INTO @DATA(ls_kna1)
*      WHERE kunnr = @p_kunnr.

    CALL FUNCTION 'ZEBILGIN_FM_IDOC'
      EXPORTING
        iv_kunnr        = p_kunnr
      IMPORTING
        ES_EXPORT       = ls_kna1
              .

    IF sy-subrc EQ 0.

      APPEND INITIAL LINE TO lt_temp ASSIGNING FIELD-SYMBOL(<fs_temp>).
      MOVE-CORRESPONDING ls_kna1 TO <fs_temp>.
      <fs_temp>-mandt = sy-mandt.
      MODIFY ZEB_T_IDOC_001 FROM TABLE lt_temp.
      COMMIT WORK AND WAIT.


*başlık bilgileri dolduruluyor / control record...
*WE20 işlem kodunda doldurduğumuz alanlar
*mestyp -> mesaj tip alanı, WE81 deki ileti tipimiz
*doctyp -> dokuman tip, temel tipimiz WE30 da yarattığımız
*rcvprn -> muhatap alanına, WE20de tanımladığımız porttaki alıcı kısmını veriyoruz
*rcvprn -> muhatap türü, WE20deki tanımladığımız rol
      DATA(ls_edidc) = VALUE edidc( mestyp = 'ZEB_IDOCTEST'
                                    doctyp = 'ZEB_IDOC'
                                    rcvprn = 'S4HCLNT500'
                                    rcvprt = 'LS' ).
*                                    rcvprt = '' ).

*verilerin iletileceği kısım / data record...
*WE30 içerisinde belirttiğim ZBC_IDOC temel tipi kullanıyorum ve bunun içerisindeki alanları dolduruyorum
*segnam -> WE30 da yarattığım temel tipin adı
*sdata  -> yarattığım tipi
      APPEND INITIAL LINE TO lt_edidd ASSIGNING FIELD-SYMBOL(<fs_edidd>).
      <fs_edidd>-segnam = 'ZEB_IDOC'.
      <fs_edidd>-sdata  = |{ ls_kna1-name1 WIDTH = 35 } { ls_kna1-ort02 WIDTH = 35 }{ ls_kna1-stras  WIDTH = 35 }{ ls_kna1-ort01 WIDTH = 35 }{ ls_kna1-regio WIDTH = 3 }{ ls_kna1-land1 WIDTH = 3 }|.
*      <fs_edidd>-sdata  = |{ ls_kna1-kunnr }{ ls_kna1-NAME1 }{ ls_kna1-ORT02 }{ ls_kna1-STRAS }|.


*data record ve control record bilgilerini gönderdik...
      CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
        EXPORTING
          master_idoc_control            = ls_edidc
        TABLES
          communication_idoc_control     = lt_edidc
          master_idoc_data               = lt_edidd
        EXCEPTIONS
          error_in_idoc_control          = 1
          error_writing_idoc_status      = 2
          error_in_idoc_data             = 3
          sending_logical_system_unknown = 4
          OTHERS                         = 5.

      IF sy-subrc EQ 0.
*idocları 03 statusune çekerek ilgili sisteme iletir
        CALL FUNCTION 'DB_COMMIT'.
        CALL FUNCTION 'DEQUEUE_ALL'.
        COMMIT WORK.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
