connection: "looker-demo-ecomm"

# include all the views
include: "/views/*.view"

# include all the dashboards
include: "/dashboard/*.dashboard"

# include all the explores
include: "/explores/*.explore"

map_layer: thailand_province_layer {
  file: "/maps/thailand-provinces.geojson"
  property_key: "Province"
}
