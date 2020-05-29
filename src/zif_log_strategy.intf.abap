interface zif_log_strategy
  public .

  methods: create_log  changing  c_log_header        type zcl_abstract_logger=>ty_log_header
                       returning value(r_log_handle) type zcl_abstract_logger=>ty_log_handle.


  methods: add_sy_msg  importing ir_log_handle type zcl_abstract_logger=>ty_log_handle
                          i_log_level     type zcl_abstract_logger=>ty_log_level
                  returning value(ro_log) type ref to zcl_abstract_logger.

  methods: add_msg  importing ir_log_handle type zcl_abstract_logger=>ty_log_handle
                          i_log_level   type zcl_abstract_logger=>ty_log_level
                          i_text     type c
                returning value(ro_log) type ref to zcl_abstract_logger.


  METHODS:display_log importing ir_log_handle type zcl_abstract_logger=>ty_log_handle.
  methods search_log_exists  importing i_log_filter           type bal_s_lfil
                             returning
                                       value(r_found_headers) type balhdr_t.

endinterface.
