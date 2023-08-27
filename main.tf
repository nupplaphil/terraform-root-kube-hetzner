# Here we create a subnet for the root vSwitch
resource "hcloud_network_subnet" "root" {
  network_id   = var.network_id
  type         = "vswitch"
  network_zone = var.network_region
  ip_range     = "10.201.0.0/16"
  vswitch_id   = var.vSwitch_id
}
