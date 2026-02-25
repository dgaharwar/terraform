output "image_name_to_id" {
  description = "Map of image names to their OpenStack IDs"
  value       = { for name, details in data.openstack_images_image_v2.images : name => details.id }
}
