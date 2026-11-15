# Terraform Digital Sovereignty Assignment

**Student:** James Smith  
**Module:** DevOps and Cloud Automation  
**Institution:** Atlantic Technological University (ATU)

---

# Introduction

This project demonstrates the implementation of **Policy as Code (PaC)** using Terraform, HashiCorp Sentinel and HCP Terraform. The objective of the assignment was to develop and enforce governance controls that support digital sovereignty, infrastructure security and Infrastructure as Code (IaC) supply-chain governance.

The solution combines Terraform Infrastructure as Code with Sentinel policy enforcement to validate cloud infrastructure before deployment.

---

# Assignment Requirement 1: Digital Sovereignty Controls

## Brief Requirement

> Restrict infrastructure deployments to approved geographical regions.

> Enforce data residency requirements for resources storing sensitive information.

## Implementation

A Sentinel policy was implemented to ensure EC2 instances are deployed only within approved European AWS availability zones.

```hcl
availability_zone = rule {
  all tfplan.resource_changes as _, rc {
    rc.type != "aws_instance" or
    rc.change.after.availability_zone matches
      "^(eu-west-1|eu-west-2|eu-central-1)[a-z]$"
  }
}
```

### Approved Deployment Locations

```text
eu-west-1
eu-west-2
eu-central-1
```

Examples of valid availability zones:

```text
eu-west-1a
eu-west-1b
eu-west-2a
eu-central-1a
```

## Evidence

HCP Terraform successfully evaluated the policy:

```text
availability_zone = true
```

## Discussion

This control contributes to digital sovereignty by ensuring workloads are deployed within approved European jurisdictions.

However, region and availability-zone restrictions alone do not guarantee complete sovereignty. Additional considerations include:

- Backup locations
- Data replication services
- Cloud provider administrative access
- Legal jurisdiction requirements
- Infrastructure managed outside Terraform

---

# Assignment Requirement 2: Infrastructure Security Controls

## Brief Requirement

> Implement infrastructure security controls that enforce organisational security standards.

---

## Encryption at Rest

### Objective

Require encryption of EC2 root storage volumes.

### Policy

```hcl
encryption = rule {
  all tfplan.resource_changes as _, rc {
    rc.type != "aws_instance" or (
      length(rc.change.after.root_block_device) > 0 and
      rc.change.after.root_block_device[0].encrypted
    )
  }
}
```

### Evidence

```text
encryption = true
```

### Security Benefit

Protects data stored on virtual machine disks and supports compliance requirements.

---

## Instance Type Governance

### Objective

Restrict deployment to approved instance sizes.

### Approved Types

```text
t2.micro
t3.micro
```

### Policy

```hcl
instance = rule {
  all tfplan.resource_changes as _, rc {
    rc.type != "aws_instance" or
    rc.change.after.instance_type in allowed_types
  }
}
```

### Evidence

```text
instance = true
```

### Security Benefit

Supports cost management, governance and workload standardisation.

---

## IMDSv2 Enforcement

### Objective

Require the use of AWS Instance Metadata Service Version 2.

### Policy

```hcl
metadata = rule {
  all tfplan.resource_changes as _, rc {
    rc.type != "aws_instance" or (
      length(rc.change.after.metadata_options) > 0 and
      rc.change.after.metadata_options[0].http_tokens is "required"
    )
  }
}
```

### Evidence

```text
metadata = true
```

### Security Benefit

Reduces exposure to credential theft and metadata-service attacks.

---

## Network Security

### Objective

Prevent unrestricted SSH access.

### Policy

```hcl
network = rule {
  all tfplan.resource_changes as _, rc {
    rc.type != "aws_security_group_rule" or
    not (
      rc.change.after.from_port is 22 and
      rc.change.after.to_port is 22 and
      "0.0.0.0/0" in rc.change.after.cidr_blocks
    )
  }
}
```

### Evidence

```text
network = true
```

### Security Benefit

Prevents administrators from exposing SSH administration interfaces to the public internet.

---

## Governance Tag Enforcement

### Objective

Require mandatory governance tags.

### Required Tags

```text
Environment
Owner
AssignmentName
```

### Policy

```hcl
tags = rule {
  all tfplan.resource_changes as _, rc {
    (
      rc.type != "aws_instance" and
      rc.type != "aws_s3_bucket" and
      rc.type != "aws_security_group"
    ) or (
      rc.change.after.tags.Environment is not null and
      rc.change.after.tags.Owner is not null and
      rc.change.after.tags.AssignmentName is not null
    )
  }
}
```

### Evidence

```text
tags = true
```

### Security Benefit

Provides accountability, ownership tracking and governance compliance.

---

# Assignment Requirement 3: IaC Supply Chain Security

## Brief Requirement

> Restrict Terraform providers to approved sources.

> Enforce approved provider versions.

> Require trusted Terraform module sources and pinned versions.

> Address provider integrity, module provenance and dependency verification.

## HCP Terraform Research

To understand the data available within Sentinel, HCP Terraform tfconfig/v2 mock data was downloaded and analysed.

The downloaded metadata exposed provider information in the following format:

```hcl
providers = {
  "aws": {
    "full_name": "registry.terraform.io/hashicorp/aws",
    "version_constraint": "~> 5.0"
  }
}
```

The research demonstrated that HCP Terraform exposes:

- Provider source information through `full_name`
- Provider version information through `version_constraint`

### Approved Provider

```text
registry.terraform.io/hashicorp/aws
```

### Approved Version Constraint

```text
~> 5.0
```

## Module Governance Research

Downloaded configuration metadata contained:

```hcl
module_calls = {}
```

This confirmed that:

- No external Terraform modules were used.
- No third-party module dependencies were present.
- No module provenance risks existed within the submitted implementation.

