*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
class lcl_abap_behv_msg definition create public inheriting from cx_no_check.
  public section.

  interfaces IF_ABAP_BEHV_MESSAGE .

  aliases MSGTY
    for IF_T100_DYN_MSG~MSGTY .
  aliases MSGV1
    for IF_T100_DYN_MSG~MSGV1 .
  aliases MSGV2
    for IF_T100_DYN_MSG~MSGV2 .
  aliases MSGV3
    for IF_T100_DYN_MSG~MSGV3 .
  aliases MSGV4
    for IF_T100_DYN_MSG~MSGV4 .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MSGTY type symsgty optional
      !MSGV1 type simple optional
      !MSGV2 type simple optional
      !MSGV3 type simple optional
      !MSGV4 type simple optional .

endclass.
