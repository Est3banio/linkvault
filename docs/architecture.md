# Architecture Documentation

## Overview

LinkVault is a modern Ruby on Rails application that follows a traditional MVC (Model-View-Controller) architecture with modern enhancements through Hotwire for real-time interactivity.

## Technology Stack

### Backend
- **Ruby 3.3.6** - Primary programming language
- **Rails 8.0.1** - Web application framework
- **PostgreSQL** - Primary database for data persistence
- **Solid Queue** - Background job processing
- **Devise** - User authentication and session management

### Frontend
- **Hotwire (Turbo + Stimulus)** - Modern HTML-over-the-wire approach
- **Tailwind CSS** - Utility-first CSS framework
- **Catppuccin Mocha Theme** - Color scheme and design system
- **JavaScript/ES6** - Client-side interactivity

### Infrastructure
- **Docker** - Containerization for deployment
- **Kamal** - Modern deployment tool
- **GitLab CI/CD** - Continuous integration and deployment

## Application Structure

### Directory Organization

```
linkvault/
├── app/
│   ├── controllers/        # Request handling and routing logic
│   │   ├── admin/         # Admin-only controllers
│   │   │   └── users_controller.rb # User management
│   │   ├── concerns/      # Shared controller logic
│   │   │   └── admin_authentication.rb # Admin auth
│   │   ├── users/         # Custom Devise controllers
│   │   │   └── registrations_controller.rb
│   │   ├── application_controller.rb
│   │   ├── home_controller.rb
│   │   └── links_controller.rb # Enhanced with import
│   ├── models/            # Data models and business logic
│   │   ├── link.rb        # Enhanced core link entity
│   │   ├── tag.rb         # Enhanced tagging system
│   │   ├── link_tag.rb    # Many-to-many relationship
│   │   └── user.rb        # Enhanced user management
│   ├── services/          # Business logic services
│   │   └── link_metadata_service.rb # URL metadata extraction
│   ├── views/             # User interface templates
│   │   ├── admin/         # Admin interface views
│   │   │   └── users/     # User management UI
│   │   ├── layouts/       # Application layouts
│   │   ├── links/         # Enhanced link management views
│   │   │   ├── import.html.erb # Import interface
│   │   │   └── import_preview.html.erb
│   │   ├── pwa/           # PWA-specific views
│   │   ├── devise/        # Authentication views
│   │   └── home/          # Landing page
│   ├── javascript/        # Frontend JavaScript
│   │   ├── controllers/   # Stimulus controllers
│   │   └── application.js # Main JS entry point
│   ├── assets/           # Static assets
│   │   ├── stylesheets/  # CSS files
│   │   └── images/       # Image assets
│   └── helpers/          # View helper methods
├── public/               # Public static files
│   ├── manifest.webmanifest # PWA manifest
│   └── service-worker.js    # PWA service worker
├── config/               # Application configuration
│   ├── routes.rb         # URL routing
│   ├── database.yml      # Database configuration
│   └── initializers/     # App initialization
├── db/                   # Database related files
│   ├── migrate/          # Database migrations
│   └── schema.rb         # Current database schema
└── test/                 # Test suite
    ├── controllers/      # Controller tests
    ├── models/          # Model tests
    └── fixtures/        # Test data
```

## Core Components

### Models

#### User Model (`app/models/user.rb`)
- Handles user authentication via Devise
- Manages user sessions and password resets
- Has many links through association
- **Admin system** with boolean `admin` field for privilege management
- **Custom registration** with invitation-only access

#### Link Model (`app/models/link.rb`)
- Core entity representing saved bookmarks
- Contains URL, title, description, and metadata fields
- **Image URL storage** for link thumbnails and previews
- **Read/unread status** tracking with boolean `read` field
- **Metadata extraction** support via LinkMetadataService
- Belongs to user, has many tags through link_tags
- **Import validation** for bulk operations

#### Tag Model (`app/models/tag.rb`)
- Represents categorization labels
- Has many links through link_tags
- Enables filtering and organization
- **Name normalization** (strip, downcase, uniqueness validation)
- **Length constraints** and presence validation

#### LinkTag Model (`app/models/link_tag.rb`)
- Join table for many-to-many relationship
- Links tags to specific bookmarks
- **Bulk operations** support for import functionality

### Controllers

#### ApplicationController
- Base controller with shared functionality
- Authentication requirements and current user setup
- Common before_actions and error handling

#### LinksController
- **CRUD operations** for bookmarks (create, read, update, delete)
- **Filtering by tags** and read/unread status
- **Real-time updates** via Turbo Streams
- **Import functionality** - CSV and HTML bookmark import
- **Preview interface** for import confirmation
- **Mobile sharing** support with auto-fill

#### Admin::UsersController (`app/controllers/admin/users_controller.rb`)
- **Admin-only user management** interface
- **CRUD operations** for user accounts
- **Privilege management** (grant/revoke admin status)
- **Protected routes** with admin authentication concern

#### HomeController
- Landing page and dashboard
- User onboarding flow
- **PWA service worker** registration

#### Users::RegistrationsController
- **Custom Devise registration** controller
- **Registration disabled** by default for security
- **Password update logic** without current password requirement

### Services

#### LinkMetadataService (`app/services/link_metadata_service.rb`)
- **URL metadata extraction** using MetaInspector gem
- **Automatic title/description** extraction from web pages
- **Open Graph metadata** parsing for rich previews
- **Error handling** for invalid URLs and network failures
- **Smart fallbacks** when metadata unavailable

### PWA Components

