*----------------------------------------------------------------------*
***INCLUDE FP_TEST_ERROR_HANDLING.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  create_log
*&---------------------------------------------------------------------*
FORM create_log USING p_object TYPE balobj_d
                      p_subobj TYPE balsubobj.
  DATA ls_log_header TYPE bal_s_log.

  ls_log_header-object     = p_object.
  ls_log_header-subobject  = p_subobj.
  ls_log_header-aldate_del = sy-datum + 90.
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log = ls_log_header.
ENDFORM.                    " create_log


*&---------------------------------------------------------------------*
*&      Form  add_message
*&---------------------------------------------------------------------*
*       Adds a message to the application log.
*----------------------------------------------------------------------*
*  -->  p_msgty   message type
*  -->  p_msgid   message ID
*  -->  p_msgno   message number
*  -->  p_msgv?   parameter
*  -->  p_level   detail level
*----------------------------------------------------------------------*
FORM add_message USING p_msgty TYPE symsgty
                       p_msgid TYPE symsgid
                       p_msgno TYPE symsgno
                       p_msgv1 TYPE any
                       p_msgv2 TYPE any
                       p_msgv3 TYPE any
                       p_msgv4 TYPE any
                       p_level TYPE ballevel.
  DATA ls_msg TYPE bal_s_msg.

  MOVE: p_msgty TO ls_msg-msgty,
        p_msgid TO ls_msg-msgid,
        p_msgno TO ls_msg-msgno,
        p_msgv1 TO ls_msg-msgv1,
        p_msgv2 TO ls_msg-msgv2,
        p_msgv3 TO ls_msg-msgv3,
        p_msgv4 TO ls_msg-msgv4,
        p_level TO ls_msg-detlevel.
  CONDENSE: ls_msg-msgv1, ls_msg-msgv2, ls_msg-msgv3, ls_msg-msgv4.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_s_msg          = ls_msg
    EXCEPTIONS
      log_not_found    = 0
      msg_inconsistent = 0
      log_is_full      = 0
      OTHERS           = 0.
ENDFORM.                    " add_message


*&---------------------------------------------------------------------*
*&      Form  write_to_log
*&---------------------------------------------------------------------*
FORM write_to_log USING i_error_text   TYPE string
                        i_process_name TYPE string
                        i_detlevel     TYPE ballevel.
  DATA: l_error_text1 TYPE symsgv,
        l_error_text2 TYPE symsgv,
        l_error_text3 TYPE symsgv,
        l_len         TYPE i.

  l_len = STRLEN( i_error_text ).
  IF l_len <= 50.
    l_error_text1 = i_error_text.
  ELSE.
    l_error_text1 = i_error_text(50).
    l_error_text2 = i_error_text+50.
  ENDIF.
  IF l_len > 100.
    l_error_text3 = i_error_text+100.
  ENDIF.
  PERFORM add_message
      USING 'E' '00' '000'
            i_process_name l_error_text1 l_error_text2 l_error_text3
            i_detlevel.
ENDFORM.                    " write_to_log


*&---------------------------------------------------------------------*
*&      Form  error_short
*&---------------------------------------------------------------------*
FORM error_short USING p_fpx          TYPE REF TO cx_fp_api "#EC CALLED
                       p_process_name TYPE string
                       p_detlevel     TYPE ballevel.
  DATA lv_error_text TYPE string.

  lv_error_text = p_fpx->get_text( ).
  PERFORM write_to_log USING lv_error_text p_process_name p_detlevel.
ENDFORM.                    " error_short


*&---------------------------------------------------------------------*
*&      Form  error_trace
*&---------------------------------------------------------------------*
FORM error_trace                                            "#EC CALLED
    USING p_fpx          TYPE REF TO cx_fp_runtime
          p_process_name TYPE string
          p_pdfobj       TYPE REF TO if_fp_pdf_object
          p_detlevel     TYPE ballevel.
  DATA: lv_error_text    TYPE string,
        lv_trace         TYPE string.                       "#EC NEEDED

  lv_error_text = p_fpx->get_text( ).
  IF p_pdfobj IS NOT INITIAL.
    lv_trace = p_pdfobj->get_trace( ).
  ENDIF.

  PERFORM write_to_log USING lv_error_text p_process_name p_detlevel.
ENDFORM.                    " error


*&---------------------------------------------------------------------*
*&      Form  save_and_show_messages
*&---------------------------------------------------------------------*
FORM save_and_show_messages.
  DATA ls_logdisplay_profile TYPE bal_s_prof.
  DATA ls_message_filter     TYPE bal_s_msty.
  DATA ls_filter             TYPE bal_s_mfil.

* Search for error messages in the procotol and set the test result
* accordingly.
  ls_message_filter-sign   = 'I'.
  ls_message_filter-option = 'EQ'.
  ls_message_filter-low    = 'E'.
  INSERT ls_message_filter INTO TABLE ls_filter-msgty.
  CALL FUNCTION 'BAL_GLB_SEARCH_MSG'
    EXPORTING
      i_s_msg_filter = ls_filter
    EXCEPTIONS
      msg_not_found  = 1
      OTHERS         = 2.
  IF sy-subrc = 1.
    SET PARAMETER ID 'TEST_RESULT' FIELD 'OK'.
  ELSE.
    SET PARAMETER ID 'TEST_RESULT' FIELD 'ERROR'.
  ENDIF.

* Save the protocol.
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_save_all       = abap_true
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc IS NOT INITIAL.
    PERFORM add_message
        USING 'E' '00' '000' space space space space '1'.
  ENDIF.

* Display the accumulated messages.
  CALL FUNCTION 'BAL_DSP_PROFILE_DETLEVEL_GET'
    IMPORTING
      e_s_display_profile = ls_logdisplay_profile.
  CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
    EXPORTING
      i_s_display_profile = ls_logdisplay_profile.
ENDFORM.                    " save_and_show_messages
