connection: "@{LOOKER_BIGQUERY_CONNECTION_NAME}"

include: "/views/*.view" # include all the views
include: "/dashboard/*.dashboard" # include all the dashboards
include: "/explores/*.explore" # include all the explores

datagroup: ecomm_daily {
  sql_trigger: SELECT MAX(DATE(created_time)) FROM `tridorian-wildan-sandbox-dev.ecomm.order_items` ;;
  max_cache_age: "32 hours"
}

datagroup: ecomm_monthly {
  sql_trigger: SELECT MAX(MONTH(created_time)) FROM `tridorian-wildan-sandbox-dev.ecomm.order_items` ;;
  max_cache_age: "32 hours"
}

map_layer: thailand_province_layer {
  file: "/maps/thailand-provinces.geojson"
  property_key: "Province"
}
