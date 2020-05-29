*&---------------------------------------------------------------------*
*& Report ZTEST_BAL_LOGS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  ztest_bal_logs.


*/*
* Basic Report to test the Logger Functionality
* Notice the use of the log object
* You can specify your own log strategy otherwise will use the default
*/
CLASS lcl_log_runner DEFINITION ABSTRACT FINAL.
  PUBLIC SECTION.
    CONSTANTS: gc_log_object_zmig TYPE string VALUE `ZMIG` ##NO_TEXT.
    CONSTANTS: gc_log_subobject_arun TYPE string VALUE `ARUN` ##NO_TEXT.

    CLASS-METHODS: main.

ENDCLASS.
CLASS lcl_log_runner IMPLEMENTATION.
  METHOD main.

    DATA: lo_cut TYPE REF TO zcl_abstract_logger.
    DATA: lo_strategy TYPE REF TO zif_log_strategy.
* Testing the class to do the same thing
    TRY .
*//You can pass a strategy into the Logger otherwise it will use the Default Logger!
        lo_strategy = NEW zcl_default_log_strategy( ).
        lo_cut = NEW zcl_slg1_logger( i_object = |{ gc_log_object_zmig }|
                            i_subobject = |{ gc_log_subobject_arun }|
                          i_if_log_strategy = lo_strategy
                           ).

*        Try to add a basic error message
        MESSAGE e014(oo) WITH 'Istanbul ' 'list' INTO DATA(dummy).
        lo_cut->add_sy_msg( i_log_level = zcl_abstract_logger=>info )->add_msg(
                            i_log_level = zcl_abstract_logger=>warning i_text = |object:{ gc_log_object_zmig }| ).
*   Try to add  a text to the log!
*        lo_cut->add_msg( i_log_level = zcl_abstract_logger=>error i_text = |third test| ).

* Display the Log here
        lo_cut->display_log( ).

      CATCH cx_root INTO DATA(lo_exception) .
        BREAK-POINT.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
***Run the test code here!
  lcl_log_runner=>main( ).


*/*
* OLD style procedural programming
* Notice the use of the function calls and its all based on steps
* You can specify your own log strategy otherwise will use the default
*/
FORM test_bal_log_msg_add.
  DATA: header          TYPE bal_s_log,
        handle          TYPE balloghndl,
        handles_to_save TYPE bal_t_logh,
        ls_detailed_msg TYPE bal_s_msg.



  header-object = 'ZMIG'.
  header-subobject = 'ARUN'.
  header-extnumber = 'Stuff imported from legacy systems'.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log      = header
    IMPORTING
      e_log_handle = handle.

*  detailed_msg-context   = formatted_context.
*      detailed_msg-params    = formatted_params.
*      detailed_msg-probclass = importance.
  MESSAGE e001(oo) WITH 'foo' 'bar' 'baz' INTO DATA(lv_error).
  ls_detailed_msg-msgid = sy-msgid.
  ls_detailed_msg-msgno = sy-msgno.
  ls_detailed_msg-msgty = sy-msgty.
  ls_detailed_msg-msgv1 = sy-msgv1.
  ls_detailed_msg-msgv2 = sy-msgv2.
  ls_detailed_msg-msgv3 = sy-msgv3.
  ls_detailed_msg-msgv4 = sy-msgv4.

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle = handle
      i_s_msg      = ls_detailed_msg.

  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_save_all     = 'X'
      i_t_log_handle = handles_to_save.

*call FUNCTION 'BAPI_TRANSACTION_COMMIT'.

ENDFORM.

FORM test_bal_log_free_text.
  DATA: header          TYPE bal_s_log,
        handle          TYPE balloghndl,
        handles_to_save TYPE bal_t_logh.

  header-object = 'ZMIG'.
  header-subobject = 'ARUN'.
  header-extnumber = 'Stuff imported from legacy systems'.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log      = header
    IMPORTING
      e_log_handle = handle.

  CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
    EXPORTING
      i_log_handle = handle
      i_msgty      = 'E'
      i_text       = 'Second message, this is cool...'.

  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_save_all     = 'X'
      i_t_log_handle = handles_to_save.

*call FUNCTION 'BAPI_TRANSACTION_COMMIT'.

ENDFORM.
