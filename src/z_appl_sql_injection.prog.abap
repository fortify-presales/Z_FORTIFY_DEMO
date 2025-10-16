*&---------------------------------------------------------------------*
*& Report z_appl_sql_injection
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_appl_sql_injection.

PARAMETERS: p_user TYPE s_carr_id.

DATA: lv_sql TYPE string,
      lv_carrid TYPE s_carr_id,
      lv_connid TYPE s_conn_id,
      lv_fldate TYPE s_date,
      lt_result TYPE TABLE OF sflight,
      ls_result TYPE sflight.

lv_sql = |SELECT * FROM sflight WHERE carrid = '{ p_user }'|.

" Vulnerable to SQL injection
EXEC SQL.
  DECLARE cur CURSOR FOR
    EXECUTE IMMEDIATE :lv_sql.
  OPEN cur.
  FETCH NEXT cur INTO :lv_carrid, :lv_connid, :lv_fldate.
  CLOSE cur.
ENDEXEC.

WRITE: / 'Flight found:', lv_carrid, lv_connid, lv_fldate.

" Using parameterized query to prevent SQL injection
SELECT * FROM sflight INTO TABLE @lt_result WHERE carrid = @p_user.

IF sy-subrc = 0 AND lt_result IS NOT INITIAL.
  READ TABLE lt_result INTO ls_result INDEX 1.
  WRITE: / 'Flight found:', ls_result-carrid, ls_result-connid, ls_result-fldate.
ELSE.
  WRITE: / 'No flight found or error occurred.'.
ENDIF.
