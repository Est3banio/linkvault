# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive documentation review and updates
- Enhanced feature descriptions across all documentation files
- Cross-referencing between documentation files
- Updated API endpoint documentation

## [1.4.0] - 2025-01-06

### Added
- **Progressive Web App (PWA) Support**
  - Complete PWA configuration with web app manifest
  - Service worker for offline functionality and caching
  - App shortcuts for quick actions (Dashboard, Add Link, Browse Links)
  - Mobile-optimized interface with installability support
  - Share target API for direct link sharing from mobile apps

- **Bulk Link Import System**
  - CSV import with flexible column mapping (title/name, url/link, tags/tag, description/notes)
  - HTML bookmark import supporting Chrome, Firefox, Netscape format
  - Import preview interface with duplicate detection
  - Batch selection and confirmation workflow

- **Mobile Link Sharing with Auto-fill**
  - Web Share Target API integration for mobile sharing
  - LinkMetadataService for automatic page metadata extraction
  - Smart form pre-filling with title and description
  - Open Graph metadata parsing for rich link previews

- **Complete Admin System**
  - Admin dashboard for comprehensive user management
  - Create, edit, delete user accounts with admin protection
  - Grant/revoke admin privileges interface
  - Admin-only routes with authentication concern
  - Protected admin navigation (visible only to admins)

### Enhanced
- **User Registration System**
  - Custom registration controller with enhanced security
  - Registration disabled by default (invitation-only)
  - Flexible password update without current password requirement
  - Integration tests for registration security

- **Link Management Improvements**
  - Read/unread status tracking for all links
  - Enhanced metadata extraction and image URL storage
  - Improved tag filtering and management
  - Turbo Stream support for real-time UI updates

## [1.3.0] - 2025-01-06

### Added
- Comprehensive documentation overhaul with docs/ folder structure
- GitLab CI/CD integration and status badges
- Architecture and deployment documentation

### Fixed
- **Edit Link Functionality**: Added missing `edit.html.erb` template that was preventing link editing
- **Tags System**: Complete overhaul of tag functionality
  - Fixed Link model to properly create LinkTag associations through after_save callback
  - Updated view logic to display tags using associations instead of string parsing
  - Fixed tag filtering in controller to use proper joins instead of string matching
  - Added proper validations to Tag model with presence, uniqueness, and length constraints
  - Implemented tag name normalization (strip and downcase)

## [1.2.0] - 2025-01-XX

### Added
- Docker and deployment improvements
- Comprehensive Docker documentation with PostgreSQL setup instructions
- Kamal deployment support
- Rails console user creation instructions
- Improved README with deployment options

### Changed
- Enhanced Docker configuration for production deployments
- Updated deployment documentation with environment variable examples
- Improved development setup instructions

### Security
- Updated dependencies via Dependabot
- Brakeman security scanner updates
- RuboCop Rails Omakase linting improvements

## [1.1.0] - 2025-01-XX

### Added
- Logo and branding improvements
- LinkVault logo assets
- Enhanced visual identity

### Changed
- Updated styling and branding consistency
- Improved UI/UX with logo integration

### Fixed
- RuboCop linting issues resolved
- Code quality improvements

## [1.0.0] - 2025-01-XX

### Added
- Initial release of LinkVault
- User authentication with secure password reset
- Link saving and organization features
- Tag-based link categorization
- Filter links by tags and read/unread status
- Responsive design for all devices
- Link previews with images
- Real-time updates with Hotwire Turbo
- PostgreSQL database integration
- Tailwind CSS with Catppuccin Mocha theme
- Test suite with Rails testing framework

### Technical Stack
- Ruby 3.3.6
- Rails 8.0.1
- PostgreSQL
- Hotwire (Turbo and Stimulus)
- Tailwind CSS
- Docker support

---

*Made with 💜 by [BanioBits](https://www.baniobits.dev/)*