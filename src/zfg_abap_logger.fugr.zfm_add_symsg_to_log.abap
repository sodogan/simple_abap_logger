FUNCTION ZFM_ADD_SYMSG_TO_LOG.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_LOG_LEVEL) TYPE  SYMSGTY
*"     REFERENCE(I_TEXT) TYPE  C
*"  EXPORTING
*"     REFERENCE(ET_HANDLES) TYPE  BAL_T_LOGH
*"----------------------------------------------------------------------
  ASSERT mo_log_data-log_handle IS BOUND.

  GET TIME STAMP FIELD DATA(lv_time_stamp).

  DATA(ls_detailed_msg) = VALUE bal_s_msg(
                          msgid = sy-msgid
                          msgno = sy-msgno
                          msgty = sy-msgty
                          msgv1 = sy-msgv1
                          msgv2 = sy-msgv2
                          msgv3 = sy-msgv3
                          msgv4 = sy-msgv4
                          time_stmp = lv_time_stamp

                           ).

*Add the log
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle = mo_log_data-log_handle->*
        i_s_msg      = ls_detailed_msg
*      IMPORTING
*        e_msg_was_logged    =                  " Message collected
      EXCEPTIONS
        log_not_found       = 1                " Log not found
        msg_inconsistent    = 2                " Message inconsistent
        log_is_full         = 3                " Message number 999999 reached. Log is full
        others              = 4
      .
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.



*Save the log here
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_save_all       = 'X'
      i_t_log_handle   = et_handles
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFUNCTION.
