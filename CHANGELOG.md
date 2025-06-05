# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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