## Discussion

Supply-chain security is critical because infrastructure deployments depend on third-party components.

Potential risks include:

- Compromised provider releases
- Malicious provider updates
- Vulnerable provider versions
- Insecure module dependencies
- Software supply-chain attacks

Understanding provider provenance and dependency behaviour improves cloud governance and infrastructure security.

---

# Assignment Requirement 4: Testing and Validation

## Brief Requirement

> Demonstrate policy operation through testing and validation.

## Local Sentinel Testing

Pass and fail test cases were developed for:

- Digital sovereignty policies
- Encryption policies
- Instance type governance
- IMDSv2 enforcement
- Network controls
- Tagging governance

Testing was performed using the Sentinel CLI.

## HCP Terraform Validation

The policy set was uploaded into HCP Terraform and evaluated against a real Terraform plan.

### Result

```text
Sentinel Result: true
```

### Final Evaluation Output

```text
availability_zone = true
encryption        = true
instance          = true
metadata          = true
network           = true
provider          = true
tags              = true
main              = true
```

All implemented controls successfully validated the Terraform configuration.

---
## Differences Between Local Sentinel and HCP Terraform

During development, a significant difference was identified between the functionality available through the local Sentinel CLI and the functionality available within HCP Terraform.

The local Sentinel CLI was sufficient for:

- Developing Sentinel policies
- Creating pass and fail test cases
- Executing local policy tests using mock data
- Verifying policy logic

However, certain Terraform-specific Sentinel imports and metadata were only fully available within HCP Terraform.

Examples include:

- `tfconfig/v2`
- Terraform provider metadata
- Provider version constraints
- Provider source information
- Terraform configuration metadata generated during plan execution

As a result, some policy development and troubleshooting activities could not be completed using the local Sentinel CLI alone and required investigation within HCP Terraform.

This included:

- Analysis of downloaded `tfconfig/v2` mock data
- Investigation of provider metadata structures
- Validation of provider version information
- Examination of module metadata and dependency information

The final implementation therefore used a combination of:

1. Local Sentinel testing for policy development and pass/fail validation.
2. HCP Terraform policy evaluation for Terraform-specific configuration metadata and final policy verification.

This combination provided a more complete understanding of Sentinel policy behaviour than would have been possible using either environment in isolation.

# Assignment Requirement 5: Effectiveness of Policy as Code

## Brief Requirement

> Discuss the effectiveness of Policy as Code.

### Evaluation

Policy as Code provides multiple governance benefits:

- Consistent application of security controls
- Automated compliance validation
- Reduced human error
- Early detection of configuration issues
- Repeatable governance processes
- Improved auditability

The integration of Sentinel with HCP Terraform ensured infrastructure compliance was validated before deployment rather than after implementation.

---

# Assignment Requirement 6: Limitations of Sovereignty Controls

## Brief Requirement

> Discuss limitations of region-based sovereignty controls.

### Evaluation

Although location-based restrictions improve sovereignty, they do not guarantee complete control of data and infrastructure.

Limitations include:

- Administrative access by cloud providers
- Cross-region replication
- Backup and archive storage locations
- Jurisdictional and legal considerations
- Service dependencies managed by the cloud provider

These controls should therefore be viewed as one component of a broader sovereignty strategy.

---

# Assignment Requirement 7: Supply Chain Risks Not Fully Addressable Through Sentinel

## Brief Requirement

> Identify supply chain risks that cannot be addressed through Sentinel alone.

### Risks

Sentinel cannot fully mitigate:

- Zero-day vulnerabilities
- Compromised trusted providers
- Malicious updates released after approval
- Infrastructure drift after deployment
- Changes performed outside Terraform
- Cloud provider operational risks

Additional security controls are required to manage these risks effectively.

---

# Use of Microsoft Copilot

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

Final implementation decisions remains my decision.

---

# Recommendations and Future Improvements

Future improvements could include:

- Provider governance policy enforcement
- Module provenance validation
- Digital signature verification
- Continuous compliance monitoring
- Infrastructure drift detection
- Automated compliance reporting
- Enhanced S3 governance and encryption controls
- Multi-cloud sovereignty controls

---

# Repository Structure

```text
TerraformDigitalSovereigntyAssignment
│
├── .terraform/
│
├── hcp-research-files/
│   └── hcp-managed-policy.sentinel
│
├── sentinel/
│   │
│   ├── .sentinel/
│   │
│   ├── encryption.sentinel
│   ├── instance.sentinel
│   ├── metadata.sentinel
│   ├── network.sentinel
│   ├── sovereignty.sentinel
│   ├── tags.sentinel
│   ├── sentinel.hcl
│   │
│   └── test/
│       ├── encryption/
│       │   ├── pass.hcl
│       │   └── fail.hcl
│       │
│       ├── instance/
│       │   ├── pass.hcl
│       │   └── fail.hcl
│       │
│       ├── metadata/
│       │   ├── pass.hcl
│       │   └── fail.hcl
│       │
│       ├── network/
│       │   ├── pass.hcl
│       │   └── fail.hcl
│       │
│       ├── sovereignty/
│       │   ├── pass.hcl
│       │   └── fail.hcl
│       │
│       └── tags/
│           ├── pass.hcl
│           └── fail.hcl
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── tfplan
│   └── tfplan.json
│
├── .gitignore
├── LICENSE
└── README.md
```

---

# Conclusion

This project successfully implemented Policy as Code controls using Terraform, Sentinel and HCP Terraform. The solution addressed the assignment requirements through digital sovereignty controls, infrastructure security enforcement, governance validation, testing and HCP Terraform policy evaluation. The project demonstrated both the benefits and limitations of Policy as Code when used to govern cloud infrastructure deployments.