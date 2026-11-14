mock "tfplan/v2" {
  data = {
    resource_changes = {
      ssh = {
        type = "aws_security_group_rule"

        change = {
          after = {
            from_port = 22
            to_port = 22
            cidr_blocks = [
              "0.0.0.0/0"
            ]
          }
        }
      }
    }
  }
}

test {
  rules = {
    main = false
  }
}
