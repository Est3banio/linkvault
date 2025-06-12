# Deployment Documentation

## Overview

LinkVault supports multiple deployment strategies to accommodate different environments and requirements. This document covers all supported deployment methods from development to production.

For system architecture details, see the [Architecture Overview](architecture.md).

## Deployment Methods

### 1. Development Environment

#### Local Development Setup

**Prerequisites:**
- Ruby 3.3.6
- PostgreSQL
- Node.js and Yarn
- Rails 8.0.1

**Setup Steps:**
```bash
# Clone the repository
git clone <repository-url>
cd linkvault

# Install dependencies
bundle install
yarn install

# Set up the database
rails db:create db:migrate

# Start the development server
./bin/dev
```

**Environment Variables:**
- No special configuration required for development
- Uses local PostgreSQL database
- Rails runs in development mode by default

#### Docker Development Environment

Use the provided `docker-compose.yml` for a containerized development setup:

```yaml
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: linkvault_development
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  web:
    build: .
    ports:
      - "3000:80"
    environment:
      DATABASE_URL: postgresql://postgres:password@db:5432/linkvault_development
      RAILS_MASTER_KEY: your_master_key_here
    depends_on:
      - db
    volumes:
      - .:/rails

volumes:
  postgres_data:
```

**Commands:**
```bash
# Start development environment
docker-compose up

# Run migrations
docker-compose exec web rails db:migrate

# Access Rails console
docker-compose exec web rails console
```

### 2. Production Deployment with Docker

#### Manual Docker Deployment

**Build and Run:**
```bash
# Build the Docker image
docker build -t linkvault .

# Option 1: Run with environment variables
export RAILS_MASTER_KEY=$(cat config/master.key)
export DATABASE_URL="postgresql://username:password@host:5432/linkvault_production"

docker run -d -p 3000:80 \
  -e RAILS_MASTER_KEY="$RAILS_MASTER_KEY" \
  -e DATABASE_URL="$DATABASE_URL" \
  --name linkvault linkvault

# Option 2: Use environment file
docker run -d -p 3000:80 --env-file .env --name linkvault linkvault
```

**Required Environment Variables:**
- `RAILS_MASTER_KEY` - Rails application secrets encryption key
- `DATABASE_URL` - PostgreSQL connection string
- `SECRET_KEY_BASE` - Application secret key (optional, auto-generated if not provided)

**Optional Environment Variables:**
- `WEB_CONCURRENCY` - Number of Puma worker processes (default: 1)
- `RAILS_LOG_LEVEL` - Log level (default: info)
- `JOB_CONCURRENCY` - Solid Queue worker concurrency (default: 1)
- `RAILS_SERVE_STATIC_FILES` - Serve static files (enabled by default in production)
- `RAILS_FORCE_SSL` - Force HTTPS connections (recommended for production)
- `MAILER_DEFAULT_HOST` - Host for email links (default: linkvault.baniobits.work)

#### Docker Compose Production

```yaml
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: linkvault_production
      POSTGRES_USER: linkvault
      POSTGRES_PASSWORD: secure_password_here
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  web:
    image: linkvault:latest
    ports:
      - "80:80"
    environment:
      DATABASE_URL: postgresql://linkvault:secure_password_here@db:5432/linkvault_production
      RAILS_MASTER_KEY: your_master_key_here
      RAILS_LOG_LEVEL: info
    depends_on:
      - db
    restart: unless-stopped

volumes:
  postgres_data:
```

### 3. Kamal Deployment

Kamal is the recommended deployment method for production environments. It provides zero-downtime deployments with automatic SSL/TLS certificates.

#### Prerequisites

- Target server with Docker installed
- SSH access to the server
- Domain name pointing to the server

#### Configuration

Edit `config/deploy.yml`:

```yaml
service: linkvault
image: your-registry/linkvault

servers:
  web:
    - your-server-ip

proxy:
  ssl: true
  host: your-domain.com

registry:
  username: your-registry-username
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  secret:
    - RAILS_MASTER_KEY
  clear:
    SOLID_QUEUE_IN_PUMA: true
```

#### Secrets Management

Create `.kamal/secrets` file:
```bash
KAMAL_REGISTRY_PASSWORD=your_registry_password
RAILS_MASTER_KEY=your_rails_master_key
```

#### Deployment Commands

```bash
# Initial setup (first deployment)
./bin/kamal setup

# Deploy application
./bin/kamal deploy

# Common operations
./bin/kamal console    # Access Rails console
./bin/kamal shell      # Access container shell
./bin/kamal logs       # View application logs
./bin/kamal dbc        # Access database console
```

#### Database Configuration for Kamal

