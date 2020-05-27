*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_test_helper definition.
  public section.
    class-methods: fail
      importing
        i_msg    type csequence
        i_detail type csequence optional
          preferred parameter i_msg.


    class-methods verify_true
      importing
        i_act type abap_bool
        i_msg type csequence optional
      .
  private section.
endclass.

class lcl_test_helper implementation.

  method fail.
    cl_abap_unit_assert=>fail(
        msg    = i_msg     " Description
        detail = i_detail   " Further Description
    ).
  endmethod.

  method verify_true.
    cl_abap_unit_assert=>assert_true(
     act = i_act
     msg = i_msg
      ).
  endmethod.

endclass.
