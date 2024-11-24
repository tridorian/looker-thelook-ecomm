
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
    WHEN recency_quantile = 1 AND frequency_quantile = 1 AND monetary_quantile = 1 THEN "Core - Your Best Customers"
    -- Loyal Customers (X1X)
    WHEN (frequency_quantile = 1 AND monetary_quantile < 3) THEN "Loyal - Your Most Loyal Customers"
    -- Highest Paying Customers (XX1)
    WHEN monetary_quantile = 1 THEN "Whales - Your Highest Paying Customers"
    -- Promising - Faithful customers (X13, X14)
    WHEN (frequency_quantile = 1 AND monetary_quantile = 3) OR # X13
         (frequency_quantile = 1 AND monetary_quantile = 4)    # X14
        THEN "Promising - Faithful customers"
    -- Your Newest Customers (14X)
    WHEN (recency_quantile = 1 AND frequency_quantile = 4) THEN "Rookies - Your Newest Customers"
    -- Once Loyal, Now Gone (44X)
    WHEN (recency_quantile = 4 AND frequency_quantile = 4) THEN "Slipping - Once Loyal, Now Gone"
    END
    AS customer_segment
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
    label: "Recency"
    description: "How many days ago customer made a purchase?"
    type: number
    sql: ${TABLE}.recency ;;
  }

  dimension: frequency {
    label: "Frequency"
    description: "How many times has the customer purchased from our store?"
    type: number
    sql: ${TABLE}.frequency ;;
  }

  dimension: monetary {
    label: "Monetary"
    description: "How many $ has this customer spent?"
    type: number
    sql: ${TABLE}.monetary ;;
  }

  dimension: recency_quantile {
    type: number
    sql: ${TABLE}.recency_quantile ;;
    hidden: yes
  }

  dimension: frequency_quantile {
    type: number
    sql: ${TABLE}.frequency_quantile ;;
    hidden: yes
  }

  dimension: monetary_quantile {
    type: number
    sql: ${TABLE}.monetary_quantile ;;
    hidden: yes
  }

  dimension: customer_segment {
    description: "customer segment type"
    type: string
    sql: ${TABLE}.customer_segment ;;
  }

  measure: count {
    type: count
    drill_fields: [customer_id, customer_segment, orders.count]
  }

}
