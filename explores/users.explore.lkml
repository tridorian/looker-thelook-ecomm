include: "/views/users.view"
include: "/views/customer_segmentation_rfm.view"
explore: users {
  join: customer_segmentation_rfm {
    type: left_outer
    sql_on: ${users.id} = ${customer_segmentation_rfm.customer_id} ;;
    relationship: one_to_one
  }
}
