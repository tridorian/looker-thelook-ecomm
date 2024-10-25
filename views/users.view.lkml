view: users {
  sql_table_name: `tridorian-wildan-sandbox-dev.ecomm.users_th` ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    action: {
      label: "Send Email via SendGrid"
      url: "https://asia-southeast1-tridorian-wildan-sandbox-dev.cloudfunctions.net/sendgrid-http"
      form_param: {
        name: "from_address"
        type: string
        label: "Sender"
        required: yes
        default: "wildan.putra@tridorian.com"
      }
      form_param: {
        name: "to_address"
        type: string
        label: "Receiver"
        required: yes
        default: "{{value}}"
      }
      form_param: {
        name: "subject"
        type: string
        label: "Subject"
        required: yes
        default: "string"
      }
      form_param: {
        name: "plain_text_content"
        type: string
        label: "Body Mail"
        required: yes
        default: "string"
      }
    }
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: lng {
    type: number
    sql: ${TABLE}.lng ;;
  }

  dimension: postcode {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: thailand_province_layer
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, orders.count]
  }
}
