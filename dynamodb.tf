resource aws_dynamodb_table data_set {
  name           = "${var.name}_data_set"
  hash_key       = "name"
  write_capacity = 1
  read_capacity  = 1

  attribute {
    name = "name"
    type = "S"
  }
}
