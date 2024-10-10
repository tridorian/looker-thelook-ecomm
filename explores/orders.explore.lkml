include: "/views/orders.view"
include: "/views/users.view"
include: "/views/customer_segmentation_rfm.view"

explore: orders {
  join: users {
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
