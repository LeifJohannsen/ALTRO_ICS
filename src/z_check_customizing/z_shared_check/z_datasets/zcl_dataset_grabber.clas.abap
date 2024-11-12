CLASS ZCL_DATASET_GRABBER DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_bgmc_op_single_tx_uncontr.

    TYPES ty_langu TYPE c LENGTH 1.

    TYPES ty_range_langu TYPE RANGE OF ty_langu.

    CLASS-METHODS GET_DATASETS_FOR_ALL_DEST
        IMPORTING
            s_languages TYPE ty_range_langu.

    CLASS-METHODS SCHEDULE_DATASET_GRABBER.
*        IMPORTING
*            s_languages TYPE ty_range_langu.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS GENERATE_ONPREM_DATASETS
        IMPORTING
            language        TYPE sy-langu
            destination_key TYPE sysuuid_x16.
ENDCLASS.



CLASS ZCL_DATASET_GRABBER IMPLEMENTATION.


  METHOD GET_DATASETS_FOR_ALL_DEST.

    SELECT * FROM ZDB_DESTINATION INTO TABLE @DATA(lt_destinations).

    LOOP AT lt_destinations INTO DATA(ls_destination).
        LOOP AT s_languages INTO DATA(ls_languages).
            CASE ls_destination-systemtype.
                WHEN '01'. "HCM
                    "@TODO: multiple languages at once
                    ZCL_DATASET_GRABBER=>GENERATE_ONPREM_DATASETS( language = ls_languages-low destination_key = ls_destination-id ).
                WHEN '02'. "SF
                    "not implemented.
*                    DATA: datasets TYPE TABLE OF zics_datasets,
*                          dataset LIKE LINE OF datasets,
*                          datasetTexts TYPE TABLE OF zics_datasetstxt,
*                          datasetText like line of datasetTexts.
*
*                    dataset-destination = ls_destination-id.
*                    dataset-dataset = 'EmpJob'.
*
*                    SELECT SINGLE * FROM zics_datasets WHERE destination = @ls_destination-id
*                                             AND dataset     = @dataset-dataset
*                                            INTO @DATA(Dummy).
*                    IF sy-subrc = 4.
*                        "Dataset not found --> Append
*                        APPEND dataset TO datasets.
*                    ENDIF.
*
*                    datasetText-destination = ls_destination-id.
*                    datasetText-dataset = 'EmpJob'.
*                    datasetText-language = ls_languages-low.
*                    datasetText-dataset_desc = 'Employee Job'.
*
*                    SELECT SINGLE * FROM zics_datasetstxt WHERE destination = @ls_destination-id
*                                                AND dataset     = @datasetText-dataset
*                                                AND language    = @datasetText-language
*                                               INTO @DATA(Dummy2).
*                    IF sy-subrc = 4.
*                        "DatasetText not found --> Append
*                        APPEND datasetText TO datasetTexts.
*                    ENDIF.
*
*                    INSERT zics_datasets FROM TABLE @datasets.
*                    INSERT zics_datasetstxt FROM TABLE @datasetTexts.
                WHEN OTHERS.
                    "not implemented.
            ENDCASE.
        ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_bgmc_op_single_tx_uncontr~execute.
    DATA: s_langu TYPE ty_range_langu.

    APPEND VALUE #( sign   = 'I'
                    option = 'EQ'
                    low    = 'D' ) TO s_langu.

    APPEND VALUE #( sign   = 'I'
                    option = 'EQ'
                    low    = 'E' ) TO s_langu.

    ZCL_DATASET_GRABBER=>GET_DATASETS_FOR_ALL_DEST( s_langu ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA s_langu    TYPE ZCL_DATASET_GRABBER=>ty_range_langu .

    DATA: jobname   type cl_apj_rt_api=>TY_JOBNAME.
    DATA: jobcount  type cl_apj_rt_api=>TY_JOBCOUNT.
    DATA: catalog   type cl_apj_rt_api=>TY_CATALOG_NAME.
    DATA: template  type cl_apj_rt_api=>TY_TEMPLATE_NAME.

    " Getting the actual parameter values
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_LANGU'.
          APPEND VALUE #( sign   = ls_parameter-sign
                          option = ls_parameter-option
                          low    = ls_parameter-low
                          high   = ls_parameter-high ) TO s_langu.
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

    ZCL_DATASET_GRABBER=>GET_DATASETS_FOR_ALL_DEST( s_langu ).

  ENDMETHOD.


  METHOD SCHEDULE_DATASET_GRABBER.


