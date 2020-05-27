*&---------------------------------------------------------------------*
*& Report ZTEST_BAL_LOGS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report ztest_bal_logs.
constants: gc_log_object_zmig type string value `ZMIG` ##NO_TEXT.
constants: gc_log_subobject_arun type string value `ARUN` ##NO_TEXT.




start-of-selection.

  data: lo_cut type ref to zcl_abstract_logger.

* Testing the class to do the same thing
  try .
      lo_cut = new zcl_slg1_logger( i_object = |{ gc_log_object_zmig }|
                          i_subobject = |{ gc_log_subobject_arun }|
*                          i_if_log_strategy = lct_stub
                         ).

*        Try to add a basic error message
      MESSAGE e010(oo) WITH 'myname' 'lastname' 'kekeke' INTO DATA(dummy).
      lo_cut->add_sy_msg( i_log_level = zcl_abstract_logger=>error ).

*   Try to add  a text to the log!
      lo_cut->add_msg( i_log_level = zcl_abstract_logger=>error i_text = | am i working?| ).


    catch cx_root into data(lo_exception) .

  endtry.










form test_bal_log_msg_add.
  data: header          type bal_s_log,
        handle          type balloghndl,
        handles_to_save type bal_t_logh,
        ls_detailed_msg type bal_s_msg.



  header-object = 'ZMIG'.
  header-subobject = 'ARUN'.
  header-extnumber = 'Stuff imported from legacy systems'.

  call function 'BAL_LOG_CREATE'
    exporting
      i_s_log      = header
    importing
      e_log_handle = handle.

*  detailed_msg-context   = formatted_context.
*      detailed_msg-params    = formatted_params.
*      detailed_msg-probclass = importance.
  message e001(oo) with 'foo' 'bar' 'baz' into data(lv_error).
  ls_detailed_msg-msgid = sy-msgid.
  ls_detailed_msg-msgno = sy-msgno.
  ls_detailed_msg-msgty = sy-msgty.
  ls_detailed_msg-msgv1 = sy-msgv1.
  ls_detailed_msg-msgv2 = sy-msgv2.
  ls_detailed_msg-msgv3 = sy-msgv3.
  ls_detailed_msg-msgv4 = sy-msgv4.

  call function 'BAL_LOG_MSG_ADD'
    exporting
      i_log_handle = handle
      i_s_msg      = ls_detailed_msg.

  call function 'BAL_DB_SAVE'
    exporting
      i_save_all     = 'X'
      i_t_log_handle = handles_to_save.

*call FUNCTION 'BAPI_TRANSACTION_COMMIT'.

endform.

form test_bal_log_free_text.
  data: header          type bal_s_log,
        handle          type balloghndl,
        handles_to_save type bal_t_logh.

  header-object = 'ZMIG'.
  header-subobject = 'ARUN'.
  header-extnumber = 'Stuff imported from legacy systems'.

  call function 'BAL_LOG_CREATE'
    exporting
      i_s_log      = header
    importing
      e_log_handle = handle.

  call function 'BAL_LOG_MSG_ADD_FREE_TEXT'
    exporting
      i_log_handle = handle
      i_msgty      = 'E'
      i_text       = 'Second message, this is cool...'.

  call function 'BAL_DB_SAVE'
    exporting
      i_save_all     = 'X'
      i_t_log_handle = handles_to_save.

*call FUNCTION 'BAPI_TRANSACTION_COMMIT'.

endform.
