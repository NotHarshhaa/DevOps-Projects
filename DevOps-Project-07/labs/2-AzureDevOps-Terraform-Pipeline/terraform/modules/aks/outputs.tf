output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
