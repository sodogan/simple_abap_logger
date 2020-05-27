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

  private section.
endclass.

class lcts_log_strategy implementation.

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


    call function 'BAL_DB_SEARCH'
      exporting
        i_s_log_filter = i_log_filter
      importing
        e_t_log_header = found_headers
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

      catch cx_root into data(lo_exception).
    endtry.

** Then a new log object should be created in SLG1
** How do we test that it worked!
*     lo_cut->ms_log_header
*    data(ls_log_filter) = value bal_s_lfil( object = value #( low = lo_cut->ms_log_header-object )
*                                            subobject = value #( low = lo_cut->ms_log_header-subobject )
*                                          ).
*    lct_stub->search_log_exists( i_log_filter =  lo_cut->ms_log_header ).

  endmethod.






endclass.
