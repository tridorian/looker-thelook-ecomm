include: "/views/product_semantic_search.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/users.view.lkml"

explore: product_semantic_search {
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.product_id} = ${product_semantic_search.matched_product_id} ;;
  }

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: order_items_customer {
    from: order_items
    sql: RIGHT JOIN ${order_items.SQL_TABLE_NAME} AS order_items_customer ON ${order_items_customer.id} = ${order_items.id} AND ${order_items.user_id} =  ${order_items_customer.user_id};;
    relationship: many_to_one
  }

}
