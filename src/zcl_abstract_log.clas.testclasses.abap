*"* use this source file for your ABAP unit test classes
*/
* Test File- Applying TDD
* Each function must be tested accordingly
*
*/

class lct_log definition deferred.
class zcl_abstract_log definition local friends lct_log.

*Test stub for the local log creator
class lcts_log_strategy definition for testing.
  public section.
    interfaces zif_log_strategy.
    aliases: create_log for zif_log_strategy~create_log.
    aliases: search_log_exists for zif_log_strategy~search_log_exists.
    aliases: add_sy_msg for zif_log_strategy~add_sy_msg.
    aliases: add_msg for zif_log_strategy~add_msg.

  private section.
endclass.

class lcts_log_strategy implementation.
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


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DEFAULT_LOG_STRATEGY->ZIF_LOG_STRATEGY~ADD_SY_MSG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IR_LOG_HANDLE                  TYPE        ZIF_LOG=>TY_LOG_HANDLE
* | [--->] I_LOG_LEVEL                    TYPE        ZIF_LOG=>TY_LOG_LEVEL
* | [<-()] RO_LOG                         TYPE REF TO ZIF_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
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


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DEFAULT_LOG_STRATEGY->ZIF_LOG_STRATEGY~CREATE_LOG
* +-------------------------------------------------------------------------------------------------+
* | [<-->] C_LOG_HEADER                   TYPE        ZIF_LOG=>TY_LOG_HEADER
* | [<-()] R_LOG_HANDLE                   TYPE        ZIF_LOG=>TY_LOG_HANDLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
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


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DEFAULT_LOG_STRATEGY->ZIF_LOG_STRATEGY~SEARCH_LOG_EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_LOG_FILTER                   TYPE        BAL_S_LFIL
* | [<-()] R_FOUND_HEADERS                TYPE        BALHDR_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
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




endclass.

class lct_log definition for testing duration short risk level harmless.
  public section.
  private section.
    constants: gc_log_object_zmig type string value `ZMIG` ##NO_TEXT.
    constants: gc_log_subobject_arun type string value `ARUN` ##NO_TEXT.
*    methods:setup.
*    methods:teardown.
*    data: lo_cut type ref to zcl_abstract_log.
    methods emptyparametersraiseexception for testing raising cx_static_check.
    methods createabasiclog for testing raising cx_static_check.
endclass.

class lct_log implementation.

*    lcl_test_helper=>fail( |Start with a fail message| ).
  method emptyparametersraiseexception.

* GIVEN
    data: lo_cut type ref to zcl_abstract_log.
*-WHEN
    data(lv_exception_thrown) = abap_false.

    try.
        lo_cut = new #( i_object = ||
                        i_subobject = ||
                       ).

      catch cx_root into data(lo_exception).
        lv_exception_thrown = abap_true.
    endtry.

* No need for this test!

*THEN
*    data(boolean) = xsdbool( 1 > 2 ).
*    data(true) = abap_true.
*    data(actual) = xsdbool( lo_cut is bound ).
    lcl_test_helper=>verify_true( lv_exception_thrown ).


  endmethod.




* Testing the create Log by itself
* Directly calling over the interface
  method createabasiclog.

* lcl_test_helper=>fail( |Start with a fail message| ).
* GIVEN
    data: lo_cut type ref to zcl_abstract_log.

*-WHEN
    data(lct_stub) = new lcts_log_strategy(  ).

    try.
        lo_cut = new #( i_object = |{ gc_log_object_zmig }|
                        i_subobject = |{ gc_log_subobject_arun }|
                        i_if_log_strategy = lct_stub
                       ).

*        Try to add a basic error to the log
        message e010(oo) with 'jaleda' 'titi' 'kuku' into data(dummy).
        lo_cut->add_sy_msg( i_log_level = zif_log=>error ).

** Commit the changes to the Database!
        call function 'BAPI_TRANSACTION_COMMIT'.

      catch cx_root into data(lo_exception).
    endtry.

** Then a new log object should be created in SLG1
** How do we test that it worked!
* THEN
*    data(ls_log_filter) = value bal_s_lfil( object = value #( ( sign = 'I'  option = 'EQ'    low = lo_cut->ms_log_header-object ) )
*                                            subobject = value #( ( sign = 'I'  option = 'EQ' low = lo_cut->ms_log_header-subobject ) )
*                                          ).
*    data(lt_actual) = lct_stub->search_log_exists( i_log_filter =  ls_log_filter ).
*
*    if not line_exists( lt_actual[ object = |{ gc_log_object_zmig }|
*                               subobject = |{ gc_log_subobject_arun }| ] ).
*
*      lcl_test_helper=>fail( |The log: { gc_log_object_zmig } failed to be created for | ).
*
*    endif.
*   cl_abap_unit_assert=>assert_table_contains(
*     exporting
*       line             =     " Data Object that is typed like line of TABLE
*       table            = lt_actual    " Internal Table that shall contain LINE
*       msg              =     " Description
*       level            =     " Severity (TOLERABLE, >CRITICAL<, FATAL)
*       quit             =     " Alter control flow/ quit test (NO, >METHOD<, CLASS)
*     receiving
*       assertion_failed =     " Condition was not met (and QUIT = NO)
*   ).

  endmethod.






endclass.