**Option 1: External Database Service**
```yaml
env:
  clear:
    DB_HOST: your-db-host.com
    DB_NAME: linkvault_production
    DB_USER: linkvault
  secret:
    - DB_PASSWORD
```

**Option 2: Database Accessory (Same Server)**
```yaml
accessories:
  db:
    image: postgres:15
    host: your-server-ip
    port: "127.0.0.1:5432:5432"
    env:
      clear:
        POSTGRES_DB: linkvault_production
        POSTGRES_USER: linkvault
      secret:
        - POSTGRES_PASSWORD
    directories:
      - data:/var/lib/postgresql/data
```

## Environment-Specific Configurations

### Development vs Production

| Feature | Development | Production |
|---------|-------------|------------|
| Database | Local PostgreSQL | External PostgreSQL |
| Assets | Live compilation | Precompiled |
| Caching | Disabled | Enabled |
| SSL | Not required | Required (auto via Let's Encrypt) |
| Logging | Debug level | Info level |
| Job Processing | Inline | Background (Solid Queue) |

### Security Considerations

#### Production Security Checklist

- [ ] **SSL/TLS enabled** - Automatic with Kamal proxy
- [ ] **Environment secrets secured** - Use `.kamal/secrets` or environment variables
- [ ] **Database credentials encrypted** - Never commit credentials to git
- [ ] **Master key secured** - Store securely, never commit to repository
- [ ] **Regular security updates** - Keep dependencies updated
- [ ] **Firewall configured** - Restrict database access to application servers only

#### Environment Variables Security

```bash
# Good: Use environment files
docker run --env-file .env linkvault

# Good: Use secret management
echo "RAILS_MASTER_KEY=abc123" > .kamal/secrets

# Bad: Expose secrets in command line
docker run -e RAILS_MASTER_KEY=abc123 linkvault  # Visible in process list
```

## Monitoring and Maintenance

### Health Checks

The application provides health check endpoints:
- `/` - Basic application health
- Rails built-in health checks available

### Log Management

```bash
# Kamal deployment logs
./bin/kamal logs

# Docker logs
docker logs linkvault

# Application logs location
/rails/log/production.log  # Inside container
```

### Database Management

```bash
# Run migrations
./bin/kamal app exec "bin/rails db:migrate"

# Database console
./bin/kamal dbc

# Backup database (external PostgreSQL)
pg_dump $DATABASE_URL > backup.sql
```

### Performance Optimization

#### Production Optimizations

- **Asset precompilation** - Done during Docker build
- **Database connection pooling** - Configured automatically
- **Puma web server** - Multi-threaded, configurable workers
- **Solid Queue** - Background job processing
- **Jemalloc** - Memory allocator for better performance

#### Scaling Considerations

```yaml
# Horizontal scaling with Kamal
servers:
  web:
    - server1.example.com
    - server2.example.com
  job:
    hosts:
      - worker1.example.com
    cmd: bin/jobs

env:
  clear:
    WEB_CONCURRENCY: 3  # Puma workers per server
    JOB_CONCURRENCY: 5  # Solid Queue workers
```

## Troubleshooting

### Common Issues

**Database Connection Errors:**
```bash
# Check database connectivity
./bin/kamal app exec "bin/rails runner 'ActiveRecord::Base.connection'"

# Verify environment variables
./bin/kamal app exec "printenv | grep DATABASE"
```

**Asset Loading Issues:**
```bash
# Recompile assets
./bin/kamal app exec "bin/rails assets:precompile"

# Check asset paths
./bin/kamal app exec "ls -la /rails/public/assets"
```

**SSL Certificate Issues:**
```bash
# Check proxy status
./bin/kamal proxy logs

# Restart proxy
./bin/kamal proxy restart
```

### Rollback Procedures

```bash
# List previous versions
./bin/kamal app versions

# Rollback to previous version
./bin/kamal rollback

# Rollback to specific version
./bin/kamal rollback <version-tag>
```

## CI/CD Integration

For detailed information about the development workflow and CI/CD pipeline, see the [Contributing Guidelines](contribution.md).

### GitLab CI/CD Pipeline

The application includes GitLab CI/CD configuration (`.gitlab-ci.yml`) for automated deployments:

```yaml
stages:
  - test
  - build
  - deploy

test:
  stage: test
  script:
    - bundle install
    - rails test

build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

deploy:
  stage: deploy
  script:
    - ./bin/kamal deploy
  only:
    - main
```

### Deployment Automation

- **Automated testing** on every commit
- **Container building** and registry push
- **Zero-downtime deployment** via Kamal
- **Rollback capabilities** on deployment failures

---

*Made with 💜 by [BanioBits](https://www.baniobits.dev/)*