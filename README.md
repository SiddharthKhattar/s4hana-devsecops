# SAP S/4 Hana DevSecOps & Release Automation

This project outlines the container security, CI/CD automation, and infrastructure optimization engineered for the SAP S/4 Hana Test Engineering team.

## 🛡️ Security & Attack Surface Reduction
A baseline vulnerability scan on the legacy `debian:buster` Java base image revealed 68 vulnerabilities (28 High/Critical). To remediate this, the architecture was hardened:
* **Alpine Linux Migration:** Replaced `glibc` with `musl libc`, stripping out unused binaries.
* **Trivy CI/CD Gate:** Implemented a GitHub Actions workflow that automatically scans pull requests and blocks deployments if CVEs are detected.
* **Kubernetes Hardening:** Enforced strict `securityContext` policies (`readOnlyRootFilesystem`, dropping all capabilities, running as non-root user 1000).
* **Result:** Eliminated the 28 Critical/High vulnerabilities, reducing the overall container attack surface by >80%.

## ⚡ Performance Optimization & Cost Savings ($15K-$20K/mo)
By decoupling the heavy Maven build layer from the JRE runtime using **Multi-Stage Docker builds**, the final container size was reduced from ~600MB to ~150MB.

**The Impact:**
1. **70% Faster Cold Starts:** The Kubernetes Kubelet was able to pull the 150MB image across the network significantly faster during horizontal pod autoscaling (HPA) events.
2. **Azure Cloud Savings:** Smaller image footprints and optimized Kubernetes resource requests/limits allowed for tighter pod bin-packing. This meant we could run the same workloads on fewer, less-expensive Azure AKS nodes, resulting in a direct infrastructure cost reduction of $15K–$20K per month.

## 🚀 Deployment Pipeline
* **Continuous Integration:** GitHub Actions handles code compilation, Docker builds, and Trivy security gating.
* **Continuous Delivery:** ArgoCD monitors the Git repository and automatically synchronizes the hardened `deployment.yaml` manifests to the Kubernetes cluster using a GitOps methodology.
* **Observability:** Prometheus and Loki are utilized for monitoring the deployment health and routing telemetry back to the engineering team.