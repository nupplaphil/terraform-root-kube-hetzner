variable "hcloud_token" {
  description = "Hetzner Cloud API Token."
  type        = string
  sensitive   = true
}

variable "ssh_port" {
  description = "The main SSH port to connect to the nodes."
  type        = number
  default     = 22

  validation {
    condition     = var.ssh_port >= 0 && var.ssh_port <= 65535
    error_message = "The SSH port must use a valid range from 0 to 65535."
  }
}

variable "ssh_public_key" {
  description = "SSH public Key."
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private Key."
  type        = string
  sensitive   = true
}

variable "root-server" {
  description = "List of root-server."
  type = list(object({
    name         = string
    hostname     = string
    ipv4_address = string
    private_ipv4_address = string
    labels               = list(string)
    taints               = list(string)
  }))
  default = []
}

variable "k3s_endpoint" {
  type = string
}

variable "k3s_token" {
  type = string
}
variable "automatically_upgrade_k3s" {
  type        = bool
  default     = true
  description = "Whether to automatically upgrade k3s based on the selected channel."
}

variable "automatically_upgrade_os" {
  type        = bool
  default     = true
  description = "Whether to enable or disable automatic os updates. Defaults to true. Should be disabled for single-node clusters"
}

variable "cni_plugin" {
  type        = string
  default     = "flannel"
  description = "CNI plugin for k3s."

  validation {
    condition     = contains(["flannel", "calico", "cilium"], var.cni_plugin)
    error_message = "The cni_plugin must be one of \"flannel\", \"calico\", or \"cilium\"."
  }
}

variable "initial_k3s_channel" {
  type        = string
  default     = "v1.27"
  description = "Allows you to specify an initial k3s channel."

  validation {
    condition     = contains(["stable", "latest", "testing", "v1.16", "v1.17", "v1.18", "v1.19", "v1.20", "v1.21", "v1.22", "v1.23", "v1.24", "v1.25", "v1.26", "v1.27"], var.initial_k3s_channel)
    error_message = "The initial k3s channel must be one of stable, latest or testing, or any of the minor kube versions like v1.26."
  }
}

variable "network_id" {
  type = number
}

variable "vSwitch_id" {
  type = number
}

variable "preinstall_exec" {
  type        = list(string)
  default     = []
  description = "Additional to execute before the install calls, for example fetching and installing certs."
}

variable "address_for_connectivity_test" {
  type        = string
  default     = "1.1.1.1"
  description = "Before installing k3s, we actually verify that there is internet connectivity. By default we ping 1.1.1.1, but if you use a proxy, you may simply want to ping that proxy instead (assuming that the proxy has its own checks for internet connectivity)."
}

variable "k3s_exec_agent_args" {
  type        = string
  default     = ""
  description = "Agents nodes are started with `k3s agent {k3s_exec_agent_args}`. Use this to add kubelet-arg for example."
}

variable "enable_longhorn" {
  type        = bool
  default     = false
  description = "Whether or not to enable Longhorn."
}

variable "additional_k3s_environment" {
  type        = map(any)
  default     = {}
  description = "Additional environment variables for the k3s binary. See for example https://docs.k3s.io/advanced#configuring-an-http-proxy ."
}

variable "network_region" {
  description = "Default region for network."
  type        = string
  default     = "eu-central"
}
