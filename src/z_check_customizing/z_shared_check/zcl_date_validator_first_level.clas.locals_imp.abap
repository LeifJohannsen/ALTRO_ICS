*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_abap_behv_msg implementation.

method constructor.
  call method super->constructor exporting previous = previous.
  me->msgty = msgty .
  me->msgv1 = msgv1 .
  me->msgv2 = msgv2 .
  me->msgv3 = msgv3 .
  me->msgv4 = msgv4 .
  clear me->textid.
  if textid is initial.
    if_t100_message~t100key = if_t100_message=>default_textid.
  else.
    if_t100_message~t100key = textid.
  endif.
endmethod.

endclass.
