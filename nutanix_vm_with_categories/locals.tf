# ------------------------------
# Parse categories into keys and values
# ------------------------------
locals {
  category_keys   = { for c in var.categories_dataset : split(":", c.name)[0] => split(":", c.name)[0] }
  category_values = var.categories_dataset
}