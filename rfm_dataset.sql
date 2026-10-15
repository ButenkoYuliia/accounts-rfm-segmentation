WITH opens AS (
  SELECT
    es.id_account AS account_id,
    eo.id_message,
    DATE_ADD(s.date, INTERVAL eo.open_date DAY) AS open_date
  FROM `data-analytics-mate.DA.email_sent` es
  JOIN `data-analytics-mate.DA.email_open` eo
    ON es.id_message = eo.id_message
  JOIN `data-analytics-mate.DA.account_session` acs
    ON es.id_account = acs.account_id
  JOIN `data-analytics-mate.DA.session` s
    ON acs.ga_session_id = s.ga_session_id
)


SELECT
  account_id,
  COUNT(DISTINCT id_message)      AS visit_cnt,        -- унікальні відкриті листи
  MAX(open_date)                  AS last_visit_date,  -- останнє відкриття
  COUNT(DISTINCT id_message) * 10 AS revenue           -- $10 за кожен відкритий лист
FROM opens
GROUP BY account_id
HAVING COUNT(DISTINCT id_message) > 0
   AND MAX(open_date) IS NOT NULL
ORDER BY revenue DESC;
