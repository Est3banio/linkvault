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
│   │   ├── application_controller.rb
│   │   ├── home_controller.rb
│   │   ├── links_controller.rb
│   │   ├── passwords_controller.rb
│   │   └── users_controller.rb
│   ├── models/            # Data models and business logic
│   │   ├── link.rb        # Core link entity
│   │   ├── tag.rb         # Tagging system
│   │   ├── link_tag.rb    # Many-to-many relationship
│   │   └── user.rb        # User management
│   ├── views/             # User interface templates
│   │   ├── layouts/       # Application layouts
│   │   ├── links/         # Link management views
│   │   ├── devise/        # Authentication views
│   │   └── home/          # Landing page
│   ├── javascript/        # Frontend JavaScript
│   │   ├── controllers/   # Stimulus controllers
│   │   └── application.js # Main JS entry point
│   ├── assets/           # Static assets
│   │   ├── stylesheets/  # CSS files
│   │   └── images/       # Image assets
│   └── helpers/          # View helper methods
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

#### Link Model (`app/models/link.rb`)
- Core entity representing saved bookmarks
- Contains URL, title, description, and metadata
- Supports image previews and read/unread status
- Belongs to user, has many tags through link_tags

#### Tag Model (`app/models/tag.rb`)
- Represents categorization labels
- Has many links through link_tags
- Enables filtering and organization

#### LinkTag Model (`app/models/link_tag.rb`)
- Join table for many-to-many relationship
- Links tags to specific bookmarks

### Controllers

#### ApplicationController
- Base controller with shared functionality
- Authentication requirements
- Common before_actions

#### LinksController
- CRUD operations for bookmarks
- Filtering by tags and read status
- Real-time updates via Turbo Streams

#### HomeController
- Landing page and dashboard
- User onboarding flow

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
- `users` - User accounts and authentication
- `links` - Saved bookmarks with metadata
- `tags` - Categorization labels
- `link_tags` - Many-to-many join table

### Key Relationships
- User has many Links (1:N)
- Link has many Tags through LinkTags (N:M)
- Tag has many Links through LinkTags (N:M)

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

### Development Environment
- Local PostgreSQL database
- Rails development server
- Hot reloading for assets

### Production Environment
- Dockerized application containers
- External PostgreSQL database
- Reverse proxy (nginx/Apache)
- SSL/TLS termination

### CI/CD Pipeline
- Automated testing on GitLab CI
- Code quality checks (RuboCop, Brakeman)
- Automated deployment via Kamal
- Environment-specific configurations

---

*Made with 💜 by [BanioBits](https://www.baniobits.dev/)*