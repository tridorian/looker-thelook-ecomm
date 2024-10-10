# include all the views
include: "/views/inventory_items.view"
include: "/views/products.view"

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}
