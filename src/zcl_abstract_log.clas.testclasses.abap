*"* use this source file for your ABAP unit test classes

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




  method createabasiclog.

* lcl_test_helper=>fail( |Start with a fail message| ).
* GIVEN
    data: lo_cut type ref to zcl_abstract_log.
*-WHEN
    try.
        lo_cut = new #( i_object = |ZMIG|
                        i_subobject = |ARUN|
                       ).

      catch cx_root into data(lo_exception).
    endtry.

* Then a new log object should be created in SLG1
* How do we test that it worked!


  endmethod.






endclass.
