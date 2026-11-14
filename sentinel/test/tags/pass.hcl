mock "tfplan/v2" {
  data = {
    resource_changes = {
      instance = {
        type = "aws_instance"
        change = {
          after = {
            tags = {
              Environment = "Prod"
              Owner = "James"
              AssignmentName = "Assessment"
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