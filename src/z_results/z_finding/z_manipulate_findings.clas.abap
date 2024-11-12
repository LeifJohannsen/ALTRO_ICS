CLASS Z_MANIPULATE_FINDINGS DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    CLASS-METHODS change_findings.
ENDCLASS.



CLASS Z_MANIPULATE_FINDINGS IMPLEMENTATION.


  METHOD change_findings.

    "Delete Findings from test-Class

    SELECT * FROM ZICS_PROTOCOLS
        WHERE firstname = 'Edward'
          AND lastname = 'Wasserkopf'
        INTO TABLE @DATA(lt_protocols).

    LOOP AT lt_protocols INTO DATA(ls_protocols).
        DELETE FROM zics_findinghist WHERE findingid = @ls_protocols-mykey.
    ENDLOOP.
    DELETE FROM ZICS_PROTOCOLS WHERE firstname = 'Edward' AND lastname = 'Wasserkopf'.

    "DELETE FROM zics_findinghist WHERE mykey = '3AED0293F5601EDF9BE9F894771CB367'.


    "@TODO: Write finding to protocol
*       DATA: ls_protocol TYPE zics_protocols,
*             l_uuid_x16 TYPE sysuuid_x16.
*
*       DATA: ls_protocol_hist TYPE zics_findinghist,
*             l_uuid_x16_hist TYPE sysuuid_x16.
*
*        "SELECT SINGLE * FROM zics_protocols WHERE MYKEY = '3AED0293F5601EEF9B8B222C45209BBA' INTO @ls_protocol.
*       try.
*            ls_protocol-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
*       catch cx_uuid_error into data(lo_x).
*            "message lo_x->get_text( ) type 'E'.
*       endtry.
*
*      try.
*            ls_protocol_hist-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
*       catch cx_uuid_error into data(lo_x_2).
*            "message lo_x->get_text( ) type 'E'.
*       endtry.
*
*       "@TODO: get organizational data
*       "@TODO: Ist dieser Sachverhalt bereits vorhanden?
*
*       ls_protocol-client = sy-mandt.
*       ls_protocol-employeeid = 10000030.
*       ls_protocol-firstname = 'Leonard'.
*       ls_protocol-lastname = 'Roberts'.
*       ls_protocol-employee_subgroup = 'DB'.
*       ls_protocol-employee_image_url =
*'https://media.istockphoto.com/id/1338134336/de/foto/headshot-portr%C3%A4t-afrikanischer-30er-jahre-mann-l%C3%A4cheln-blick-in-die-kamera.jpg?s=612x612&w=0&k=20&c=C3xrgNj_LuNR8j2sQHW0a8pKZVGN0Yr4wAu-mA3TYs0='.
*       "ls_protocol-employee_image_url = 'https://drive.usercontent.google.com/download?id=1AnrM8fjEps64O64GYvPxc_tZr8cR1jU9&authuser=0'.
*       "ls_protocol-employee_image_url = 'https://as2.ftcdn.net/v2/jpg/02/07/68/43/1000_F_207684339_dFUUI0leWvNaKJR6Da0ZswUhLI4YzIGT.jpg'.
*       ls_protocol-findingid = '0002'.
*       ls_protocol-findingkey = 'FA404551BC361EEE9B840A6D4E0959F8'.
*       ls_protocol-furtherinformation = ''.
*       ls_protocol-validfrom = '20240906'.
*       ls_protocol-validto = '20240929'.
*       ls_protocol-checkclass = 'DataExistenceCheck'.
*       ls_protocol-findingtypeid = '01'.
*       ls_protocol-lastchangeid = ls_protocol_hist-mykey.
*
*
*       "@TODO: Unterscheidung zwischen last change und created treffen
*       GET TIME STAMP FIELD DATA(ts).
*       ls_protocol-last_changed_at = ts.
*       ls_protocol-created_at = ts.
*       ls_protocol-last_changed_by = sy-uname.
*       ls_protocol-created_by = sy-uname.
*
*       "MODIFY zics_protocols FROM @ls_protocol.
*       INSERT zics_protocols FROM @ls_protocol.
*      "SELECT SINGLE * FROM zics_findinghist WHERE MYKEY = 'DAA87A4CE6501EEF9BCF92B9E747FBBD' INTO @ls_protocol_hist.
*
*       ls_protocol_hist-findingid = ls_protocol-mykey.
*       ls_protocol_hist-validfrom = '20240906'.
*       ls_protocol_hist-validto = '99991231'.
*       ls_protocol_hist-responsibleclerk = 'CB9980000001'.
*       ls_protocol_hist-status = '00'.
*       ls_protocol_hist-note = 'Finding initially created'.
*
*       GET TIME STAMP FIELD DATA(ts2).
*       ls_protocol_hist-last_changed_at = ts2.
*       ls_protocol_hist-created_at = ts2.
*       ls_protocol_hist-last_changed_by = sy-uname.
*       ls_protocol_hist-created_by = sy-uname.
*
*       "MODIFY zics_findinghist FROM @ls_protocol_hist.
*       INSERT zics_findinghist FROM @ls_protocol_hist.





*    SELECT * FROM zics_protocols WHERE mykey = '12345678900000000000000000000000' OR
*                                       mykey = '521C0C8406EF1EDEB39706B324371B75' INTO TABLE @lt_findings.
*
*
*    LOOP AT lt_findings INTO ls_finding.
*
*        DELETE FROM zics_findinghist WHERE findingid = @ls_finding-mykey.
*        DELETE FROM zics_protocols WHERE MYKEY = @ls_finding-mykey.
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    Z_MANIPULATE_FINDINGS=>change_findings(  ).
  ENDMETHOD.
ENDCLASS.
