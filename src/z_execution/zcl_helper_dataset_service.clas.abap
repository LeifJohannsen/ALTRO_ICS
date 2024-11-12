CLASS zcl_helper_dataset_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    CLASS-METHODS get_infotype_data
        IMPORTING
            pernr        TYPE c
            infotype     TYPE c
            destination_key TYPE sysuuid_x16
        CHANGING
            infotypeData TYPE REF TO DATA.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HELPER_DATASET_SERVICE IMPLEMENTATION.


    METHOD get_infotype_data.

        DATA: lo_datasetservice TYPE REF TO zcl_rap_infotype_structure,
              lo_structure_description TYPE REF TO CL_ABAP_STRUCTDESCR,
              lo_dataref    TYPE REF TO data.

        FIELD-SYMBOLS: <ls_infotypeData> TYPE any.

        CREATE OBJECT lo_datasetservice EXPORTING destination_key = destination_key.

        "Get entityset
        lo_structure_description = lo_datasetservice->GET_INFOTYPE_STRUCTURE( infotype = infotype
                                                                              language = sy-langu ).

        CREATE DATA lo_dataref TYPE HANDLE lo_structure_description.
        ASSIGN lo_dataref->* TO <ls_infotypeData>.

        lo_datasetservice->GET_INFOTYPE_DATA( EXPORTING
                                                infotype = infotype
                                                pernr    = pernr
                                              IMPORTING
                                                infotypedata = <ls_infotypeData> ).

        infotypeData = REF #( <ls_infotypeData> ).
    ENDMETHOD.
ENDCLASS.
