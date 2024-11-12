CLASS zcl_draft_enabled_actions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_draft_enabled_actions IMPLEMENTATION.

    METHOD if_sadl_exit_calc_element_read~calculate.

        LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).

        READ TABLE ct_calculated_data INDEX sy-tabix ASSIGNING FIELD-SYMBOL(<fs_calculated_data>).

        ASSIGN COMPONENT 'Z_Is_Active_Entity' OF STRUCTURE <fs_calculated_data> TO FIELD-SYMBOL(<fs_c_isActiveEntity>).
        ASSIGN COMPONENT 'IsActiveEntity' OF STRUCTURE <fs_original_data> TO FIELD-SYMBOL(<fs_i_isActiveEntity>).

        CASE <fs_i_isActiveEntity>.
            WHEN 'X'.
                <fs_c_isActiveEntity> = abap_true.
            WHEN ' '.
                <fs_c_isActiveEntity> = abap_true.
        ENDCASE.

    ENDLOOP.

    ENDMETHOD.

    METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    ENDMETHOD.

ENDCLASS.
