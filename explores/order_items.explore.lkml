# include all the views
include: "/views/order_items.view"
include: "/views/inventory_items.view"
include: "/views/orders.view"
include: "/views/products.view"
include: "/views/users.view"
include: "/views/customer_segmentation_rfm.view"
include: "/views/product_semantic_search.view"
include: "/views/events.view"

explore: order_items {
  join: product_semantic_search {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_id} = ${product_semantic_search.matched_product_id} ;;
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    view_label: "users"
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.user_id};;
    relationship: one_to_many
  }

  join: customer_segmentation_rfm {
    type: left_outer
    sql_on: ${users.id} = ${customer_segmentation_rfm.customer_id} ;;
    relationship: one_to_one
  }
}
