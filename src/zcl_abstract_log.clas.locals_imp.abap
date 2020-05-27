*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_log_creator implementation.
  method create_log.

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




class lcl_test_helper definition.
  public section.
    class-methods: fail
      importing
        i_msg    type csequence
        i_detail type csequence optional
      .


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
