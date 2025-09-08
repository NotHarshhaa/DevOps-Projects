output "cluster_id" {
  value = aws_eks_cluster.abrahimcse.id
}

output "node_group_id" {
  value = aws_eks_node_group.abrahimcse.id
}

output "vpc_id" {
  value = aws_vpc.abrahimcse_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.abrahimcse_subnet[*].id
}
