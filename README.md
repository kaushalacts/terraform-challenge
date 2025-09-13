# 🚀 Terraform Day 29 Challenge - AWS EC2 Deployment

A complete Terraform project that deploys an EC2 instance with nginx web server on AWS using best practices and modular file structure.

## 📁 Project Structure

```
terraform-day29-challenge/
├── main.tf                 # Main infrastructure resources
├── providers.tf           # Provider configurations
├── variables.tf           # Variable definitions
├── outputs.tf             # Output definitions
├── terraform.tfvars.example  # Example variable values
├── user_data.sh          # EC2 bootstrap script
├── .gitignore            # Git ignore rules
├── README.md             # This file
└── .terraform/           # Terraform working directory (auto-created)
```

## 🎯 Challenge Requirements ✅

- ✅ **Initialize a provider** (AWS)
- ✅ **Create one virtual machine** (EC2 t2.micro - free tier)
- ✅ **Output the public IP** of the VM
- ✅ **Bonus**: Complete VPC setup + nginx web server

## 📋 Prerequisites

1. **AWS Account** with free tier access
2. **AWS CLI** installed and configured
   ```bash
   aws configure
   ```
3. **Terraform** installed (>= 1.0)
   ```bash
   # Download from: https://www.terraform.io/downloads
   terraform version
   ```
4. **AWS Key Pair** created in your AWS region
   - Go to EC2 → Key Pairs → Create Key Pair
   - Download the `.pem` file
   - Note the key pair name for configuration

## 🚀 Quick Start

### 1. Clone/Download Project Files
```bash
mkdir terraform-day29-challenge
cd terraform-day29-challenge
# Copy all the .tf files from the artifacts above
```

### 2. Configure Variables
```bash
# Copy the example tfvars file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
nano terraform.tfvars
```

**Important**: Update these values in `terraform.tfvars`:
- `key_name` = "your-aws-key-pair-name"
- `aws_region` = "your-preferred-region"

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan the Deployment
```bash
terraform plan
```

### 5. Apply the Configuration
```bash
terraform apply
```

### 6. Access Your Website
After successful deployment, visit the output URL:
```
http://YOUR_INSTANCE_PUBLIC_IP
```

## 📊 What Gets Created

### AWS Resources:
- **VPC** with DNS support
- **Internet Gateway**
- **Public Subnet** 
- **Route Table** with internet access
- **Security Group** (SSH, HTTP, HTTPS)
- **EC2 Instance** (t2.micro)
- **Elastic IP** association

### Software Installed:
- **Nginx** web server
- **Custom HTML** page with instance details
- **System updates** and useful packages

## 🔧 Terraform Commands Explained

### Core Workflow:
```bash
# 1. Initialize (downloads providers, sets up backend)
terraform init

# 2. Validate configuration
terraform validate

# 3. Format code
terraform fmt

# 4. Plan changes (dry-run)
terraform plan

# 5. Apply changes
terraform apply

# 6. Show current state
terraform show

# 7. List resources
terraform state list

# 8. Get outputs
terraform output

# 9. Destroy everything
terraform destroy
```

### Advanced Commands:
```bash
# Plan with saved output
terraform plan -out=tfplan
terraform apply tfplan

# Target specific resources
terraform plan -target=aws_instance.web_server
terraform apply -target=aws_instance.web_server

# Refresh state
terraform refresh

# Import existing resources
terraform import aws_instance.web_server i-1234567890abcdef0
```

## 💡 Challenge Questions & Answers

### Q: Why use `terraform init`, `terraform plan`, and `terraform apply` separately?

**Answer:**

#### `terraform init`
- **Purpose**: Prepares working directory
- **Actions**: Downloads providers, initializes backend, validates syntax
- **When**: First time, new providers, backend changes

#### `terraform plan` 
- **Purpose**: Preview changes without making them
- **Benefits**: Safety, cost estimation, team review
- **Output**: Execution plan showing what will be created/modified/destroyed

#### `terraform apply`
- **Purpose**: Execute the planned changes
- **Safety**: Shows plan before execution, asks for confirmation
- **Actions**: Creates/modifies/destroys resources, updates state

### Q: What happens if you run `terraform apply` directly?

**Answer:**
- ✅ **It works!** Terraform runs plan internally first
- ⚠️ **But**: No time to review, harder to catch issues
- 🏆 **Best Practice**: Always run plan separately for safety

## 🔒 Security Considerations

### Current Setup (Development):
- SSH access from anywhere (`0.0.0.0/0`)
- HTTP/HTTPS access from anywhere

### Production Recommendations:
```hcl
# In terraform.tfvars
allowed_ssh_cidrs = ["YOUR_PUBLIC_IP/32"]  # Replace with your IP
```

### Additional Security:
- Use IAM roles instead of access keys
- Enable VPC Flow Logs
- Use AWS Systems Manager for access
- Implement proper backup strategies

## 📈 Monitoring & Maintenance

### Check Instance Status:
```bash
# Get outputs
terraform output

# SSH to instance
ssh -i ~/.ssh/your-key.pem ec2-user@$(terraform output -raw instance_public_ip)

# Check nginx status
sudo systemctl status nginx

# View logs
sudo tail -f /var/log/user-data.log
```

### Updating Infrastructure:
1. Modify `.tf` files
2. Run `terraform plan`
3. Review changes
4. Run `terraform apply`

## 🧹 Cleanup

### Destroy All Resources:
```bash
terraform destroy
```

### Verify Cleanup:
```bash
# Check AWS Console
# Verify no resources remain
terraform show
```

## 🎓 Learning Outcomes

After completing this challenge, you'll understand:

- ✅ Terraform file structure and best practices
- ✅ AWS provider configuration
- ✅ Resource dependencies and data sources
- ✅ Variable management and validation
- ✅ Output values and their uses
- ✅ Infrastructure as Code principles
- ✅ Terraform state management basics

## 🤝 Troubleshooting

### Common Issues:

1. **"Key pair not found"**
   - Create key pair in AWS Console
   - Update `key_name` in `terraform.tfvars`

2. **"Access denied"**
   - Check AWS credentials: `aws sts get-caller-identity`
   - Verify IAM permissions

3. **"Instance launch failed"**
   - Check if region has t2.micro availability
   - Verify free tier limits

4. **"Website not accessible"**
   - Wait 2-3 minutes for user data script
   - Check security group rules
   - Verify nginx status: `sudo systemctl status nginx`

### Debug Commands:
```bash
# Terraform debug
export TF_LOG=DEBUG
terraform apply

# AWS CLI debug
aws ec2 describe-instances --debug

# Check user data logs
ssh -i ~/.ssh/key.pem ec2-user@IP
sudo tail -f /var/log/user-data.log
```

## 🌟 Next Steps

1. **Add HTTPS**: Configure SSL certificate
2. **Auto Scaling**: Add ASG and ALB
3. **Multiple Environments**: Use workspaces
4. **Remote State**: Configure S3 backend
5. **Modules**: Convert to reusable modules
6. **CI/CD**: Add GitHub Actions pipeline

## 📚 Additional Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Free Tier Details](https://aws.amazon.com/free/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

## 🏷️ Tags
`#justvisualise` `#DevOps` `#Terraform` `#IaC` `#AWS` `#EC2` `#Day29Challenge`

---
**Happy Learning! 🚀** 

*This project demonstrates Infrastructure as Code principles using Terraform with AWS.*