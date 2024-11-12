CLASS zcl_perform_iks_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.

    TYPES ty_abkrs TYPE c LENGTH 2.
    TYPES ty_range_abkrs TYPE RANGE OF ty_abkrs.
    TYPES ty_bukrs TYPE c LENGTH 4.
    TYPES ty_range_bukrs TYPE RANGE OF ty_bukrs.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PERFORM_IKS_CHECK IMPLEMENTATION.


METHOD if_apj_dt_exec_object~get_parameters.

    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'S_ABKRS' kind = if_apj_dt_exec_object=>select_option datatype = 'C' length = 2  param_text = 'Payroll Subunit'                            changeable_ind = abap_true )
      ( selname = 'S_BUKRS' kind = if_apj_dt_exec_object=>select_option datatype = 'C' length = 4  param_text = 'Company Code'                               changeable_ind = abap_true )
      ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1  param_text = 'My Simulate Only' checkbox_ind = abap_true  changeable_ind = abap_true )
    ).

    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'S_ABKRS' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'EQ' low = '' )
      ( selname = 'S_BUKRS' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'EQ' low = '' )
      ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
    ).

ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA s_abkrs    TYPE zcl_perform_iks_check=>ty_range_abkrs .
    DATA s_bukrs    TYPE zcl_perform_iks_check=>ty_range_bukrs.
    DATA p_simul    TYPE abap_boolean.

    DATA: jobname   type cl_apj_rt_api=>TY_JOBNAME.
    DATA: jobcount  type cl_apj_rt_api=>TY_JOBCOUNT.
    DATA: catalog   type cl_apj_rt_api=>TY_CATALOG_NAME.
    DATA: template  type cl_apj_rt_api=>TY_TEMPLATE_NAME.

    " Getting the actual parameter values
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_ABKRS'.
          APPEND VALUE #( sign   = ls_parameter-sign
                          option = ls_parameter-option
                          low    = ls_parameter-low
                          high   = ls_parameter-high ) TO s_abkrs.
        WHEN 'S_BUKRS'.
          APPEND VALUE #( sign   = ls_parameter-sign
                          option = ls_parameter-option
                          low    = ls_parameter-low
                          high   = ls_parameter-high ) TO s_bukrs.
        WHEN 'P_SIMUL'. p_simul = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    try.
* read own runtime info catalog
       cl_apj_rt_api=>GET_JOB_RUNTIME_INFO(
                        importing
                          ev_jobname        = jobname
                          ev_jobcount       = jobcount
                          ev_catalog_name   = catalog
                          ev_template_name  = template ).

       catch cx_apj_rt.

    endtry.

    "Implement the job execution
    zcl_iks_caller=>perform_iks_checks( IM_ABKRS = s_abkrs
                                        IM_BUKRS = s_bukrs ).


  ENDMETHOD.
ENDCLASS.
