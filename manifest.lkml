project_name: "thelook_ecomm"

# This is the ID of the BQML MODEL setup with the remote connect
constant: BQML_REMOTE_CONNECTION_MODEL_ID {
  value: "tridorian-wildan-sandbox-dev.ecomm.llm"
}

# This is the ID of the remote connection setup in BigQuery
constant: BQML_REMOTE_CONNECTION_ID {
  value: "tridorian-wildan-sandbox-dev.us.thelook_llm"
}

# This is the name of the Looker BigQuery Database connection
constant: LOOKER_BIGQUERY_CONNECTION_NAME {
  value: "looker-demo-ecomm"
}
