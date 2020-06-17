*"* use this source file for your ABAP unit test classes

CLASS lct_test_simple_logger DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    CONSTANTS zmig TYPE bal_s_log-object VALUE 'ZMIG' ##NO_TEXT.
    CONSTANTS arun TYPE bal_s_log-subobject VALUE 'ARUN' ##NO_TEXT.
    METHODS testcreatinglog FOR TESTING RAISING cx_static_check.
    METHODS testaddingmessage FOR TESTING RAISING cx_static_check.
    METHODS testaddingsymessage FOR TESTING RAISING cx_static_check.
    METHODS fail.
    METHODS:setup.
    DATA: mo_cut TYPE REF TO zcl_simple_logger.
    DATA: ms_cut_initial_log_header TYPE  zcl_simple_logger=>ty_log_header.
ENDCLASS.
CLASS lct_test_simple_logger IMPLEMENTATION.

  METHOD setup.
* Given
    ms_cut_initial_log_header = VALUE zcl_simple_logger=>ty_log_header( object = zmig  subobject = arun ).
    mo_cut = NEW zcl_simple_logger( i_log_header = ms_cut_initial_log_header  ).

  ENDMETHOD.

  METHOD testcreatinglog.
* when get the log data
    DATA(lr_actual_log_data) = NEW zcl_simple_logger=>ty_log_data(  mo_cut->get_log_data(  ) ).
* Then
    cl_abap_unit_assert=>assert_not_initial( lr_actual_log_data->log_header ).
    cl_abap_unit_assert=>assert_bound( lr_actual_log_data->log_handle ).
    cl_abap_unit_assert=>assert_differs( act = lr_actual_log_data->log_header-alprog exp = ms_cut_initial_log_header-alprog msg = |Log header should be diffrent| ).


  ENDMETHOD.
  METHOD testaddingmessage.
*    fail(  ).
    DO 5 TIMES.
      mo_cut->add_msg( i_text = |Adding a severe issue index: { sy-index }  from Unit test| i_log_level = zcl_simple_logger=>error ).
    ENDDO.
*Needed for the Tests to commit as the default commit off in Unit tests!
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

  ENDMETHOD.


  METHOD testaddingsymessage.
*    fail(  ).
    MESSAGE e010(00) WITH 'Smth went wrong' ' please correct ' INTO DATA(lv_dummy_message).

    mo_cut->add_sy_msg( i_log_level = zcl_simple_logger=>error ).

*Needed for the Tests to commit as the default commit off in Unit tests!
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

  ENDMETHOD.


  METHOD fail.

    cl_abap_unit_assert=>fail( |Always start with a failure| ).

  ENDMETHOD.


ENDCLASS.
