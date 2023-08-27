resource "null_resource" "server" {
  for_each = local.server_nodes

  connection {
    user           = "root"
    private_key    = var.ssh_private_key
    agent_identity = local.ssh_agent_identity
    host           = local.server_nodes[each.key].ipv4_address
    port           = var.ssh_port
    agent         = false
  }

  # Generating k3s agent config file
  provisioner "file" {
    content = yamlencode({
      node-name     = local.server_nodes[each.key].nodepool_name
      server        = var.k3s_endpoint
      token         = var.k3s_token
      kubelet-arg   = local.kubelet_arg
      node-ip       = local.server_nodes[each.key].private_ipv4_address
      node-label    = each.value.labels
      node-taint    = each.value.taints
      selinux       = true
    })
    destination = "/tmp/config.yaml"
  }

  # Install k3s agent
  provisioner "remote-exec" {
    inline = local.install_k3s_server
  }

  # Start the k3s agent and wait for it to have started
  provisioner "remote-exec" {
    inline = concat(var.enable_longhorn ? ["systemctl enable --now iscsid"] : [], [
      "systemctl start k3s-agent 2> /dev/null",
      <<-EOT
      timeout 120 bash <<EOF
        until systemctl status k3s-agent > /dev/null; do
          systemctl start k3s-agent 2> /dev/null
          echo "Waiting for the k3s agent to start..."
          sleep 2
        done
      EOF
      EOT
    ])
  }
}
