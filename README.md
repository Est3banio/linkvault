# LinkVault

[![CI](https://github.com/BanioBitsOpenSource/linkvault/workflows/CI/badge.svg)](https://github.com/BanioBitsOpenSource/linkvault/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ruby Version](https://img.shields.io/badge/ruby-3.3.6-red.svg)](https://www.ruby-lang.org/en/news/2024/11/05/ruby-3-3-6-released/)
[![Rails Version](https://img.shields.io/badge/rails-8.0.1-red.svg)](https://rubygems.org/gems/rails/versions/8.0.1)
[![GitHub issues](https://img.shields.io/github/issues/Est3banio/linkvault)](https://github.com/est3banio/linkvault/issues)
[![GitHub stars](https://img.shields.io/github/stars/est3banio/linkvault?style=social)](https://github.com/est3banio/linkvault/stargazers)

LinkVault is a beautifully designed bookmark manager that helps you organize and access your favorite links. Built with Ruby on Rails and styled with the beautiful Catppuccin Mocha theme.

## Features

### Core Functionality

- 🔐 User authentication with secure password reset
- 👥 Invitation-only user registration (public sign-up disabled)
- 📝 Save and organize your web links
- 🏷️ Tag links for easier organization
- 🔍 Filter links by tags and read/unread status
- 📱 Responsive design works on all devices
- 🖼️ Link previews with images and metadata extraction
- ⚡ Real-time updates with Hotwire Turbo
- 📖 Read/unread status tracking

### Admin Management

- 👑 Complete admin dashboard for user management
- ✨ Create, edit, and delete user accounts
- 🛡️ Grant or revoke admin privileges
- 🎯 Admin-only routes and authentication

### Import & Export

- 📤 Bulk link import from CSV files with flexible column mapping
- 🌐 HTML bookmark import (Chrome, Firefox, Netscape format)
- 🔍 Import preview with duplicate detection
- ⚙️ Flexible mapping for title, URL, tags, and description fields

### Mobile & PWA

- 📱 Progressive Web App (PWA) with offline support
- 🚀 Installable on mobile devices and desktop
- 📲 Mobile link sharing with auto-fill integration
- 🔄 Service worker for caching and offline functionality
- ⚡ App shortcuts for quick actions

## Screenshots

### Main Dashboard

<img src="app/assets/images/Dashboard.png" alt="LinkVault Dashboard - Main interface showing saved links with filtering and organization" width="800">

*The main dashboard shows your saved links with powerful filtering options, read/unread status, and tag-based organization.*

### Landing Page

<img src="app/assets/images/StartPage.png" alt="LinkVault Landing Page - Clean, modern interface with Catppuccin Mocha theme" width="800">

*Beautiful landing page showcasing the clean, modern design with the Catppuccin Mocha color scheme.*

## Tech Stack

- Ruby 3.3.6
- Rails 8.0.1
- PostgreSQL
- Hotwire (Turbo and Stimulus)
- Tailwind CSS with Catppuccin Mocha theme
- Docker for deployment

## Quick Start

> [!TIP]
> Want to try LinkVault quickly? Check out our [Docker setup](#docker) for the fastest way to get started!

### Prerequisites

- Ruby 3.3.6
- PostgreSQL
- Node.js and Yarn
- Docker (optional, for deployment)

> [!NOTE]
> For a complete development environment setup, see our [Contributing Guide](CONTRIBUTING.md#development-setup).

### Installation

1. Clone the repository

```bash
git clone https://github.com/est3banio/linkvault.git
cd linkvault
```

2. Install dependencies

```bash
bundle install
yarn install
```

3. Set up the database

```bash
rails db:create db:migrate
```

4. Start the server

```bash
./bin/dev
```

5. Visit `http://localhost:3000` in your browser

## Documentation

For comprehensive documentation, see the [`docs/`](docs/) folder:

- [Architecture Overview](docs/architecture.md) - System design and components
- [Deployment Guide](docs/deployment.md) - Docker, Kamal, and production setup
- [Contributing Guidelines](docs/contribution.md) - Development workflow and standards
- [Changelog](CHANGELOG.md) - Project history and releases

## Development

For local development, the project uses:

- Solid Queue for background job processing
- Ruby's built-in testing framework
- Tailwind CSS for styling
- GitHub Actions for automated testing and deployment

### CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment. The pipeline includes:

- Automated testing on every commit
- Code quality checks with RuboCop
- Security scanning with Brakeman
- Dependency vulnerability scanning
- Import map auditing for JavaScript security

See `.github/workflows/ci.yml` for the complete pipeline configuration.

### User Management

**Important**: LinkVault uses invitation-only registration. Public sign-up is disabled for security and control.

#### Admin Dashboard

LinkVault includes a complete admin dashboard for comprehensive user management. Admin users can:

- **View all registered users** with detailed information
- **Create new user accounts** with email/password
- **Edit existing user information** and update permissions
- **Delete user accounts** (with protection - admins cannot delete their own account)
- **Grant or revoke admin privileges** for other users
- **Monitor user activity** and account status

**Access Requirements:**

- Must be logged in as an admin user
- Admin privileges are managed via the `admin` boolean field in the user model

**Navigation:**

1. Log in as an admin user
2. Click the "Admin" link in the top navigation (only visible to admins)
3. Access the full user management interface at `/admin/users`

**Admin Routes:**

- `/admin/users` - List all users
- `/admin/users/new` - Create new user
- `/admin/users/:id/edit` - Edit user details
- `/admin/users/:id` - View/delete user (with confirmation)

#### Creating Users

**Option 1: Admin Dashboard (Recommended)**

- Log in as an admin user
- Navigate to Admin → Users
- Click "Create New User"
- Fill in email, password, and admin privileges

**Option 2: Rails Console**

```bash
# Start the Rails console
rails console

# Create a regular user
User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123")

# Create an admin user
User.create!(email: "admin@example.com", password: "admin123456", password_confirmation: "admin123456", admin: true)

# Verify the user was created
User.count
```

**Option 3: Database Seeds**
Run `rails db:seed` to create default admin and user accounts:

- Admin: `admin@linkvault.local` / `admin123456`
- User: `user@linkvault.local` / `user123456`

#### User Registration Policy

> [!IMPORTANT]
> LinkVault uses **invitation-only registration** for security and control.

- Public sign-up routes (`/users/sign_up`) are disabled
- Only administrators can create new user accounts via admin dashboard or console
- Existing users can log in normally at `/users/sign_in`
- Password reset functionality remains available for existing users

## Link Import

LinkVault supports bulk importing of links from external sources to help you migrate your existing bookmarks.

### Supported Import Formats

#### CSV Import

- **Flexible column mapping** - supports various column names
- **Supported columns**: Title/Name, URL/Link, Tags/Tag, Description/Notes
- **Duplicate detection** prevents importing the same URL multiple times
- **Preview interface** lets you review links before importing

#### HTML Bookmark Import

- **Browser compatibility** - supports Chrome, Firefox, Safari exports
- **Netscape bookmark format** - standard HTML bookmark format
- **Hierarchical tags** - converts bookmark folders to tags
- **Metadata preservation** - imports titles, URLs, and descriptions

### How to Import Links

1. **Navigate to Import**: Go to `/links/import` or use the "Import Links" button
2. **Choose Format**: Select CSV or HTML file format
3. **Upload File**: Select your bookmark export file
4. **Preview & Map**: Review detected links and map columns if needed
5. **Confirm Import**: Select which links to import and confirm

### Export Your Bookmarks

**From Chrome:**

1. Chrome Menu → Bookmarks → Bookmark Manager
2. Click ⋮ (three dots) → Export bookmarks
3. Save as HTML file

**From Firefox:**

1. Library → Bookmarks → Show All Bookmarks
2. Import and Backup → Export Bookmarks to HTML
3. Save the HTML file

## Progressive Web App (PWA)

LinkVault is a fully featured Progressive Web App that can be installed on your devices for a native app-like experience.

### PWA Features

- **Installable** on mobile devices and desktop computers
- **Offline support** with service worker caching
- **App shortcuts** for quick actions (Dashboard, Add Link, Browse Links)
- **Mobile-optimized** interface with touch-friendly design
- **Share target** - share links directly from other apps on mobile

### Installation

#### Mobile Devices (iOS/Android)

1. Open LinkVault in your mobile browser
2. Look for "Add to Home Screen" or "Install App" prompt
3. Follow the installation prompts
4. Launch from your home screen like a native app

#### Desktop (Chrome/Edge/Safari)

1. Open LinkVault in your browser
2. Look for the install icon in the address bar
3. Click "Install LinkVault" when prompted
4. Access from your applications menu or desktop

### Mobile Link Sharing

When LinkVault is installed as a PWA, you can share links directly from other apps:

1. **From any app** with sharing capability
2. **Select "LinkVault"** in the share menu
3. **Form auto-fills** with the shared URL and extracted metadata
4. **Add tags and description** as needed
5. **Save immediately** to your LinkVault

## Testing

Run the test suite with:

```bash
rails test
```

## Deployment

### Docker

> [!WARNING]
> This Docker setup requires a PostgreSQL database. You'll need to run a PostgreSQL container or connect to an external database.

You can run the application in a Docker container:

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

# Option 2: create a .env file with your keys and secrets
docker run -d -p 3000:80 --env-file .env --name linkvault linkvault
```

**Getting RAILS_MASTER_KEY**: The master key is located in `config/master.key` (not committed to git for security). For new deployments, generate one with `rails credentials:edit` or `bin/rails secret`.

For a complete development setup with database included, see the docker-compose.yml section below.

For a containerized development environment, see [Dev Containers](https://guides.rubyonrails.org/getting_started_with_devcontainer.html).

### Docker Compose (Development)

For local development with a database included, create a `docker-compose.yml`:

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

Then run: `docker-compose up`

### Kamal

The application can also be deployed using Kamal:

```bash
./bin/kamal setup
./bin/kamal deploy
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for detailed information on:

- Development setup and workflow
- GitHub branch strategy and pull request process
- Code standards and testing
- Issue reporting guidelines

### Quick Start for Contributors

<details>
<summary>Click to expand contributor quick start guide</summary>

1. **Fork the project**

   ```bash
   # Fork on GitHub, then clone your fork
   git clone git@github.com:yourusername/linkvault.git
   cd linkvault
   ```

2. **Set up development environment**

   ```bash
   bundle install && yarn install
   rails db:create db:migrate db:seed
   ./bin/dev
   ```

3. **Create your feature branch**

   ```bash
   git checkout -b feature/amazing-feature
   ```

4. **Make your changes and test**

   ```bash
   rails test
   bin/rubocop
   ```

5. **Submit your contribution**

   ```bash
   git commit -m 'Add some amazing feature'
   git push origin feature/amazing-feature
   # Open a Pull Request using our PR template
   ```

</details>

> [!TIP]
> For questions, please check our [documentation](docs/) or create a discussion on GitHub.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Catppuccin](https://github.com/catppuccin/catppuccin) for the beautiful color scheme
- [Tailwind CSS](https://tailwindcss.com/) for the utility-first CSS framework
- [Hotwire](https://hotwired.dev/) for the modern, HTML-over-the-wire approach

## About

Made with 💜 by [Baniobits](https://www.baniobits.dev/)

## Support

If you find LinkVault helpful, please consider:

- ⭐ **Starring** this repository
- 🐛 **Reporting bugs** via our [issue tracker](https://github.com/BanioBitsOpenSource/linkvault/issues)
- 💡 **Suggesting features** using our [feature request template](https://github.com/est3banio/linkvault/issues/new?template=feature_request.md)
- 📖 **Contributing** to the project (see [CONTRIBUTING.md](CONTRIBUTING.md))
- 💬 **Joining discussions** on [GitHub Discussions](https://github.com/est3banio/linkvault/discussions)

## Project Status

[![GitHub Release](https://img.shields.io/github/release/est3banio/linkvault.svg)](https://github.com/est3banio/linkvault/releases/latest)
[![GitHub Activity](https://img.shields.io/github/commit-activity/m/est3banio/linkvault)](https://github.com/est3banio/linkvault/commits/main)
[![GitHub Contributors](https://img.shields.io/github/contributors/est3banio/linkvault)](https://github.com/est3banio/linkvault/graphs/contributors)

- 🚀 **Actively maintained** with regular updates
- 🔒 **Security focused** with automated vulnerability scanning
- 📱 **Mobile-first** design with PWA support
- 🎯 **Production ready** with comprehensive CI/CD pipeline
