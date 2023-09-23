resource "kubernetes_role" "this" {
  metadata {
    name      = "default:ad-eks-admins"
    namespace = "kube-system"
    labels = {
      role = "eks-admins"
    }
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "eks-admins-binding"
    namespace = "kube-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = kubernetes_role.this.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "clusterrole-eks-admins-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "default:ad-eks-admins"
    api_group = "rbac.authorization.k8s.io"
  }
}
