CLASS zcl_default_log_strategy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_log_strategy.
    ALIASES: create_log FOR zif_log_strategy~create_log.
    ALIASES: search_log_exists FOR zif_log_strategy~search_log_exists.
    ALIASES: add_sy_msg FOR zif_log_strategy~add_sy_msg.
    ALIASES: add_msg FOR zif_log_strategy~add_msg.
    ALIASES: display_log FOR zif_log_strategy~display_log.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEFAULT_LOG_STRATEGY IMPLEMENTATION.


  METHOD add_msg.
    DATA:   lt_handles_to_save TYPE bal_t_logh.


    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
      EXPORTING
        i_log_handle = ir_log_handle
        i_msgty      = i_log_level
        i_text       = i_text.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_save_all     = 'X'
        i_t_log_handle = lt_handles_to_save
*      exceptions
*       log_not_found  = 1
*       save_not_allowed     = 2
*       numbering_error      = 3
*       others         = 4
      .
    IF sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


  ENDMETHOD.


  METHOD add_sy_msg.
    DATA: ls_detailed_msg    TYPE bal_s_msg,
          lt_handles_to_save TYPE bal_t_logh.

    .
*  detailed_msg-context   = formatted_context.
*      detailed_msg-params    = formatted_params.
*      detailed_msg-probclass = importance.
    ls_detailed_msg-msgid = sy-msgid.
    ls_detailed_msg-msgno = sy-msgno.
    ls_detailed_msg-msgty = sy-msgty.
    ls_detailed_msg-msgv1 = sy-msgv1.
    ls_detailed_msg-msgv2 = sy-msgv2.
    ls_detailed_msg-msgv3 = sy-msgv3.
    ls_detailed_msg-msgv4 = sy-msgv4.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle = ir_log_handle
        i_s_msg      = ls_detailed_msg.


    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_save_all     = 'X'
        i_t_log_handle = lt_handles_to_save
*      exceptions
*       log_not_found  = 1
*       save_not_allowed     = 2
*       numbering_error      = 3
*       others         = 4
      .
    IF sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD create_log.

* Adding the log here
* Adding the log here
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = c_log_header
      IMPORTING
        e_log_handle = r_log_handle.

** BAL_LOG_CREATE will fill in some additional header data.
** This FM updates our instance attribute to reflect that.
    CALL FUNCTION 'BAL_LOG_HDR_READ'
      EXPORTING
        i_log_handle = r_log_handle
      IMPORTING
        e_s_log      = c_log_header.

  ENDMETHOD.


  METHOD display_log.
    DATA lo_cpf_message     TYPE REF TO cl_cpf_messages.
    DATA ls_display_profile TYPE bal_s_prof.
    DATA lt_log_handle TYPE bal_t_logh.



*   get a prepared profile
    CALL FUNCTION 'BAL_DSP_PROFILE_POPUP_GET'
      EXPORTING
        start_col           = 20
        start_row           = 10
        end_col             = 102
        end_row             = 30
      IMPORTING
        e_s_display_profile = ls_display_profile.

    ls_display_profile-use_grid          = abap_true.
    ls_display_profile-title             = TEXT-t01.
    ls_display_profile-disvariant-handle = if_cpf_constants=>gc_cpf_message_log.

    INSERT ir_log_handle INTO TABLE lt_log_handle.

*   Display BRFplus application log
    CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
      EXPORTING
        i_s_display_profile  = ls_display_profile
        i_t_log_handle       = lt_log_handle
      EXCEPTIONS
        profile_inconsistent = 1
        internal_error       = 2
        no_data_available    = 3
        no_authority         = 4
        OTHERS               = 5.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_cpf.
    ENDIF.

  ENDMETHOD.


  METHOD search_log_exists.

**Search for the Log based on the object and the subobject!
    CALL FUNCTION 'BAL_DB_SEARCH'
      EXPORTING
        i_s_log_filter = i_log_filter
      IMPORTING
        e_t_log_header = r_found_headers
      EXCEPTIONS
        log_not_found  = 1.


  ENDMETHOD.
ENDCLASS.
