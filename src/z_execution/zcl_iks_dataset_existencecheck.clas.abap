CLASS zcl_iks_dataset_existencecheck DEFINITION INHERITING FROM zcl_iks_check
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS execute REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_IKS_DATASET_EXISTENCECHECK IMPLEMENTATION.


    METHOD execute.

*       DATA: lo_datasetservice TYPE REF TO zcl_rap_infotype_structure,
*             lo_structure_description TYPE REF TO CL_ABAP_STRUCTDESCR,
*             lo_dataref    TYPE REF TO data.
*
*         FIELD-SYMBOLS: <ls_infotypeData> TYPE any.
*
*        CREATE OBJECT lo_datasetservice.
*
*        "Get entityset
*        lo_structure_description = lo_datasetservice->GET_INFOTYPE_STRUCTURE( infotype = me->infotype
*                                                                              language = sy-langu ).
*
*        CREATE DATA lo_dataref TYPE HANDLE lo_structure_description.
*        ASSIGN lo_dataref->* TO <ls_infotypeData>.
*
*        lo_datasetservice->GET_INFOTYPE_DATA( EXPORTING
*                                                infotype = me->infotype
*                                                pernr    = me->pernr
*                                              IMPORTING
*                                                infotypedata = <ls_infotypeData> ).

       FIELD-SYMBOLS: <ls_infotypeData> TYPE any.
       ASSIGN me->infotypedata->* TO <ls_infotypeData>.

       Data: lv_found_something TYPE abap_bool VALUE abap_false,
             ls_data_existance TYPE zics_data_exist,
             lv_checktype TYPE z_check_type_id,
             lv_findingId TYPE z_finding_id.

       SELECT SINGLE * FROM zics_data_exist WHERE mykey = @me->check_key INTO @ls_data_existance.

       CASE ls_data_existance-checktype. "lv_checktype.
        WHEN 1. "Infotyp muss vorhanden sein
            If <ls_infotypeData> IS NOT ASSIGNED.
                lv_found_something = abap_true.
            ENDIF.
        WHEN 2. "Infotyp darf nicht vorhanden sein
            If <ls_infotypeData> IS ASSIGNED.
                lv_found_something = abap_true.
            ENDIF.
        WHEN OTHERS.
            "impossible
       ENDCASE.

       IF lv_found_something = abap_false.
            EXIT.
       ENDIF.

       "@TODO: Write finding to protocol
       DATA: ls_protocol TYPE zics_protocols,
             l_uuid_x16 TYPE sysuuid_x16.
       try.
            ls_protocol-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
       catch cx_uuid_error into data(lo_x).
            "message lo_x->get_text( ) type 'E'.
       endtry.

       "@TODO: get organizational data
       "@TODO: Ist dieser Sachverhalt bereits vorhanden?

       ls_protocol-client = sy-mandt.
       ls_protocol-employeeid = me->pernr.
       "ls_protocol-firstname = <ls_org_data>-VORN.
       "ls_protocol-firstname = <ls_org_data>-NACHN.
       "ls_protocol-employee_subgroup = <ls_org_data>-persk.
       ls_protocol-findingid = ls_data_existance-findingid.
       ls_protocol-findingkey = me->check_key.
       ls_protocol-furtherinformation = 'This is a test.'.
       "@TODO: Unterscheidung zwischen last change und created treffen
       GET TIME STAMP FIELD DATA(ts).
       ls_protocol-last_changed_at = ts.
       ls_protocol-created_at = ts.
       ls_protocol-last_changed_by = sy-uname.
       ls_protocol-created_by = sy-uname.

       INSERT zics_protocols FROM @ls_protocol.

       "@TODO: History entry schreiben

       CLEAR: ls_protocol.

    ENDMETHOD.
ENDCLASS.
