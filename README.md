# SAP S/4 Hana DevSecOps & Container Hardening

This project demonstrates the container security and optimization engineering implemented for the SAP S/4 Hana testing suite.

## 🛡️ Security Audit Results

A baseline vulnerability scan using **Trivy** on the legacy `debian:buster` Java base image revealed massive exposure:

* **Total Vulnerabilities:** 68
* **High/Critical:** 28 (including glibc and systemd exploits)

## 🚀 The Mitigation Strategy

To achieve an 80%+ reduction in attack surface, the containerization architecture was completely rewritten:

1. **Alpine Linux Migration:** Replaced the heavy GNU C Library (`glibc`) with `musl libc` and `busybox`, reducing the OS footprint to ~5MB.
2. **Multi-Stage Builds:** Decoupled the Maven/JDK build environment from the JRE runtime, ensuring no compiler tools or source code ever reach the production container.
3. **Principle of Least Privilege:** Hardened the runtime execution by explicitly creating a non-root `spring:spring` user group, preventing root escalation in the event of a container breakout.

The resulting `eclipse-temurin:21-jre-alpine` image scans with **0 Critical/High CVEs**.
