mock "tfplan/v2" {
  data = {
    resource_changes = {
      web = {
        type = "aws_instance"

        change = {
          after = {
            availability_zone = "eu-west-1a"
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