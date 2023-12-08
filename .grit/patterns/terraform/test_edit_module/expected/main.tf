module "test_module1" {
  source = "new_source"
  variable1 = "variable1"
  variable2 = "variable2"
  
  
}

module "test_module2" {
  source = "new_source"
  variable1 = "variable1"
  variable2 = "variable2"
  
  
}

module "test_module3" {
  source    = "another_source"
  variable1 = "variable1"
  variable2 = "variable2"
  variable3 = "variable3"
  variable4 = "variable4"
}
