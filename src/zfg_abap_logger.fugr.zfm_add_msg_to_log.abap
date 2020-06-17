FUNCTION ZFM_ADD_MSG_TO_LOG.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_LOG_LEVEL) TYPE  SYMSGTY
*"     REFERENCE(I_TEXT) TYPE  C
*"  EXPORTING
*"     REFERENCE(ET_HANDLES) TYPE  BAL_T_LOGH
*"----------------------------------------------------------------------
  DATA: lv_msg_was_logged TYPE abap_bool.

  ASSERT mo_log_data-log_handle IS BOUND.

  CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
    EXPORTING
      i_log_handle     = mo_log_data-log_handle->*
      i_msgty          = i_log_level
      i_text           = i_text
    IMPORTING
      e_msg_was_logged = lv_msg_was_logged                  " Message collected
    EXCEPTIONS
      log_not_found    = 1                " Log not found
      msg_inconsistent = 2                " Message inconsistent
      log_is_full      = 3                " Message number 999999 reached. Log is full
      OTHERS           = 4.
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
     message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFUNCTION.
