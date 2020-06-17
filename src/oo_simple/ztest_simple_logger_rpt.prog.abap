*&---------------------------------------------------------------------*
*& Report ztest_simple_logger_rpt
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_simple_logger_rpt.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CONSTANTS zmig TYPE bal_s_log-object VALUE 'ZMIG' ##NO_TEXT.
    CONSTANTS arun TYPE bal_s_log-subobject VALUE 'ARUN' ##NO_TEXT.

    CLASS-METHODS:test.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD test.
*create the logger
* Given
    DATA(ls_log_header) = VALUE zcl_simple_logger=>ty_log_header( object = zmig  subobject = arun ).
    DATA(lo_simple_logger) = NEW zcl_simple_logger( i_log_header = ls_log_header  ).
* then
    DATA(ls_actual_log_data) =  lo_simple_logger->get_log_data(  ).
* expected
    lo_simple_logger->add_msg( i_text = |Adding a severe issue from Unit test| i_log_level = zcl_simple_logger=>error ).

  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  lcl_main=>test(  ).
