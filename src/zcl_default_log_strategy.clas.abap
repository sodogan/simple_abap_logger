class zcl_default_log_strategy definition
  public
  final
  create public .

  public section.
    interfaces zif_log_strategy.
    aliases: create_log for zif_log_strategy~create_log.
    aliases: search_log_exists for zif_log_strategy~search_log_exists.
    aliases: add_sy_msg for zif_log_strategy~add_sy_msg.
    aliases: add_msg for zif_log_strategy~add_msg.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_DEFAULT_LOG_STRATEGY IMPLEMENTATION.


  method add_msg.
    data:   handles_to_save type bal_t_logh.


    call function 'BAL_LOG_MSG_ADD_FREE_TEXT'
      exporting
        i_log_handle = ir_log_handle
        i_msgty      = i_log_level
        i_text       = i_text.

    call function 'BAL_DB_SAVE'
      exporting
        i_save_all     = 'X'
        i_t_log_handle = handles_to_save
*      exceptions
*       log_not_found  = 1
*       save_not_allowed     = 2
*       numbering_error      = 3
*       others         = 4
      .
    if sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.


  endmethod.


  method add_sy_msg.
    data: ls_detailed_msg         type bal_s_msg
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

    call function 'BAL_LOG_MSG_ADD'
      exporting
        i_log_handle = ir_log_handle
        i_s_msg      = ls_detailed_msg.


    call function 'BAL_DB_SAVE'
      exporting
*       i_client   = SY-MANDT    " Client in which the new log is to be saved
*       i_in_update_task     = SPACE    " Save in UPDATE TASK
        i_save_all = abap_true   " Save all logs in memory
*       i_t_log_handle       =     " Table of log handles
*       i_2th_connection     = SPACE    " FALSE: No secondary connection
*       i_2th_connect_commit = SPACE    " FALSE: No COMMIT in module
*       i_link2job = 'X'    " Boolean Variable (X=true, -=false, space=unknown)
*      importing
*       e_new_lognumbers     =     " Table of new log numbers
*       e_second_connection  =     " Name of Secondary Connection
*      exceptions
*       log_not_found        = 1
*       save_not_allowed     = 2
*       numbering_error      = 3
*       others     = 4
      .
    if sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.


  endmethod.


  method create_log.

* Adding the log here
* Adding the log here
    call function 'BAL_LOG_CREATE'
      exporting
        i_s_log      = c_log_header
      importing
        e_log_handle = r_log_handle.

** BAL_LOG_CREATE will fill in some additional header data.
** This FM updates our instance attribute to reflect that.
    call function 'BAL_LOG_HDR_READ'
      exporting
        i_log_handle = r_log_handle
      importing
        e_s_log      = c_log_header.

  endmethod.


  method search_log_exists.

**Search for the Log based on the object and the subobject!
    call function 'BAL_DB_SEARCH'
      exporting
        i_s_log_filter = i_log_filter
      importing
        e_t_log_header = r_found_headers
      exceptions
        log_not_found  = 1.


  endmethod.
ENDCLASS.
