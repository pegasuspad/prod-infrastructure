terraform {
  # PGUSER and PGPASSWORD must be in environment
  backend "pg" {
    conn_str    = "postgres://terraform-state/terraform_backend?sslmode=require"
    schema_name = "prod_proxy_passthrough_vm"
  }
}