#### Web App Manifest (`public/manifest.webmanifest`)
- **App metadata** (name, description, icons, theme colors)
- **Display preferences** (standalone, fullscreen options)
- **App shortcuts** for quick actions
- **Icon definitions** for various device sizes

#### Service Worker (`public/service-worker.js`)
- **Offline caching** strategy for core resources
- **Network-first** approach for dynamic content
- **Cache management** with versioning
- **Background sync** capabilities

### Views

#### Layout System
- `application.html.erb` - Main application layout
- Responsive design with Tailwind CSS
- Catppuccin Mocha color scheme
- Mobile-first approach

#### Component Architecture
- Partial templates for reusable components
- Stimulus controllers for interactive elements
- Turbo Frames for dynamic content updates

## Data Flow

### Request Lifecycle
1. **Route Resolution** - Rails router matches URL to controller action
2. **Authentication** - Devise middleware validates user session
3. **Controller Processing** - Business logic execution
4. **Model Interaction** - Database queries and data manipulation
5. **View Rendering** - Template compilation with data
6. **Response** - HTML/JSON response to client

### Real-time Updates
1. **User Action** - Form submission or interaction
2. **Turbo Interception** - AJAX request instead of full page reload
3. **Server Processing** - Standard Rails controller action
4. **Turbo Stream Response** - Targeted DOM updates
5. **Client Update** - Specific page elements updated

## Database Schema

### Core Tables

#### Users Table
- **Authentication fields** (email, password, session tokens)
- **Admin privileges** (`admin` boolean field)
- **Timestamps** and Devise tracking fields

#### Links Table
- **Core fields**: `url`, `title`, `description`
- **Metadata fields**: `image_url` for previews
- **Status tracking**: `read` boolean field
- **Associations**: `user_id` foreign key
- **Timestamps**: created_at, updated_at

#### Tags Table
- **Name field** with uniqueness constraints
- **Normalization**: lowercase, stripped names
- **Length validation**: appropriate limits

#### LinkTags Table (Join Table)
- **Foreign keys**: `link_id`, `tag_id`
- **Composite primary key** or unique index
- **Timestamps** for audit trail

### Key Relationships
- User has many Links (1:N)
- User has admin privileges (boolean field)
- Link has many Tags through LinkTags (N:M)
- Tag has many Links through LinkTags (N:M)
- Link belongs to User (with user-scoped access)

### Database Indexes
- **Foreign key indexes** for performance
- **Unique constraints** on email, tag names
- **Composite indexes** for common query patterns

## Security Architecture

### Authentication
- Devise gem for secure user authentication
- BCrypt password hashing
- Session-based authentication
- Password reset functionality

### Authorization
- Controller-level access controls
- User-scoped data access
- CSRF protection enabled
- Secure headers configured

### Data Protection
- Environment-based secrets management
- Database credential encryption
- Secure session storage
- SQL injection prevention through ActiveRecord

## Performance Considerations

### Database Optimization
- Indexed foreign keys
- Efficient query patterns
- Database connection pooling

### Frontend Performance
- Turbo for reduced page loads
- Asset pipeline optimization
- CSS/JS minification in production

### Caching Strategy
- Fragment caching for expensive views
- HTTP caching headers
- CDN support for static assets

## Deployment Architecture

For detailed deployment instructions, see the [Deployment Guide](deployment.md).

### Development Environment
- Local PostgreSQL database
- Rails development server
- Hot reloading for assets
- PWA development with service worker testing

### Production Environment
- Dockerized application containers
- External PostgreSQL database
- Reverse proxy (nginx/Apache) with SSL/TLS termination
- PWA manifest and service worker deployment

### CI/CD Pipeline
- Automated testing on GitLab CI (see [Contributing Guidelines](contribution.md))
- Code quality checks (RuboCop, Brakeman)
- Automated deployment via Kamal
- Environment-specific configurations

## API Endpoints Reference

### Authentication (Devise Routes)
- `POST /users/sign_in` - User authentication
- `DELETE /users/sign_out` - Sign out user
- `GET/POST /users/password` - Password reset functionality

### Core Application Routes
- `GET /` - Landing page (redirects to dashboard if authenticated)
- `GET /dashboard` - User dashboard with statistics

### Links Management API
- `GET /links` - List user links (supports filtering: `?tag=name&status=read`)
- `POST /links` - Create new link
- `GET /links/new` - New link form (supports Web Share Target API)
- `GET/PUT/DELETE /links/:id` - Individual link operations

**Link Parameters:**
- `link[title]`, `link[url]`, `link[description]`, `link[read]`, `link[tags]`

### Import API
- `GET /links/import` - Import interface
- `POST /links/import_preview` - Preview imported links (CSV/HTML upload)
- `POST /links/import_confirm` - Confirm and import selected links

### Admin API (Admin Users Only)
- `GET /admin/users` - List all users
- `POST /admin/users` - Create new user
- `GET/PUT/DELETE /admin/users/:id` - User management operations

**User Parameters:**
- `user[email]`, `user[password]`, `user[password_confirmation]`, `user[admin]`

### PWA API
- `GET /manifest` - PWA manifest (application/manifest+json)
- `GET /service-worker` - Service worker JavaScript

### Response Formats
- **HTML** - Standard web interface
- **Turbo Stream** - Real-time updates
- **JSON** - API-like responses for specific actions

### Authentication & Authorization
- Most endpoints require user authentication via Devise
- Admin endpoints require `admin: true` user attribute
- Web Share Target API supports unauthenticated access with redirect to login

---

*Made with 💜 by [BanioBits](https://www.baniobits.dev/)*