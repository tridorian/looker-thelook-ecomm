# include all the views
include: "/views/order_items.view"
include: "/views/inventory_items.view"
include: "/views/orders.view"
include: "/views/products.view"
include: "/views/users.view"
include: "/views/customer_segmentation_rfm.view"
explore: order_items {
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

  join: customer_segmentation_rfm {
    type: left_outer
    sql_on: ${users.id} = ${customer_segmentation_rfm.customer_id} ;;
    relationship: one_to_one
  }
}
