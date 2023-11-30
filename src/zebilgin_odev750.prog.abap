*&---------------------------------------------------------------------*
*& Report ZEBILGIN_ODEV750
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEBILGIN_ODEV750.

TYPES: BEGIN OF ty_first,
         werks  TYPE werks_d,
         arbpl  TYPE arbpl,
         toplam TYPE menge_d,
         meins  TYPE meins,
         islem  type int8,
       END OF ty_first.
TYPES : tt_first TYPE TABLE OF ty_first WITH EMPTY KEY.

DATA(lt_first) = VALUE tt_first(
  ( werks = '2013' arbpl = '07' toplam = '16'   meins = '' )
  ( werks = '2013' arbpl = '07' toplam = '32'   meins = '' )
  ( werks = '2015' arbpl = '09' toplam = '07'   meins = '' ) ).

DATA: lt_group_list TYPE tt_first.

"hem werks ile arbpl alanlari bazinda grouplama yaparken hem de toplam fieldinin group toplamini aldirmis olduk ;
lt_group_list = VALUE #( FOR GROUPS ls_group_list of <ls_first_list> in lt_first GROUP BY ( werks = <ls_first_list>-werks
                                                                                            arbpl = <ls_first_list>-arbpl )
              ( VALUE #( arbpl  = ls_group_list-arbpl
                         werks  = ls_group_list-werks
                         toplam = REDUCE netwr( INIT sum TYPE menge_d
                                                 FOR ls_first_list IN GROUP ls_group_list
                                                NEXT sum = sum + ls_first_list-toplam ) ) ) ).

"ayni itabta for dongusu acarak meins atamasi ve iki degiskeni carparak fielda atama yapabiliyoruz  ;
DATA(lt_final_list) = VALUE tt_first( FOR ls_first IN lt_group_list LET lv_meins = 'ADT'
                                                                        lv_carp1 = 5
                                                                        lv_carp2 = 3 IN ( meins = lv_meins
                                                                                          werks = ls_first-werks
                                                                                          arbpl = ls_first-arbpl
                                                                                          toplam = ls_first-toplam
                                                                                          islem = lv_carp1 * lv_carp2 ) ).

BREAK-POINT 'EBILGIN'.
