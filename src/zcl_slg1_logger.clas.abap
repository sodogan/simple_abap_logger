class ZCL_SLG1_LOGGER definition
  public
  final
  create public INHERITING FROM zcl_abstract_logger.

public section.

*  interfaces ZIF_LOG .

  METHODS: ADD_MSG REDEFINITION.
  methods: ADD_SY_MSG REDEFINITION.
  methods: HAS_ERRORS REDEFINITION.
  methods: HAS_INFO REDEFINITION.
  methods: HAS_WARNINGS REDEFINITION.
  methods: IS_EMPTY REDEFINITION.
  methods: SAVE REDEFINITION.


  methods CONSTRUCTOR
    importing
      value(I_OBJECT) type CSEQUENCE
      value(I_SUBOBJECT) type CSEQUENCE
      !I_IF_LOG_STRATEGY type ref to ZIF_LOG_STRATEGY optional
    raising
      CX_STATIC_CHECK .
  methods GET_MS_LOG_HEADER
    returning
      value(R_RESULT) type TY_LOG_HEADER .
  methods GET_MR_LOG_HANDLE
    returning
      value(R_RESULT) type TY_LOG_HANDLE .
  methods GET_MV_LOG_NUMBER
    returning
      value(R_RESULT) type TY_LOG_NUMBER .
  protected section.
    data: ms_log_header type ty_log_header.
    data: mr_log_handle type ty_log_handle.
    data: mv_log_number type ty_log_number.

  private section.
ENDCLASS.



CLASS ZCL_SLG1_LOGGER IMPLEMENTATION.


 method add_msg.
*We can test now based on the injected interface-strategy
    me->mo_log_strategy->add_msg(
    ir_log_handle  = me->mr_log_handle
    i_log_level = i_log_level
    i_text      = i_text
     ).


  endmethod.


  method add_sy_msg.
*We can test now based on the injected interface-strategy
    me->mo_log_strategy->add_sy_msg(
    ir_log_handle  = me->mr_log_handle
    i_log_level = i_log_level ).


  endmethod.


  method CONSTRUCTOR.
    super->constructor(
                   cond #( when i_if_log_strategy is bound then i_if_log_strategy
                   else new zcl_default_log_strategy( ) )
    ).
    ms_log_header-object = cond #( when i_object is not initial then i_object
                                      else throw lcx_missing_parameter(  ) ).
    ms_log_header-subobject = cond #( when i_subobject is not initial then i_subobject ).


* Now call the create log method
*   BEGIN- SEAM
*    mo_log_strategy = cond #( when i_if_log_strategy is bound then i_if_log_strategy
*                                         else new zcl_default_log_strategy( ) ) .

*BEGIN-SEAM
* Now create the Log!
    mr_log_handle = me->mo_log_strategy->create_log(
     changing
        c_log_header = ms_log_header
    ).
*END-SEAM

  endmethod.


  method GET_MR_LOG_HANDLE.
    r_result = me->mr_log_handle.
  endmethod.


  method GET_MS_LOG_HEADER.
    r_result = me->ms_log_header.
  endmethod.


  method GET_MV_LOG_NUMBER.
    r_result = me->mv_log_number.
  endmethod.


  method has_errors.

  endmethod.


  method has_info.

  endmethod.


  method has_warnings.

  endmethod.


  method is_empty.

  endmethod.


  method save.

  endmethod.
ENDCLASS.
