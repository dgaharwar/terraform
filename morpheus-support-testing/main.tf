output "something" {
   value = templatefile("this/is/a/deeply/nested/folder/something.json", {
    chessboard = 8
   })
}


output "rendered" {
  value = templatefile("this/shallow_nesting_also_doesnt_work.json", {
    age = 1
  })
}

module "lm" {
  source = "./modules/random_local_module"
  some_string = "describe something for a second"
}

output "lmout" {
  value = module.lm.local_module_output
}

module "lm2" {
  source = "./modules/random_local_module_2"
  some_string2 = "describe something for a second2"
}

output "lmout2" {
  value = module.lm.local_module_output
}