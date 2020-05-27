class zlog_level definition
  public
  final
  create public .

  public section.
    class-methods: class_constructor.
    methods: constructor.
    class-data: error type ref to zlog_level read-only.
    class-data: warning type ref to zlog_level read-only.
    class-data: info type ref to zlog_level read-only.
  protected section.
  private section.
endclass.



class zlog_level implementation.

  method class_constructor.
    error = new #(  ).
    warning = new #(  ).
    info  = new #(  ).
  endmethod.


  method constructor.
  endmethod.

endclass.
