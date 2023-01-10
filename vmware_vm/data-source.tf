data "morpheus_group" "morpheusgroup" {
  name = "group1"
}

output  "data_morpheus_group" {
  value = data.morpheus_group.morpheusgroup.id
}
