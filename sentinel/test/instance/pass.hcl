mock "tfplan/v2" {
  data = {
    resource_changes = {
      web = {
        type = "aws_instance"

        change = {
          after = {
            instance_type = "t3.micro"
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
