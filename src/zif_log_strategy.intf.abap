interface zif_log_strategy
  public .

  methods: create_log  changing  c_log_header        type zif_log=>ty_log_header
                       returning value(r_log_handle) type zif_log=>ty_log_handle.
  .

  methods search_log_exists  importing i_log_filter         type bal_s_lfil
                             returning
                                       value(found_headers) type balhdr_t.

endinterface.
