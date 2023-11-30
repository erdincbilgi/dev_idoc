*&---------------------------------------------------------------------*
*& Include          ZEB_I_IDOC_TOP
*&---------------------------------------------------------------------*

TABLES:kna1,ZEB_T_IDOC_001.

DATA: lt_temp TYPE TABLE of ZEB_T_IDOC_001.

SELECTION-SCREEN BEGIN OF BLOCK b1.
  "SELECT-OPTIONS: s_vbeln FOR vbak-vbeln.
  PARAMETERS: p_kunnr TYPE kna1-kunnr.
SELECTION-SCREEN END OF BLOCK b1.
