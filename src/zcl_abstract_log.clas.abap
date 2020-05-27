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
                        raising   cx_static_check
                        ,
      get_ms_log_header returning value(r_result) type ty_log_header,
      get_mr_log_handle returning value(r_result) type ty_log_handle,
      get_mv_log_number returning value(r_result) type ty_log_number.

  protected section.
    data: ms_log_header type ty_log_header.
    data: mr_log_handle type ty_log_handle.
    data: mv_log_number type ty_log_number.

  private section.
    methods: create_log importing i_if_log_creator type ref to lif_log_creator optional.
ENDCLASS.



CLASS ZCL_ABSTRACT_LOG IMPLEMENTATION.


  method constructor.
    me->ms_log_header-object = cond #( when i_object is not initial then i_object
                                      else throw lcx_missing_parameter(  )
    ).
    me->ms_log_header-subobject = cond #( when i_subobject is not initial then i_subobject ).


* Now call the create log method
    create_log( ).

  endmethod.


  method create_log.
*   BEGIN- SEAM
    data(lo_log_creator) = cond #( when i_if_log_creator is bound then i_if_log_creator
                                        else new lcl_log_creator( )
     ) .

* Now create the Log!
    i_if_log_creator->create_log(
      exporting
        is_log_header = ms_log_header
      importing
        er_log_handle = mr_log_handle
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


  method zif_log~add.
*How to test!!
    call function 'BAL_LOG_CREATE'
      exporting
        i_s_log      = ms_log_header
      importing
        e_log_handle = mr_log_handle.

* BAL_LOG_CREATE will fill in some additional header data.
* This FM updates our instance attribute to reflect that.
    call function 'BAL_LOG_HDR_READ'
      exporting
        i_log_handle = mr_log_handle
      importing
        e_s_log      = ms_log_header.


  endmethod.


  method zif_log~has_errors.

  endmethod.


  method zif_log~has_info.

  endmethod.


  method zif_log~has_warnings.

  endmethod.


  method zif_log~is_empty.

  endmethod.


  method zif_log~save.

  endmethod.
ENDCLASS.
