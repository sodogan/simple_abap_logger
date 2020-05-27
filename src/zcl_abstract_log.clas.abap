class zcl_abstract_log definition
  public
  final
  create public .

  public section.

    interfaces zif_log.
    aliases: ty_log_handle for zif_log~ty_log_handle,
             ty_log_number for zif_log~ty_log_number,
             ty_log_header for zif_log~ty_log_header.

    methods:constructor importing value(i_object)    type  csequence
                                  value(i_subobject) type  csequence
                                  i_if_log_strategy  type ref to zif_log_strategy optional
                        raising   cx_static_check
                        ,
      get_ms_log_header returning value(r_result) type ty_log_header,
      get_mr_log_handle returning value(r_result) type ty_log_handle,
      get_mv_log_number returning value(r_result) type ty_log_number.
    aliases:
    add_msg for zif_log~add_msg,
    add_sy_msg for zif_log~add_sy_msg,
    has_errors for zif_log~has_errors,
    has_warnings for zif_log~has_warnings,
    has_info for zif_log~has_info,
    is_empty for zif_log~is_empty,
    save for zif_log~save
    .
  protected section.
    data: ms_log_header type ty_log_header.
    data: mr_log_handle type ty_log_handle.
    data: mv_log_number type ty_log_number.

  private section.
    data: mo_log_strategy type ref to zif_log_strategy.
ENDCLASS.



CLASS ZCL_ABSTRACT_LOG IMPLEMENTATION.


  method constructor.
    me->ms_log_header-object = cond #( when i_object is not initial then i_object
                                      else throw lcx_missing_parameter(  ) ).
    me->ms_log_header-subobject = cond #( when i_subobject is not initial then i_subobject ).


* Now call the create log method
*   BEGIN- SEAM
    me->mo_log_strategy = cond #( when i_if_log_strategy is bound then i_if_log_strategy
                                         else new zcl_default_log_strategy( ) ) .

*BEGIN-SEAM
* Now create the Log!
    mr_log_handle = me->mo_log_strategy->create_log(
     changing
        c_log_header = ms_log_header
    ).
*END-SEAM

  endmethod.


  method get_mr_log_handle.
    r_result = me->mr_log_handle.
  endmethod.


  method get_ms_log_header.
    r_result = me->ms_log_header.
  endmethod.


  method get_mv_log_number.
    r_result = me->mv_log_number.
  endmethod.


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
