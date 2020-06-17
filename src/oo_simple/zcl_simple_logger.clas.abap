CLASS zcl_simple_logger DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ty_log_level TYPE symsgty .
    "Required for the BAL_LOG Functions in SAP
    TYPES ty_log_handle TYPE balloghndl .
    TYPES ty_log_number TYPE balognr .
    TYPES ty_log_header TYPE bal_s_log .

    TYPES: BEGIN OF ty_log_data,
             log_handle TYPE REF TO ty_log_handle,
             log_number TYPE ty_log_number,
             log_header TYPE ty_log_header,
           END OF ty_log_data.
    "Currently levels are only E,W or I
    CONSTANTS error TYPE ty_log_level VALUE 'E' ##NO_TEXT.
    CONSTANTS warning TYPE ty_log_level VALUE 'W' ##NO_TEXT.
    CONSTANTS info TYPE ty_log_level VALUE 'I' ##NO_TEXT.

    METHODS constructor
      IMPORTING
        !i_log_header TYPE ty_log_header .
    METHODS add_sy_msg
      IMPORTING
        !i_log_level TYPE ty_log_level .
    METHODS add_msg
      IMPORTING
        !i_log_level TYPE ty_log_level
        !i_text      TYPE c .
    METHODS display_log .
    METHODS search_log_exists
      IMPORTING
        !i_log_filter          TYPE bal_s_lfil
      RETURNING
        VALUE(r_found_headers) TYPE balhdr_t .
    METHODS get_log_data  RETURNING VALUE(r_result) TYPE ty_log_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_log_data TYPE ty_log_data.
    METHODS: create_log IMPORTING i_log_header         TYPE ty_log_header
                        RETURNING VALUE(rs_log_handle) TYPE ty_log_handle.
    METHODS save_log EXPORTING ET_HANDLES TYPE BAL_T_LOGH.
    METHODS update_log_header IMPORTING ir_log_handle TYPE ty_log_handle
                              CHANGING  cs_log_header TYPE ty_log_header.

ENDCLASS.



CLASS zcl_simple_logger IMPLEMENTATION.


  METHOD add_msg.
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

    save_log(  ).


  ENDMETHOD.


  METHOD add_sy_msg.

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


    save_log( ).

  ENDMETHOD.


  METHOD constructor.

* Adding the log here
    me->mo_log_data-log_header = i_log_header.
    me->mo_log_data-log_handle = COND #( WHEN NOT me->mo_log_data-log_handle IS BOUND THEN NEW #(  )
                                         ELSE me->mo_log_data-log_handle
     ).

    me->mo_log_data-log_handle->* = create_log( i_log_header ).

** BAL_LOG_CREATE will fill in some additional header data.
** This FM updates our instance attribute to reflect that.
    update_log_header(
    EXPORTING
    ir_log_handle = mo_log_data-log_handle->*
    CHANGING
    cs_log_header = mo_log_data-log_header
    ).

  ENDMETHOD.


  METHOD create_log.
    DATA: ls_log_handle TYPE balloghndl.
* Create the log here
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = i_log_header                 " Log header data
      IMPORTING
        e_log_handle            = rs_log_handle                " Log handle
      EXCEPTIONS
        log_header_inconsistent = 1                " Log header is inconsistent
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

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

    INSERT mo_log_data-log_handle->* INTO TABLE lt_log_handle.

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
*      RAISE EXCEPTION TYPE cx_cpf.
    ENDIF.

  ENDMETHOD.


  METHOD save_log.

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


  METHOD update_log_header.
** BAL_LOG_CREATE will fill in some additional header data.
** This FM updates our instance attribute to reflect that.
    DATA:ls_updated_log_header TYPE bal_s_log.
    CALL FUNCTION 'BAL_LOG_HDR_READ'
      EXPORTING
        i_log_handle  = ir_log_handle                " Log handle
      IMPORTING
        e_s_log       = ls_updated_log_header                  " Log header data
      EXCEPTIONS
        log_not_found = 1                " Log not found
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    cs_log_header  = ls_updated_log_header.

  ENDMETHOD.

  METHOD get_log_data.
    r_result = me->mo_log_data.
  ENDMETHOD.

ENDCLASS.
