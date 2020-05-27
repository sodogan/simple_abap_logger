*"* use this source file for your ABAP unit test classes
*/
* Test File- Applying TDD
* Each function must be tested accordingly
*
*/

class lct_log definition deferred.
class zcl_abstract_log definition local friends lct_log.

*Test stub for the local log creator
class lcts_log_creator definition for testing.
  public section.
    interfaces lif_log_creator.
endclass.

class lcts_log_creator implementation.

  method lif_log_creator~create_log.

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

endclass.

class lct_log definition for testing duration short risk level harmless.
  public section.
  private section.
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
    try.
        lo_cut = new #( i_object = |ZMIG|
                        i_subobject = |ARUN|
                       ).

      catch cx_root into data(lo_exception).
    endtry.
*-WHEN
    data(lct_stub) = new lcts_log_creator(  ).

    lo_cut->create_log(
        i_if_log_creator = lct_stub
    ).

* Then a new log object should be created in SLG1
* How do we test that it worked!


  endmethod.






endclass.
