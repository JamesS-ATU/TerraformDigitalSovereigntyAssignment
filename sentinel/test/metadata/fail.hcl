mock "tfplan/v2" {
  data = {
    resource_changes = {
      web = {
        type = "aws_instance"

        change = {
          after = {
            metadata_options = {
              http_tokens = "optional"
            }
          }
        }
      }
    }
  }
}

test {
  rules = {
    main = true
  }
}