# CloudLaunch AWS Project

A secure cloud platform demonstrating AWS fundamentals including S3 static website hosting, IAM access control, and VPC network design.

## 🚀 Project Overview

CloudLaunch is a lightweight platform that showcases a basic company website and manages internal private documents using AWS core services. This project demonstrates understanding of AWS fundamentals including S3, IAM, and VPCs with strict access controls for users and resources.

## 🌐 Live Demo

- **S3 Static Website**: [http://cloudlaunch-site-bucket.s3-website-us-east-1.amazonaws.com](emjay static site)
- **CloudFront URL**: [https://d2f3z6njyuqj9n.cloudfront.net/](cloudFront URL)

## 📋 Architecture Overview

### Task 1: Static Website Hosting + IAM Access Control
```
Internet Users
     ↓
S3 Static Website (Public Read-Only)
     ↓
IAM User (Limited Permissions)
     ↓
├── cloudlaunch-site-bucket (GetObject only)
├── cloudlaunch-private-bucket (GetObject + PutObject)
└── cloudlaunch-visible-only-bucket (ListBucket only)
```

### Task 2: VPC Network Design
```
CloudLaunch VPC (10.0.0.0/16)
├── Internet Gateway (cloudlaunch-igw)
├── Public Subnet (10.0.1.0/24) → Internet access
├── App Subnet (10.0.2.0/24) → Private
└── DB Subnet (10.0.3.0/28) → Private
```

## 🛠️ Implementation Details

### Task 1: S3 Static Website Hosting & IAM

#### S3 Buckets Created:
1. **`emjay-cloudlaunch-site-bucket`**
   - Hosts static website (HTML/CSS/JS)
   - Publicly accessible (read-only)
   - Static website hosting enabled
   - CloudFront distribution configured (bonus)

2. **`emjay-cloudlaunch-private-bucket`**
   - Private document storage
   - IAM user has GetObject + PutObject permissions
   - No public access

3. **`emjay-cloudlaunch-visible-only-bucket`**
   - Private bucket
   - IAM user can list bucket contents only
   - No object access permissions

#### IAM User Configuration:
- **Username**: `iam-cloudlaunch-user`
- **Access Type**: AWS Management Console
- **Password Policy**: Must change password on first login
- **Custom Policy**: `IamCloudLaunchUserPolicy` (see below)

### Task 2: VPC Network Architecture

#### VPC Configuration:
- **VPC Name**: `cloudlaunch-vpc`
- **CIDR Block**: `10.0.0.0/16`
- **DNS Support**: Enabled
- **DNS Hostnames**: Enabled

#### Subnets:
| Subnet Name | CIDR Block | Type | Purpose |
|-------------|------------|------|---------|
| emjay-cloudlaunch-public-subnet | 10.0.1.0/24 | Public | Load balancers, public services |
| emjay-cloudlaunch-app-subnet | 10.0.2.0/24 | Private | Application servers |
| emjay-cloudlaunch-db-subnet | 10.0.3.0/28 | Private | Database servers |

#### Routing Configuration:
- **Public Route Table** (`emjay-cloudlaunch-public-rt`):
  - Route: 0.0.0.0/0 →  emjay-cloudlaunch-igw
  - Associated with public subnet
  
- **App Route Table** (`emjay-cloudlaunch-app-rt`):
  - Local routes only (10.0.0.0/16)
  - Associated with app subnet
  
- **DB Route Table** (`emjay-cloudlaunch-db-rt`):
  - Local routes only (10.0.0.0/16)
  - Associated with database subnet

#### Security Groups:
1. **`emjay-cloudlaunch-app-sg`**
   - **Inbound**: HTTP (80) from VPC (10.0.0.0/16)
   - **Purpose**: Application servers

2. **`emjay-cloudlaunch-db-sg`**
   - **Inbound**: MySQL (3306) from App Subnet (10.0.2.0/24)
   - **Purpose**: Database servers

## 🔐 IAM Policy Document

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAllBuckets",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "ListSpecificBuckets",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": [
                "arn:aws:s3:::emjay-cloudlaunch-site-bucket",
                "arn:aws:s3:::emjay-cloudlaunch-private-bucket",
                "arn:aws:s3:::emjay-cloudlaunch-visible-only-bucket"
            ]
        },
        {
            "Sid": "ReadOnlyAccessToSiteBucket",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::emjay-cloudlaunch-site-bucket/*"
        },
        {
            "Sid": "ReadWriteAccessToPrivateBucket",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::emjay-cloudlaunch-private-bucket/*"
        },
        {
            "Sid": "VPCReadOnlyAccess",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeInternetGateways"
            ],
            "Resource": "*"
        }
    ]
}
```

## 🔑 AWS Account Access

**Console URL**: https://123456789012.signin.aws.amazon.com/console *(Replace with your actual Account ID)*

**Account ID**: `123456789012` *(Replace with your actual Account ID)*

**IAM User Credentials**:
- **Username**: `Iam-cloudlaunch-user`
- **Temporary Password**: `Iam-cloudlaunch-user`
- **Note**: User must change password on first login

## ✨ Bonus Features Implemented

- [x] **CloudFront Distribution**
  - Global content delivery network
  - HTTPS support with free SSL certificate
  - Improved performance and security
  - 200+ edge locations worldwide

## 🛡️ Security Best Practices

- **Principle of Least Privilege**: IAM user has minimal required permissions
- **Public Access Control**: Only website bucket allows public read access
- **Network Isolation**: Private subnets have no internet access
- **Security Groups**: Restrictive rules allowing only necessary traffic
- **Force Password Change**: IAM user must update password on first login
- **HTTPS Encryption**: CloudFront provides SSL/TLS termination

## 📊 Resource Summary

### S3 Resources:
- 3 S3 buckets with different access levels
- 1 bucket policy for public website access
- Static website hosting configuration

### IAM Resources:
- 1 IAM user with console access
- 1 custom IAM policy with granular permissions
- Enforced password change policy

### VPC Resources:
- 1 VPC with logical network segmentation
- 3 subnets (public, app, database)
- 1 Internet Gateway
- 3 Route tables with appropriate routing
- 2 Security groups with minimal access rules

### CloudFront Resources (Bonus):
- 1 CloudFront distribution
- Global edge locations enabled
- Free SSL certificate

## 🧪 Testing & Verification

### S3 Website Testing:
1. Access S3 website endpoint - should load CloudLaunch homepage
2. Verify public accessibility without authentication
3. Test CloudFront URL (if implemented)

### IAM User Testing:
1. Login as `iam-cloudlaunch-user` with provided credentials
2. Verify forced password change on first login
3. Test bucket access permissions:
   - Can view all three buckets in S3 console
   - Can download from `emjay-cloudlaunch-site-bucket`
   - Can upload/download from `emjay-cloudlaunch-private-bucket`
   - Can list but not access `emjay-cloudlaunch-visible-only-bucket`
4. Verify VPC read-only access

### VPC Testing:
1. Verify all subnets are created with correct CIDR blocks
2. Check route table associations
3. Confirm security group rules
4. Validate Internet Gateway attachment

## 🏗️ Architecture Decisions

### Why These CIDR Blocks?
- **10.0.0.0/16**: Provides 65,536 IP addresses for future growth
- **10.0.1.0/24**: 256 addresses for public subnet (load balancers)
- **10.0.2.0/24**: 256 addresses for app subnet (web servers)
- **10.0.3.0/28**: 16 addresses for database subnet (minimal requirements)

### Why This IAM Policy Design?
- **Granular permissions**: Each bucket has specific access levels
- **No delete permissions**: Prevents accidental data loss
- **VPC read-only**: Allows infrastructure visibility without modification
- **Principle of least privilege**: Minimal permissions for required functionality

### Why This Network Design?
- **Three-tier architecture**: Separation of concerns (web, app, data)
- **Private subnets**: Database and app tiers isolated from internet
- **Public subnet**: Only for internet-facing components
- **Separate route tables**: Explicit control over traffic flow

## 💰 Cost Optimization

- All resources kept within **AWS Free Tier** limits
- No NAT Gateway deployed (would incur charges)
- No EC2 instances provisioned
- CloudFront Free Tier covers expected traffic
- Efficient use of IP address space

## 🗂️ Project Structure

```
cloudlaunch-project/
├── README.md
├── website/
│   ├── index.html
│   └── error.html
├── policies/
│   ├── cloudlaunch-user-policy.json
│   └── s3-bucket-policy.json
└── documentation/
    ├── architecture-diagram.png
    └── implementation-notes.md
```

## 📚 What I Learned

- **S3 Static Website Hosting**: Configuration and bucket policies
- **IAM Access Control**: Creating users with granular permissions
- **VPC Network Design**: Subnets, routing, and security groups
- **CloudFront CDN**: Global content distribution and HTTPS
- **AWS Security Best Practices**: Least privilege and network isolation
- **Infrastructure Documentation**: Clear architecture communication

## 🔧 Future Enhancements

- Custom domain configuration with Route 53
- SSL certificate for custom domain
- NAT Gateway for private subnet internet access
- Application Load Balancer in public subnet
- RDS database in private subnet
- Auto Scaling Groups for application servers
- CloudWatch monitoring and logging
- AWS WAF for additional security

---

**Project Completed**: [Current Date]  
**AWS Region**: us-east-1  
**Total Resources**: 15+ AWS resources deployed  
**Cost**: $0.00 (Free Tier)

> This project demonstrates fundamental AWS skills in cloud infrastructure, security, and networking suitable for cloud engineering roles.