mock "tfplan/v2" {
  data = {
    resource_changes = {
      instance = {
        type = "aws_instance"
        change = {
          after = {
             tags = {
                Name           = "terraform-demo"
                Environment    = ""
                Owner          = ""
                AssignmentName = ""
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