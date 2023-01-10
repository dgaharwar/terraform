data "morpheus_group" "tf_example_group" {
  name = "group1"
}

output  "data_morpheus_group" {
  value = data.morpheus_group.tf_example_group.id
}
