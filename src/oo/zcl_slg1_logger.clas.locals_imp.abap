*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declaration
CLASS lcl_test_helper DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: fail
      IMPORTING
        i_msg    TYPE csequence
        i_detail TYPE csequence OPTIONAL
      .


    CLASS-METHODS verify_true
      IMPORTING
        i_act TYPE abap_bool
        i_msg TYPE csequence OPTIONAL
      .
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_test_helper IMPLEMENTATION.

  METHOD fail.
    cl_abap_unit_assert=>fail(
        msg    = i_msg     " Description
        detail = i_detail   " Further Description
    ).
  ENDMETHOD.

  METHOD verify_true.
    cl_abap_unit_assert=>assert_true(
     act = i_act
     msg = i_msg
      ).
  ENDMETHOD.

ENDCLASS.
