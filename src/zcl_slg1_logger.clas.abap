CLASS zcl_slg1_logger DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC INHERITING FROM zcl_abstract_logger.

  PUBLIC SECTION.

*  interfaces ZIF_LOG .

    METHODS: add_msg REDEFINITION.
    METHODS: add_sy_msg REDEFINITION.
    METHODS: has_errors REDEFINITION.
    METHODS: has_info REDEFINITION.
    METHODS: has_warnings REDEFINITION.
    METHODS: is_empty REDEFINITION.
    METHODS: save REDEFINITION.


    METHODS constructor
      IMPORTING
        VALUE(i_object)    TYPE csequence
        VALUE(i_subobject) TYPE csequence
        !i_if_log_strategy TYPE REF TO zif_log_strategy OPTIONAL
      RAISING
        cx_static_check .
    METHODS get_ms_log_header
      RETURNING
        VALUE(r_result) TYPE ty_log_header .
    METHODS get_mr_log_handle
      RETURNING
        VALUE(r_result) TYPE ty_log_handle .
    METHODS get_mv_log_number
      RETURNING
        VALUE(r_result) TYPE ty_log_number .
  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: ms_log_header TYPE ty_log_header.
    DATA: mr_log_handle TYPE ty_log_handle.
    DATA: mv_log_number TYPE ty_log_number.

ENDCLASS.



CLASS ZCL_SLG1_LOGGER IMPLEMENTATION.


  METHOD add_msg.
*We can test now based on the injected interface-strategy
    me->mo_log_strategy->add_msg(
    ir_log_handle  = me->mr_log_handle
    i_log_level = i_log_level
    i_text      = i_text
     ).

   ro_log = me.

  ENDMETHOD.


  METHOD add_sy_msg.
*We can test now based on the injected interface-strategy
    me->mo_log_strategy->add_sy_msg(
    ir_log_handle  = me->mr_log_handle
    i_log_level = i_log_level ).

    ro_log = me.
  ENDMETHOD.


  METHOD constructor.
    super->constructor(
                   COND #( WHEN i_if_log_strategy IS BOUND THEN i_if_log_strategy
                   ELSE NEW zcl_default_log_strategy( ) )
    ).
    ms_log_header-object = COND #( WHEN i_object IS NOT INITIAL THEN i_object
                                      ELSE THROW lcx_missing_parameter(  ) ).
    ms_log_header-subobject = COND #( WHEN i_subobject IS NOT INITIAL THEN i_subobject ).


* Now call the create log method
*   BEGIN- SEAM
*    mo_log_strategy = cond #( when i_if_log_strategy is bound then i_if_log_strategy
*                                         else new zcl_default_log_strategy( ) ) .

*BEGIN-SEAM
* Now create the Log!
    mr_log_handle = me->mo_log_strategy->create_log(
     CHANGING
        c_log_header = ms_log_header
    ).
*END-SEAM

  ENDMETHOD.


  METHOD get_mr_log_handle.
    r_result = me->mr_log_handle.
  ENDMETHOD.


  METHOD get_ms_log_header.
    r_result = me->ms_log_header.
  ENDMETHOD.


  METHOD get_mv_log_number.
    r_result = me->mv_log_number.
  ENDMETHOD.


  METHOD has_errors.

  ENDMETHOD.


  METHOD has_info.

  ENDMETHOD.


  METHOD has_warnings.

  ENDMETHOD.


  METHOD is_empty.

  ENDMETHOD.


  METHOD save.

  ENDMETHOD.
ENDCLASS.
