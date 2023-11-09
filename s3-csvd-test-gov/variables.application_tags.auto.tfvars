# override CostAllocation with proper subcomponent like
# tags = merge(
#   var.application_tags,
#   tomap({"CostAllocation"="dice:dev:mojo"}),
# )


application_tags = {
  "Project Name"   = "s3-my-test"
  "ProjectNumber"  = ""
  "CostAllocation" = "mytag:sometag"
  "Organization"   = ""
  "Environment"    = "test"
}
