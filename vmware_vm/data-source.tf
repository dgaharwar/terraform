data "morpheus_group" "morpheusgroup" {
  name = "Group A"
}

output  "data_morpheus_group"{
  value = data.morpheus_group.morpheusgroup.name
}