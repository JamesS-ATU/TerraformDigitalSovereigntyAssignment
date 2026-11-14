mock "tfplan/v2" {
  data = {
    resource_changes = {
      web = {
        type = "aws_instance"

        change = {
          after = {
            root_block_device = [
              {
                encrypted = false
              }
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