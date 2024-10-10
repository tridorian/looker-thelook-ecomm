
view: customer_segmentation_rfm {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: WITH
    rfm_calc AS (
    SELECT
      o.user_id AS customer_id,
      DATE_DIFF(CURRENT_TIMESTAMP(), MAX(o.created_at), DAY) AS recency,
      COUNT(o.order_id) AS frequency,
      ROUND(SUM(oi.sale_price)) AS monetary
    FROM
      `tridorian-wildan-sandbox-dev.ecomm.orders` o
    INNER JOIN
      `tridorian-wildan-sandbox-dev.ecomm.order_items` oi
    ON
      o.order_id = oi.order_id
    GROUP BY
      customer_id ),

    -- Here you're leveraging the rfm_calc CTE and creating another CTE
    rfm_quant AS (
    SELECT
      customer_id,recency,frequency,monetary,
      NTILE(4) OVER (ORDER BY recency ASC) AS recency_quantile,
      NTILE(4) OVER (ORDER BY frequency DESC) AS frequency_quantile,
      NTILE(4) OVER (ORDER BY monetary DESC) AS monetary_quantile
    FROM
      rfm_calc )

    --And then you perform a select query that assigns categories based on quantile logic and returns values
    SELECT
      customer_id,recency,frequency,monetary,
      recency_quantile, frequency_quantile, monetary_quantile,
    CASE
    -- Best Customer (111)
    WHEN recency_quantile = 1 AND frequency_quantile = 1 AND monetary_quantile = 1 THEN "Best Customer"
    -- Potential Customers (112, 122, 211, 222)
    WHEN (recency_quantile = 1 AND frequency_quantile = 1 AND monetary_quantile = 2) OR # 112
         (recency_quantile = 2 AND frequency_quantile = 1 AND monetary_quantile = 1) OR # 211
         (recency_quantile = 1 AND frequency_quantile = 2 AND monetary_quantile = 2) OR # 122
         (recency_quantile = 2 AND frequency_quantile = 2 AND monetary_quantile = 2)    # 222
        THEN "Potential Customers"
    -- Big Spender (XX1)
    WHEN (recency_quantile = 1 AND frequency_quantile = 2 AND monetary_quantile = 1) OR # 121
         (recency_quantile = 1 AND frequency_quantile = 3 AND monetary_quantile = 1) OR # 131
         (recency_quantile = 1 AND frequency_quantile = 4 AND monetary_quantile = 1) OR # 141
         (recency_quantile = 2 AND frequency_quantile = 2 AND monetary_quantile = 1) OR # 221
         (recency_quantile = 2 AND frequency_quantile = 3 AND monetary_quantile = 1) OR # 231
         (recency_quantile = 2 AND frequency_quantile = 4 AND monetary_quantile = 1) OR # 241
         (recency_quantile = 3 AND frequency_quantile = 1 AND monetary_quantile = 1) OR # 311
         (recency_quantile = 3 AND frequency_quantile = 2 AND monetary_quantile = 1) OR # 321
         (recency_quantile = 3 AND frequency_quantile = 3 AND monetary_quantile = 1) OR # 331
         (recency_quantile = 3 AND frequency_quantile = 4 AND monetary_quantile = 1) OR # 341
         (recency_quantile = 4 AND frequency_quantile = 1 AND monetary_quantile = 1) OR # 411
         (recency_quantile = 4 AND frequency_quantile = 2 AND monetary_quantile = 1) OR # 421
         (recency_quantile = 4 AND frequency_quantile = 3 AND monetary_quantile = 1) OR # 431
         (recency_quantile = 4 AND frequency_quantile = 4 AND monetary_quantile = 1)    # 441
        THEN "Big Spender"
    -- Loyal Customers (X1X)
    WHEN (recency_quantile = 1 AND frequency_quantile = 1 AND monetary_quantile = 3) OR # 113
         (recency_quantile = 1 AND frequency_quantile = 1 AND monetary_quantile = 4) OR # 114
         (recency_quantile = 2 AND frequency_quantile = 1 AND monetary_quantile = 2) OR # 212
         (recency_quantile = 2 AND frequency_quantile = 1 AND monetary_quantile = 3) OR # 213
         (recency_quantile = 2 AND frequency_quantile = 1 AND monetary_quantile = 4) OR # 214
         (recency_quantile = 3 AND frequency_quantile = 1 AND monetary_quantile = 2) OR # 312
         (recency_quantile = 3 AND frequency_quantile = 1 AND monetary_quantile = 3) OR # 313
         (recency_quantile = 3 AND frequency_quantile = 1 AND monetary_quantile = 4) OR # 314
         (recency_quantile = 4 AND frequency_quantile = 1 AND monetary_quantile = 2) OR # 412
         (recency_quantile = 4 AND frequency_quantile = 1 AND monetary_quantile = 3) OR # 413
         (recency_quantile = 4 AND frequency_quantile = 1 AND monetary_quantile = 4)    # 414
        THEN "Loyal Customers"
    -- Almost Lost (3XX)
    WHEN (recency_quantile = 3 AND frequency_quantile = 2 AND monetary_quantile = 2) OR # 322
         (recency_quantile = 3 AND frequency_quantile = 2 AND monetary_quantile = 3) OR # 323
         (recency_quantile = 3 AND frequency_quantile = 2 AND monetary_quantile = 4) OR # 324
         (recency_quantile = 3 AND frequency_quantile = 3 AND monetary_quantile = 2) OR # 332
         (recency_quantile = 3 AND frequency_quantile = 3 AND monetary_quantile = 3) OR # 333
         (recency_quantile = 3 AND frequency_quantile = 3 AND monetary_quantile = 4) OR # 334
         (recency_quantile = 3 AND frequency_quantile = 4 AND monetary_quantile = 2) OR # 342
         (recency_quantile = 3 AND frequency_quantile = 4 AND monetary_quantile = 3) OR # 343
         (recency_quantile = 3 AND frequency_quantile = 4 AND monetary_quantile = 4)    # 344
        THEN "Almost Lost"
    -- Lost Customers (4XX)
    WHEN (recency_quantile = 4 AND frequency_quantile = 2 AND monetary_quantile = 2) OR # 422
         (recency_quantile = 4 AND frequency_quantile = 2 AND monetary_quantile = 3) OR # 423
         (recency_quantile = 4 AND frequency_quantile = 2 AND monetary_quantile = 4) OR # 424
         (recency_quantile = 4 AND frequency_quantile = 3 AND monetary_quantile = 2) OR # 432
         (recency_quantile = 4 AND frequency_quantile = 3 AND monetary_quantile = 3) OR # 433
         (recency_quantile = 4 AND frequency_quantile = 4 AND monetary_quantile = 2)    # 442
        THEN "Lost Customers"
    -- Lost Cheap (444, 443, 434)
    WHEN (recency_quantile = 4 AND frequency_quantile = 4 AND monetary_quantile = 4) OR # 444
         (recency_quantile = 4 AND frequency_quantile = 4 AND monetary_quantile = 3) OR # 443
         (recency_quantile = 4 AND frequency_quantile = 3 AND monetary_quantile = 4)    # 434
        THEN "Lost Cheap"
    -- Others/Recent Shopper (1XX & 2XX)
    ELSE "Others/Recent Shopper"
    END
    AS customer_segment,
    CASE
      WHEN monetary_quantile = 1 THEN "Big Spender"
      WHEN frequency_quantile = 1 THEN "Loyal Customers"
      WHEN recency_quantile <= 2 THEN "Recent Shopper"
      WHEN recency_quantile = 3 THEN "Almost Lost"
      WHEN recency_quantile = 4 THEN "Lost Customers"
    END
    AS macro_cluster
    FROM
    rfm_quant
    ORDER BY recency ASC;;
  }

  # Define your dimensions and measures here, like this:
  dimension: customer_id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.customer_id ;;
    primary_key: yes
  }

  dimension: recency {
    description: "How many days ago customer made a purchase?"
    type: number
    sql: ${TABLE}.recency ;;
  }

  dimension: frequency {
    description: "How many times has the customer purchased from our store?"
    type: number
    sql: ${TABLE}.frequency ;;
  }

  dimension: monetary {
    description: "How many $ has this customer spent?"
    type: number
    sql: ${TABLE}.monetary ;;
  }

  dimension: recency_quantile {
    type: number
    sql: ${TABLE}.recency_quantile ;;
  }

  dimension: frequency_quantile {
    type: number
    sql: ${TABLE}.frequency_quantile ;;
  }

  dimension: monetary_quantile {
    type: number
    sql: ${TABLE}.monetary_quantile ;;
  }

  dimension: customer_segment {
    description: "customer segment type"
    type: string
    sql: ${TABLE}.customer_segment ;;
  }

  dimension: macro_cluster {
    description: "macro cluster segment type"
    type: string
    sql: ${TABLE}.macro_cluster ;;
  }

  measure: count {
    type: count
    drill_fields: [customer_id, customer_segment, macro_cluster, orders.count]
  }

}