" https://help.sap.com/docs/ABAP_PLATFORM_NEW/b5670aaaa2364a29935f40b16499972d/1491e6c075c04e7c9a485a2e24b82653.html

    DATA lv_job_text TYPE cl_apj_rt_api=>ty_job_text VALUE 'DATASET_GRABBER'.

    DATA lv_template_name TYPE cl_apj_rt_api=>ty_template_name.

    DATA ls_start_info TYPE cl_apj_rt_api=>ty_start_info.
    DATA ls_scheduling_info TYPE cl_apj_rt_api=>ty_scheduling_info.
    DATA ls_end_info TYPE cl_apj_rt_api=>ty_end_info.

    DATA lt_job_parameters TYPE cl_apj_rt_api=>tt_job_parameter_value.
    DATA ls_job_parameters TYPE cl_apj_rt_api=>ty_job_parameter_value.
    DATA ls_value TYPE cl_apj_rt_api=>ty_value_range.

    DATA lv_jobname TYPE cl_apj_rt_api=>ty_jobname.
    DATA lv_jobcount TYPE cl_apj_rt_api=>ty_jobcount.

    DATA lv_status TYPE cl_apj_rt_api=>ty_job_status.
    DATA lv_statustext TYPE cl_apj_rt_api=>ty_job_status_text.

    DATA lv_txt TYPE string.
    DATA ls_ret TYPE bapiret2.


     lv_template_name = 'ZGRAB_DATASETS_TEMPL'.


* the immediate start can't be used when being called from within a RAP business object
* because the underlying API performs an implicit COMMIT WORK.
*ls_start_info-start_immediately = 'X'.

* Start the job using a timestamp instead. This will start the job immediately but can have a delay depending on the current workload.
    GET TIME STAMP FIELD DATA(ls_ts1).
    DATA(ls_ts2) = cl_abap_tstmp=>add( tstmp = ls_ts1
                                       secs = 10 ).
    ls_start_info-timestamp = ls_ts1.

*********** periodicity ******************************
*
*    ls_scheduling_info-periodic_granularity = 'D'.
*    ls_scheduling_info-periodic_value = 1.
*    ls_scheduling_info-test_mode = abap_false.
*    ls_scheduling_info-timezone = 'CET'.
*
*    ls_end_info-type = 'NUM'.
*    ls_end_info-max_iterations = 3.
*
** fill parameter table ******************************
** fill the table only if you want to overrule the parameter values
** which are stored in the template
** the field names in this program must match the field names of the template
*
*    ls_job_parameters-name = 'P_TEST1'.
*
*    ls_value-sign = 'I'.
*    ls_value-option = 'EQ'.
*    ls_value-low = 'Blabla 1'.
*    APPEND ls_value TO ls_job_parameters-t_value.
*
*    APPEND ls_job_parameters TO lt_job_parameters.
*    CLEAR ls_job_parameters.
**+++++++++++++++++++++++++
*
*    ls_job_parameters-name = 'P_TEST2'.
*
*    ls_value-sign = 'I'.
*    ls_value-option = 'BT'.
*    ls_value-low = 'ATEST'.
*    ls_value-high = 'ZTEST'.
*    APPEND ls_value TO ls_job_parameters-t_value.
*
*    ls_job_parameters-name = 'P_TEST2'.
*
*    ls_value-sign = 'I'.
*    ls_value-option = 'BT'.
*    ls_value-low = '11111'.
*    ls_value-high = '99999'.
*    APPEND ls_value TO ls_job_parameters-t_value.
*
*    APPEND ls_job_parameters TO lt_job_parameters.
*    CLEAR ls_job_parameters.
**+++++++++++++++++++++++++
*
*    ls_job_parameters-name = 'P_TEST3'.
*
*    ls_value-sign = 'I'.
*    ls_value-option = 'EQ'.
*    ls_value-low = '220'.
*    APPEND ls_value TO ls_job_parameters-t_value.
*
*    APPEND ls_job_parameters TO lt_job_parameters.
*    CLEAR ls_job_parameters.
*
******************************************************


    TRY.


* some scenarios require that the job key ( = jobname, jobcount) is already known
* before the job is created. The method generate_jobkey creates a valid job key.
* This key can then be passed later on to the method schedule_job, and a job with
* exactly this key is created.

* optional. You need this call only if you have to know the job key in advance
*       cl_apj_rt_api=>generate_jobkey(
*                       importing
*                            ev_jobname  = lv_jobname
*                            ev_jobcount = lv_jobcount ).


* If you pass the table lt_job_parameters , then the parameters
* contained in this table are used.
* If you don't pass the table, the parameters contained in the
* job template are used.

        cl_apj_rt_api=>schedule_job(
        EXPORTING
        iv_job_template_name = lv_template_name
        iv_job_text = lv_job_text
        is_start_info = ls_start_info
        is_scheduling_info = ls_scheduling_info
        is_end_info = ls_end_info
        it_job_parameter_value = lt_job_parameters
* the following two parameters are optional. If you pass them, they must have been generated
* with the call of generate_jobkey above
*        iv_jobname  = lv_jobname
*        iv_jobcount = lv_jobcount
        IMPORTING
        ev_jobname  = lv_jobname
        ev_jobcount = lv_jobcount
        ).

