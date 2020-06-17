FUNCTION ZFM_CREATE_LOG.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_LOG_HEADER) TYPE  BAL_S_LOG
*"----------------------------------------------------------------------
* Adding the log here
   mo_log_data-log_header = i_log_header.
   mo_log_data-log_handle = COND #( WHEN NOT mo_log_data-log_handle IS BOUND THEN NEW #(  )
                                         ELSE mo_log_data-log_handle
     ).

* Create the log here
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = i_log_header                 " Log header data
      IMPORTING
        e_log_handle            = mo_log_data-log_handle->*                " Log handle
      EXCEPTIONS
        log_header_inconsistent = 1                " Log header is inconsistent
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.



ENDFUNCTION.
