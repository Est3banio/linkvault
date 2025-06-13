# Security Policy

## Supported Versions

We provide security updates for the following versions of LinkVault:

| Version | Supported          |
| ------- | ------------------ |
| 1.4.x   | :white_check_mark: |
| 1.3.x   | :white_check_mark: |
| 1.2.x   | :x:                |
| < 1.2   | :x:                |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

We take security seriously and appreciate your efforts to responsibly disclose any security vulnerabilities you may find.

### How to Report

1. **GitHub Security Advisories (Preferred)**
   - Go to the [Security tab](https://github.com/BanioBitsOpenSource/linkvault/security) of our repository
   - Click "Report a vulnerability"
   - Provide detailed information about the vulnerability

2. **Email**
   - Send an email to: security@baniobits.dev
   - Include "LinkVault Security" in the subject line
   - Provide detailed information as outlined below

### What to Include

When reporting a security vulnerability, please include:

- **Description** of the vulnerability
- **Steps to reproduce** the issue
- **Potential impact** and attack scenarios
- **Affected versions** (if known)
- **Any proof-of-concept code** (if applicable)
- **Your contact information** for follow-up questions

### What to Expect

- **Initial Response**: We will acknowledge your report within 48 hours
- **Assessment**: We will assess the vulnerability and determine its severity
- **Updates**: We will provide regular updates on our progress
- **Resolution**: We will work to resolve the issue as quickly as possible
- **Credit**: We will credit you for the discovery (unless you prefer to remain anonymous)

### Response Timeline

- **Critical vulnerabilities**: Within 24-48 hours
- **High severity**: Within 1 week
- **Medium/Low severity**: Within 2-4 weeks

## Security Best Practices

### For Users

- **Keep your installation updated** to the latest supported version
- **Use strong passwords** for user accounts
- **Enable HTTPS/SSL** in production environments
- **Regularly review user access** and remove unused accounts
- **Monitor application logs** for suspicious activity
- **Use environment variables** for sensitive configuration
- **Implement proper firewall rules** to restrict database access

### For Administrators

- **Database Security**
  - Use strong database passwords
  - Restrict database access to application servers only
  - Regularly backup your database securely
  - Keep PostgreSQL updated to the latest version

- **Server Security**
  - Keep the operating system updated
  - Use SSH keys instead of passwords
  - Implement fail2ban or similar intrusion prevention
  - Monitor server logs for suspicious activity

- **Application Security**
  - Never commit secrets or credentials to version control
  - Use Rails encrypted credentials for secrets management
  - Regularly update dependencies via Dependabot
  - Run security scans (Brakeman) regularly

### For Developers

- **Code Security**
  - Follow Rails security best practices
  - Use parameterized queries (ActiveRecord does this by default)
  - Validate and sanitize all user inputs
  - Implement proper authentication and authorization
  - Use CSRF protection (enabled by default in Rails)

- **Dependency Management**
  - Keep dependencies updated
  - Review dependency security advisories
  - Use `bundle audit` to check for known vulnerabilities
  - Monitor for security updates via Dependabot

## Known Security Measures

LinkVault implements several security measures out of the box:

### Authentication & Authorization
- **Devise** for secure user authentication
- **BCrypt** for password hashing
- **Session-based authentication** with secure cookies
- **Admin-only routes** with proper authorization checks
- **CSRF protection** enabled by default

### Input Validation
- **Strong parameters** for all controller actions
- **ActiveRecord validations** on all models
- **URL validation** for link submissions
- **File type validation** for import functionality

### Security Headers
- **Content Security Policy** (CSP) configured
- **X-Frame-Options** to prevent clickjacking
- **X-Content-Type-Options** to prevent MIME type sniffing
- **X-XSS-Protection** for legacy browser support

### Data Protection
- **Environment-based secrets** management
- **Encrypted credentials** in production
- **Secure session storage**
- **SQL injection prevention** via ActiveRecord

### Infrastructure Security
- **SSL/TLS encryption** via reverse proxy
- **Database connection encryption**
- **Secure Docker container** configurations
- **Network isolation** in production deployments

## Vulnerability Disclosure Policy

We follow responsible disclosure practices:

1. **Private Reporting**: Security issues should be reported privately first
2. **Coordinated Disclosure**: We will work with you to understand and fix the issue
3. **Public Disclosure**: Details will only be made public after a fix is available
4. **Timeline**: We aim to fix critical issues within 30 days of disclosure
5. **Credit**: We will acknowledge your contribution in our security advisories

## Security Updates

Security updates are communicated through:

- **GitHub Security Advisories**
- **Release notes** in the CHANGELOG.md
- **GitHub Releases** with security tags
- **Repository notifications** for watchers

## Security Research

We welcome security research on LinkVault. When conducting security research:

- **Only test against your own installations**
- **Do not access data that doesn't belong to you**
- **Do not perform destructive testing**
- **Respect user privacy** and data protection laws
- **Report findings responsibly** through proper channels

## Bug Bounty

Currently, we do not offer a formal bug bounty program. However, we greatly appreciate security research and will:

- **Acknowledge your contribution** publicly (if desired)
- **Provide early access** to security updates
- **Consider feature requests** from security researchers
- **Offer project swag** when available

## Compliance

LinkVault is designed to help organizations meet various compliance requirements:

- **GDPR Compliance**: User data management and privacy controls
- **Security Standards**: Industry-standard security practices
- **Audit Trails**: Comprehensive logging for security monitoring
- **Data Retention**: Configurable data retention policies

For specific compliance questions, please contact us at security@baniobits.dev.

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
- [Ruby Security Announcements](https://www.ruby-lang.org/en/security/)
- [GitHub Security Features](https://github.com/features/security)

---

*Made with 💜 by [BanioBits](https://www.baniobits.dev/)*

Last updated: January 2025