*        out->write( lv_jobname ).
*        out->write( lv_jobcount ).

        cl_apj_rt_api=>get_job_status(
        EXPORTING
        iv_jobname  = lv_jobname
        iv_jobcount = lv_jobcount
        IMPORTING
        ev_job_status = lv_status
        ev_job_status_text = lv_statustext
        ).

*        out->write( lv_status ).
*        out->write( lv_statustext ).


** via the following method you can cancel the job
** in the application job context 'cancel' means (as in the Fiori app):
** 1. if the job is running, it will be canceled
** 2. if the job has not yet started, it will be deleted.
** In case the job is periodic, the whole periodicity chain is deleted.
*
*        cl_apj_rt_api=>cancel_job(
*        EXPORTING
*        iv_jobname = lv_jobname
*        iv_jobcount = lv_jobcount
*        ).



      CATCH cx_apj_rt INTO DATA(exc).
        lv_txt = exc->get_longtext( ).
        ls_ret = exc->get_bapiret2( ).
*        out->write( 'ERROR:' ). out->write( lv_txt ).
*        out->write( 'msg type =' ). out->write( ls_ret-type ).
*        out->write( 'msg id =' ). out->write( ls_ret-id ).
*        out->write( 'msg number =' ). out->write( ls_ret-number ).
*        out->write( 'msg message =' ). out->write( ls_ret-message ).
    ENDTRY.


  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'S_LANGU' kind = if_apj_dt_exec_object=>select_option datatype = 'c' length = 1  param_text = 'Language'                            changeable_ind = abap_true )
    ).

    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'S_LANGU' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'EQ' low = 'D' )
      ( selname = 'S_LANGU' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'EQ' low = 'E' )
    ).

ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA: lt_languages TYPE ty_range_langu,
          ls_language LIKE LINE OF lt_languages.

    ls_language-sign = 'I'.
    ls_language-option = 'EQ'.
    ls_language-low = 'D'.

    APPEND ls_language TO lt_languages.

    ls_language-sign = 'I'.
    ls_language-option = 'EQ'.
    ls_language-low = 'E'.

    APPEND ls_language TO lt_languages.

    ZCL_DATASET_GRABBER=>GET_DATASETS_FOR_ALL_DEST( lt_languages ).

  ENDMETHOD.


  METHOD GENERATE_ONPREM_DATASETS.

    DATA: lo_structures TYPE REF TO zcl_rap_infotype_structure,
          lo_structure_description TYPE REF TO CL_ABAP_STRUCTDESCR,
          lo_table_type TYPE REF TO cl_abap_tabledescr,
          dataref TYPE REF TO data.

    lo_structures = NEW #( destination_key ).

    DATA: infotypes TYPE zcl_rap_infotype_structure=>t_infotype_structures.

    lo_structures->GET_INFOTYPE_DATASETS(
        EXPORTING
            language = language
        IMPORTING
            infotypes = infotypes ).

    FIELD-SYMBOLS: <infotype> Like line of infotypes.
    DATA: datasets TYPE TABLE OF zics_datasets,
          dataset LIKE LINE OF datasets,
          datasetTexts TYPE TABLE OF zics_datasetstxt,
          datasetText like line of datasetTexts.

    LOOP AT infotypes ASSIGNING <infotype>.
        dataset-destination = destination_key.
        dataset-dataset = <infotype>-infotype.

        datasetText-destination = destination_key.
        datasetText-dataset = <infotype>-infotype.
        datasetText-language = <infotype>-infotype_language.
        datasetText-dataset_desc = <infotype>-Infotype_Name.

        SELECT SINGLE * FROM zics_datasets WHERE destination = @destination_key
                                             AND dataset     = @dataset-dataset
                                            INTO @DATA(Dummy).
        IF sy-subrc = 4.
            "Dataset not found --> Append
            APPEND dataset TO datasets.
        ENDIF.

        SELECT SINGLE * FROM zics_datasetstxt WHERE destination = @destination_key
                                                AND dataset     = @datasetText-dataset
                                                AND language    = @datasetText-language
                                               INTO @DATA(Dummy2).
        IF sy-subrc = 4.
            "DatasetText not found --> Append
            APPEND datasetText TO datasetTexts.
        ENDIF.

        CLEAR: dataset, datasetText.

    ENDLOOP.

*   insert the new table entries
    INSERT zics_datasets FROM TABLE @datasets.
    INSERT zics_datasetstxt FROM TABLE @datasetTexts.

  ENDMETHOD.
ENDCLASS.
