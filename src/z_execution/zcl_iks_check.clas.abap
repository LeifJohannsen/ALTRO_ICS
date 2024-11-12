CLASS zcl_iks_check DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS CONSTRUCTOR
        IMPORTING
            check_key    TYPE sysuuid_x16
            pernr        TYPE n
            infotype     TYPE c
            infotypeData TYPE REF TO DATA.

    METHODS execute.

  PROTECTED SECTION.
    DATA: check_key TYPE sysuuid_x16,
          pernr     TYPE n LENGTH 8,
          infotype  TYPE c LENGTH 4.

    DATA: infotypeData TYPE REF TO DATA.

  PRIVATE SECTION.
    METHODS set_infotypeData
        IMPORTING
            infotypeData TYPE REF TO DATA.

    METHODS set_check_key
        IMPORTING
            check_key TYPE sysuuid_x16.

    METHODS set_pernr
        IMPORTING
            pernr TYPE n.

    METHODS set_infotype
        IMPORTING
            infotype TYPE c.
ENDCLASS.



CLASS ZCL_IKS_CHECK IMPLEMENTATION.


    METHOD set_infotype.
        me->infotype = infotype.
    ENDMETHOD.


    METHOD set_pernr.
        me->pernr = pernr.
    ENDMETHOD.


    METHOD set_infotypeData.

        me->infotypeData = infotypeData.

    ENDMETHOD.


    METHOD execute.
        "Do something
    ENDMETHOD.


    METHOD CONSTRUCTOR.
        "create something
        me->set_check_key( check_key = check_key ).
        me->set_pernr( pernr = pernr ).
        me->set_infotype( infotype = infotype ).
        me->set_infotypedata(  infotypedata = infotypedata ).
    ENDMETHOD.


    METHOD set_check_key.
        me->check_key = check_key.
    ENDMETHOD.
ENDCLASS.
