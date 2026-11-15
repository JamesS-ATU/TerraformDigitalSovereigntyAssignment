# Terraform Digital Sovereignty Assignment

**Student:** James Smith  
**Student Number:** L00205519
**Module:**  IaC for DevOps Pipelines


---

This project demonstrates the implementation of **Policy as Code (PaC)** using Terraform,. The objective of the assignment is to develop and enforce governance controls that support digital sovereignty, infrastructure security and Infrastructure as Code (IaC) supply-chain governance.

### Effectiveness of Policy as Code for Digital Sovereignty
Policy as Code is definitely an effective method of enforcing Digital Sovereignity requirements because it embeds the rules and policies within the overall cloud deployment pipeline and esnsures consistency accross environments. non-compliant resources are just not provisioned which reduces manual reviews and in the case of terraform there is one central repository for all policies rather than policies defined individuallyl for each resource provision. 
But relying solely on PaC as a complete solution is not effective enough, it should be coupled with effective security procedures and policies to prevent manual access and change after deployment

### Limitations of Region-Based Data Residency Controls
In this project, I used a policy to ensure EC2 instances are deployed only within approved European AWS availability zones, but availability zones dont cover every possibility. A PaC policy cannot effectively control how and where backups are stored or replicated to. Cloud providers often replicate data accross regions for disaster recovery and resilience which makes strict adherence to this policy often impossible to guarentee

### Importance of Supply Chain Integrity
The integrity of the supply change is integral to Digital Sovereignty, organizations should be able to trust the software, providers and dependencies within a cloud environment. Use of unverified modules or compromised providers introduces unnecessary risk and compliance issues regardless of where or how the data is stored. Organizations need to eb confident that resources align with security and legal requirements

### Limitations of Sentinel and Terraform Plan-Time Enforcement

The biggest limitation of Sentinel and Terraform is that the policies are only visibible to resources managed by Terraform itself, anything created outside of terraform and deployed seperately will essentially be deployed withou policy checks. organizations will have to adopt an "all-in" type of model which means that terraform only deploys IaC. another limitiation is that sentinel only reviews at deploy time, changes made after a resource has been deployed are not checked by policy and could in theory break the policy

### Challenges of Maintaining Policies as Cloud Environments Evolve

Cloud environments and an organizations reglutaory and legal obligations are continuously changing which means policies will need to change to match. if an organizations policies are too restrictive this will be a bottleneck for development teams. also in the case of Terraform and Sentinel a seperate team may be needed to learn the new application and keep policies up to date. as stated above, policy checking is often performed as the last step before deployment, which can often mean that new or updated policies can create a impediment. 
how to balance flexibility and while still being compliant will be a big challenge for all organizations


---


# Testing
[Soverignty Proof of Testing](sentinel/test/sovereignty/TestingProof.md)

[Encryption Proof of Testing](sentinel/test/encryption/TestingProof.md)

[Instance Proof of Testing](sentinel/test/instance/TestingProof.md)

[Metadata Proof of Testing](sentinel/test/metadata/TestingProof.md)

[Network Proof of Testing](sentinel/test/network/TestingProof.md)

[Provider Proof of Testing](sentinel/test/provider/TestingProof.md)

[Tags Proof of Testing](sentinel/test/tags/TestingProof.md)

---


# Use of LLM

Microsoft Copilot was used throughout the project as a development support tool.

Areas of assistance included:

- Initial high-level policy generation from the supplied brief 
- Terraform troubleshooting
- Sentinel policy development
- Pass/fail mock generation
- HCP Terraform debugging
- Policy validation
- Documentation development
- Research into tfconfig/v2 and tfplan/v2 structures

## Example Copilot Prompts

### Sentinel and Terraform Development

```text
Generate high-level terraform project from uploaded brief 
```

```text
Create a Sentinel policy that only allows EC2 instance types t2.micro and t3.micro.
```

```text
Create pass and fail mock tests for a Sentinel encryption policy.
```

```text
Create a policy preventing unrestricted SSH access.
```

### Digital Sovereignty Research

```text
Should I use AWS regions or availability zones for digital sovereignty controls?
```

```text
Create a Sentinel policy restricting deployment to approved European AWS locations.
```

### HCP Terraform Investigation

```text
How do I inspect tfconfig/v2 values in HCP Terraform?
```

```text
Why is tfconfig.required_providers.aws.source returning undefined?
```

```text
Use downloaded HCP Terraform mock data to build provider governance policies.
```

```text
Implement Terraform module governance using tfconfig/v2 metadata.
```

## Statement of Use

All AI-generated recommendations were independently tested using:

- Terraform plan validation
- Local Sentinel testing
- HCP Terraform policy evaluation

Final implementation decisions remains my own decision.

---

