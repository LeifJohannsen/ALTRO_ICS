
CLASS lhc_finding DEFINITION INHERITING FROM cl_abap_behavior_handler.

    PRIVATE SECTION.
        METHODS get_features FOR INSTANCE FEATURES
            IMPORTING keys REQUEST requested_features FOR protocols RESULT result.

        METHODS set_status_in_progress FOR MODIFY
            IMPORTING keys FOR ACTION protocols~setStatusInProgress RESULT result.

        METHODS setstatusopen FOR MODIFY
          IMPORTING keys FOR ACTION protocols~setstatusopen RESULT result.

        METHODS setstatusdone FOR MODIFY
          IMPORTING keys FOR ACTION protocols~setStatusDone RESULT result.

        METHODS setresponsibleclerk FOR MODIFY
          IMPORTING keys FOR ACTION protocols~setresponsibleclerk RESULT result.

ENDCLASS.

CLASS lhc_finding IMPLEMENTATION.

    METHOD get_features.
        READ ENTITIES OF zi_protocols IN LOCAL MODE
               ENTITY protocols FROM VALUE #( FOR keyval IN keys
                                                      (  %key                     = keyval-%key
                                                         %control-FindingStatusID = if_abap_behv=>mk-on
                                                        ) )
                                RESULT DATA(lt_findings_result).

        result = VALUE #( FOR ls_finding IN lt_findings_result
                          ( %key                           = ls_finding-%key
                            %features-%action-setStatusInProgress = COND #( WHEN ls_finding-FindingStatusID = '01' " 'In progress'
                                                                        THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                            %features-%action-setStatusOpen = COND #( WHEN ls_finding-FindingStatusID = '00' " 'Open'
                                                                        THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                            %features-%action-setStatusDone = COND #( WHEN ls_finding-FindingStatusID = '04' " 'In progress'
                                                                        THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                            %features-%action-setResponsibleClerk = if_abap_behv=>fc-o-enabled
                          ) ).

    ENDMETHOD.

    METHOD set_status_in_progress.

        "Insert new History entry

        GET TIME STAMP FIELD DATA(lv_changetime).
        DATA(system_uuid) = cl_uuid_factory=>create_system_uuid( ).

        TRY.

            MODIFY ENTITY zi_protocols
                  CREATE BY \_HistoryEntry
                  FROM VALUE #( FOR key IN keys (
                                  mykey = key-mykey
                                  %target = VALUE #( (
                                                      mykey = system_uuid->create_uuid_x16( )
                                                      %cid = key-mykey
                                                      findingid =  key-mykey
                                                      status = '01'
                                                      validfrom = sy-datum
                                                      validto = '99991231'
                                                      responsibleclerk = sy-uname
                                                      note = 'Finding-status changed to ''in progress'''
                                                      created_at = lv_changetime
                                                      created_by = sy-uname
                                                      last_changeD_at = lv_changetime
                                                      last_Changed_by = sy-uname
                                                      %control =  VALUE #(
                                                                          mykey = if_abap_behv=>mk-on
                                                                          findingid =  if_abap_behv=>mk-on
                                                                          status = if_abap_behv=>mk-on
                                                                          validfrom = if_abap_behv=>mk-on
                                                                          validto = if_abap_behv=>mk-on
                                                                          responsibleclerk = if_abap_behv=>mk-on
                                                                          note = if_abap_behv=>mk-on
                                                                          created_at = if_abap_behv=>mk-on
                                                                          created_by = if_abap_behv=>mk-on
                                                                          last_changeD_at = if_abap_behv=>mk-on
                                                                          last_Changed_by = if_abap_behv=>mk-on
                                                                         )
                                                   ) )
                              ) )
                  MAPPED Data(ls_mapped)
                  FAILED Data(failed1)
                  REPORTED DATA(reported1).
         CATCH cx_uuid_error.
         ENDTRY.
         "MODIFY FIELD "LastChangeID" FROM Parent-Finding-Entry
         MODIFY ENTITIES OF zi_protocols IN LOCAL MODE
                ENTITY protocols
                   UPDATE FROM VALUE #( FOR history_entry IN ls_mapped-historyentry (
                                           mykey = history_entry-%cid              "Protocols key
                                           lastchangeid = history_entry-mykey      "History key
                                           last_changed_at = lv_changetime
                                           last_changed_by = sy-uname
                                           %control-lastchangeid = if_abap_behv=>mk-on
                                           %control-last_changed_at = if_abap_behv=>mk-on
                                           %control-last_changed_by = if_abap_behv=>mk-on
                                         )
                                      )
                FAILED   failed
                REPORTED reported.
          " Read changed data for action result
          READ ENTITIES OF zi_protocols IN LOCAL MODE
              ENTITY protocols
              FROM VALUE #( FOR key IN keys (  mykey = key-mykey
                                               %control = VALUE #(
                                                               FindingStatusID    = if_abap_behv=>mk-on
                                                               last_changed_at    = if_abap_behv=>mk-on
                                                               last_changed_by    = if_abap_behv=>mk-on
                                                                 )
                                            )
                          )
              RESULT DATA(lt_findings).

         result = VALUE #( FOR finding IN lt_findings ( mykey     = finding-mykey
                                                         %param    = finding
                                                      )
                         ).

    ENDMETHOD.

  METHOD setStatusOpen.

  "Insert new History entry

        GET TIME STAMP FIELD DATA(lv_changetime).
        DATA(system_uuid) = cl_uuid_factory=>create_system_uuid( ).

        TRY.

            MODIFY ENTITY zi_protocols
                  CREATE BY \_HistoryEntry
                  FROM VALUE #( FOR key IN keys (
                                  mykey = key-mykey
                                  %target = VALUE #( (
                                                      mykey = system_uuid->create_uuid_x16( )
                                                      %cid = key-mykey
                                                      findingid =  key-mykey
                                                      status = '00'
                                                      validfrom = sy-datum
                                                      validto = '99991231'
                                                      responsibleclerk = sy-uname
                                                      note = 'Finding-status changed to ''open'''
                                                      created_at = lv_changetime
                                                      created_by = sy-uname
                                                      last_changeD_at = lv_changetime
                                                      last_Changed_by = sy-uname
                                                      %control =  VALUE #(
                                                                          mykey = if_abap_behv=>mk-on
                                                                          findingid =  if_abap_behv=>mk-on
                                                                          status = if_abap_behv=>mk-on
                                                                          validfrom = if_abap_behv=>mk-on
                                                                          validto = if_abap_behv=>mk-on
                                                                          responsibleclerk = if_abap_behv=>mk-on
                                                                          note = if_abap_behv=>mk-on
                                                                          created_at = if_abap_behv=>mk-on
                                                                          created_by = if_abap_behv=>mk-on
                                                                          last_changeD_at = if_abap_behv=>mk-on
                                                                          last_Changed_by = if_abap_behv=>mk-on
                                                                         )
                                                   ) )
                              ) )
                  MAPPED Data(ls_mapped)
                  FAILED Data(failed1)
                  REPORTED DATA(reported1).
         CATCH cx_uuid_error.
         ENDTRY.
         "MODIFY FIELD "LastChangeID" FROM Parent-Finding-Entry
         MODIFY ENTITIES OF zi_protocols IN LOCAL MODE
                ENTITY protocols
                   UPDATE FROM VALUE #( FOR history_entry IN ls_mapped-historyentry (
                                           mykey = history_entry-%cid              "Protocols key
                                           lastchangeid = history_entry-mykey      "History key
                                           last_changed_at = lv_changetime
                                           last_changed_by = sy-uname
                                           %control-lastchangeid = if_abap_behv=>mk-on
                                           %control-last_changed_at = if_abap_behv=>mk-on
                                           %control-last_changed_by = if_abap_behv=>mk-on
                                         )
                                      )
                FAILED   failed
                REPORTED reported.
          " Read changed data for action result
          READ ENTITIES OF zi_protocols IN LOCAL MODE
              ENTITY protocols
              FROM VALUE #( FOR key IN keys (  mykey = key-mykey
                                               %control = VALUE #(
                                                               FindingStatusID    = if_abap_behv=>mk-on
                                                               last_changed_at    = if_abap_behv=>mk-on
                                                               last_changed_by    = if_abap_behv=>mk-on
                                                                 )
                                            )
                          )
              RESULT DATA(lt_findings).

         result = VALUE #( FOR finding IN lt_findings ( mykey     = finding-mykey
                                                         %param    = finding
                                                      )
                         ).

  ENDMETHOD.

  METHOD setStatusDone.

  "Insert new History entry

        GET TIME STAMP FIELD DATA(lv_changetime).
        DATA(system_uuid) = cl_uuid_factory=>create_system_uuid( ).

        TRY.

            MODIFY ENTITY zi_protocols
                  CREATE BY \_HistoryEntry
                  FROM VALUE #( FOR key IN keys (
                                  mykey = key-mykey
                                  %target = VALUE #( (
                                                      mykey = system_uuid->create_uuid_x16( )
                                                      %cid = key-mykey
                                                      findingid =  key-mykey
                                                      status = '04'
                                                      validfrom = sy-datum
                                                      validto = '99991231'
                                                      responsibleclerk = sy-uname
                                                      note = 'Finding-status changed to ''done'''
                                                      created_at = lv_changetime
                                                      created_by = sy-uname
                                                      last_changeD_at = lv_changetime
                                                      last_Changed_by = sy-uname
                                                      %control =  VALUE #(
                                                                          mykey = if_abap_behv=>mk-on
                                                                          findingid =  if_abap_behv=>mk-on
                                                                          status = if_abap_behv=>mk-on
                                                                          validfrom = if_abap_behv=>mk-on
                                                                          validto = if_abap_behv=>mk-on
                                                                          responsibleclerk = if_abap_behv=>mk-on
                                                                          note = if_abap_behv=>mk-on
                                                                          created_at = if_abap_behv=>mk-on
                                                                          created_by = if_abap_behv=>mk-on
                                                                          last_changeD_at = if_abap_behv=>mk-on
                                                                          last_Changed_by = if_abap_behv=>mk-on
                                                                         )
                                                   ) )
                              ) )
                  MAPPED Data(ls_mapped)
                  FAILED Data(failed1)
                  REPORTED DATA(reported1).
         CATCH cx_uuid_error.
         ENDTRY.
         "MODIFY FIELD "LastChangeID" FROM Parent-Finding-Entry
         MODIFY ENTITIES OF zi_protocols IN LOCAL MODE
                ENTITY protocols
                   UPDATE FROM VALUE #( FOR history_entry IN ls_mapped-historyentry (
                                           mykey = history_entry-%cid              "Protocols key
                                           lastchangeid = history_entry-mykey      "History key
                                           last_changed_at = lv_changetime
                                           last_changed_by = sy-uname
                                           %control-lastchangeid = if_abap_behv=>mk-on
                                           %control-last_changed_at = if_abap_behv=>mk-on
                                           %control-last_changed_by = if_abap_behv=>mk-on
                                         )
                                      )
                FAILED   failed
                REPORTED reported.
          " Read changed data for action result
          READ ENTITIES OF zi_protocols IN LOCAL MODE
              ENTITY protocols
              FROM VALUE #( FOR key IN keys (  mykey = key-mykey
                                               %control = VALUE #(
                                                               FindingStatusID    = if_abap_behv=>mk-on
                                                               last_changed_at    = if_abap_behv=>mk-on
                                                               last_changed_by    = if_abap_behv=>mk-on
                                                                 )
                                            )
                          )
              RESULT DATA(lt_findings).

         result = VALUE #( FOR finding IN lt_findings ( mykey     = finding-mykey
                                                         %param    = finding
                                                      )
                         ).

  ENDMETHOD.

  METHOD setResponsibleClerk.

    READ ENTITIES OF zi_protocols IN LOCAL MODE
        ENTITY protocols
        FROM VALUE #( FOR key IN keys
                        ( mykey = key-mykey
                          %control-lastchangeid = if_abap_behv=>mk-on
                        )
                    )
        RESULT DATA(finding_entries).

    LOOP AT finding_entries INTO Data(finding_entry).
        READ ENTITY ZI_ICS_FINDING_History
            ALL FIELDS WITH VALUE #( ( mykey = finding_entry-lastchangeid ) )
            RESULT FINAL(history_entries).
    ENDLOOP.

    GET TIME STAMP FIELD DATA(lv_changetime).
    DATA(system_uuid) = cl_uuid_factory=>create_system_uuid( ).

    TRY.

        MODIFY ENTITY zi_protocols
              CREATE BY \_HistoryEntry
              FROM VALUE #( FOR key IN keys (
                              mykey = key-mykey
                              %target = VALUE #( (
                                                  mykey = system_uuid->create_uuid_x16( )
                                                  %cid = key-mykey
                                                  findingid =  key-mykey
                                                  status = history_entries[ 1 ]-status
                                                  validfrom = sy-datum
                                                  validto = '99991231'
                                                  responsibleclerk = key-%param-new_responsible_clerk
                                                  note = key-%param-new_note
                                                  created_at = lv_changetime
                                                  created_by = sy-uname
                                                  last_changeD_at = lv_changetime
                                                  last_Changed_by = sy-uname
                                                  %control =  VALUE #(
                                                                      mykey = if_abap_behv=>mk-on
                                                                      findingid =  if_abap_behv=>mk-on
                                                                      status = if_abap_behv=>mk-on
                                                                      validfrom = if_abap_behv=>mk-on
                                                                      validto = if_abap_behv=>mk-on
                                                                      responsibleclerk = if_abap_behv=>mk-on
                                                                      note = if_abap_behv=>mk-on
                                                                      created_at = if_abap_behv=>mk-on
                                                                      created_by = if_abap_behv=>mk-on
                                                                      last_changeD_at = if_abap_behv=>mk-on
                                                                      last_Changed_by = if_abap_behv=>mk-on
                                                                     )
                                               ) )
                          ) )
              MAPPED Data(ls_mapped)
              FAILED Data(failed1)
              REPORTED DATA(reported1).

     CATCH cx_uuid_error.
        "@TODO: Implement Errorhandling
     ENDTRY.

     MODIFY ENTITIES OF zi_protocols IN LOCAL MODE
            ENTITY protocols
               UPDATE FROM VALUE #( FOR history_entry IN ls_mapped-historyentry (
                                       mykey = history_entry-%cid              "Protocols key
                                       lastchangeid = history_entry-mykey      "History key
                                       last_changed_at = lv_changetime
                                       last_changed_by = sy-uname
                                       %control-lastchangeid = if_abap_behv=>mk-on
                                       %control-last_changed_at = if_abap_behv=>mk-on
                                       %control-last_changed_by = if_abap_behv=>mk-on
                                     )
                                  )
            FAILED   failed
            REPORTED reported.

          " Read changed data for action result
          READ ENTITIES OF zi_protocols IN LOCAL MODE
               ENTITY protocols
               FROM VALUE #( FOR key IN keys (  mykey = key-mykey
                                                %control = VALUE #(
                                                  last_changed_at    = if_abap_behv=>mk-on
                                                  last_changed_by    = if_abap_behv=>mk-on
                                                  FindingStatusID    = if_abap_behv=>mk-on
                                                )
                                               )
                           )
               RESULT DATA(lt_findings).

          LOOP AT lt_findings INTO DATA(ls_finding).
            TRY.
                data(lo_mail) = cl_bcs_mail_message=>create_instance( ).
                lo_mail->set_sender( 'leifjellejohannsen@gmail.com' ).
                lo_mail->add_recipient( 'leif-jelle.johannsen@centric.eu' ). "@TODO: hier tatsächlich User-Email einsetzen
                "lo_mail->add_recipient( iv_address = 'recipient2@yourcompany.com' iv_copy = cl_bcs_mail_message=>cc ).
                lo_mail->set_subject( 'Test Mail' ).
                lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                  iv_content      = '<h1>Hello</h1><p>This is a test mail from FINDINGS ID: ' && ls_finding-mykey && '</p>'
                  iv_content_type = 'text/html'
                ) ).
                lo_mail->send( importing et_status = data(lt_status) ).
                "lo_mail->send_async( ).
            catch cx_bcs_mail into data(lx_mail).
                "handle exceptions
            ENDTRY.
          ENDLOOP.

          result = VALUE #( FOR finding IN lt_findings ( mykey     = finding-mykey
                                                         %param    = finding
                                                       )
                          ).

  ENDMETHOD.

ENDCLASS.
