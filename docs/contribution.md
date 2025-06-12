# Contributing to LinkVault

## Welcome Contributors! 🎉

We're excited to have you contribute to LinkVault! This guide will help you understand our development workflow, coding standards, and how to submit your contributions effectively.

## Getting Started

### Prerequisites

Before contributing, ensure you have:
- Ruby 3.3.6 installed
- PostgreSQL database
- Node.js and Yarn
- Git configured with your GitLab account
- Basic knowledge of Ruby on Rails

### Development Setup

1. **Fork the Repository**
   - Click "Fork" on the GitLab project page
   - Clone your fork locally:
   ```bash
   git clone git@gitlab.com:yourusername/linkvault.git
   cd linkvault
   ```

2. **Set Up Development Environment**
   ```bash
   # Install dependencies
   bundle install
   yarn install

   # Set up database
   rails db:create db:migrate db:seed

   # Start development server
   ./bin/dev
   ```

3. **Verify Setup**
   - Visit `http://localhost:3000`
   - Create a test user account
   - Ensure all features work as expected

## GitLab Workflow

### Branch Strategy

We follow a **GitLab Flow** model with feature branches:

```
main (protected)
├── feature/add-dark-mode
├── bugfix/fix-login-issue
├── hotfix/security-patch
└── docs/update-readme
```

#### Branch Naming Conventions

- **Features**: `feature/short-description`
- **Bug fixes**: `bugfix/short-description`
- **Hotfixes**: `hotfix/short-description`
- **Documentation**: `docs/short-description`
- **Refactoring**: `refactor/short-description`

### Development Workflow

1. **Create Feature Branch**
   ```bash
   # Start from latest main
   git checkout main
   git pull origin main
   
   # Create feature branch
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Write code following our coding standards
   - Add tests for new functionality
   - Update documentation if needed
   - Commit changes with descriptive messages

3. **Test Your Changes**
   ```bash
   # Run test suite
   rails test
   
   # Run linting
   bundle exec rubocop
   
   # Check for security issues
   bundle exec brakeman
   ```

4. **Push and Create Merge Request**
   ```bash
   git push origin feature/your-feature-name
   ```
   - Create merge request on GitLab
   - Fill out the MR template completely
   - Request review from maintainers

### Commit Message Standards

Follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```bash
feat(links): add bulk delete functionality
fix(auth): resolve session timeout issue
docs(readme): update installation instructions
test(models): add validation tests for Link model
```

## Code Standards

### Ruby/Rails Conventions

We follow [RuboCop Rails Omakase](https://github.com/rails/rubocop-rails-omakase) configuration:

```ruby
# Good
class LinksController < ApplicationController
  def create
    @link = current_user.links.build(link_params)
    
    if @link.save
      redirect_to links_path, notice: 'Link created successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :title, :description, tag_ids: [])
  end
end
```

### Testing Standards

- **Write tests for all new features**
- **Maintain test coverage above 90%**
- **Use descriptive test names**

```ruby
# test/models/link_test.rb
class LinkTest < ActiveSupport::TestCase
  test "should be valid with required attributes" do
    link = Link.new(url: "https://example.com", title: "Test", user: users(:alice))
    assert link.valid?
  end

  test "should require url presence" do
    link = Link.new(title: "Test", user: users(:alice))
    assert_not link.valid?
    assert_includes link.errors[:url], "can't be blank"
  end
end
```

### Frontend Standards

- **Use Stimulus controllers for JavaScript functionality**
- **Follow Tailwind CSS utility classes**
- **Maintain consistent Catppuccin Mocha theme**

```javascript
// app/javascript/controllers/example_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]
  
  connect() {
    console.log("Controller connected")
  }
  
  handleClick(event) {
    // Handle user interaction
  }
}
```

## Merge Request Process

### MR Template

When creating a merge request, include:

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] Added tests for new functionality
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

### Review Process

1. **Automated Checks**
   - CI pipeline must pass
   - All tests must pass
   - RuboCop linting must pass
   - Brakeman security scan must pass

2. **Code Review**
   - At least one maintainer approval required
   - Address all review feedback
   - Resolve any merge conflicts

3. **Merge Strategy**
   - Squash commits for feature branches
   - Merge commit for release branches
   - Fast-forward for hotfixes

## Issue Management

### Reporting Issues

When reporting bugs or requesting features:

1. **Search existing issues** first
2. **Use issue templates** when available
3. **Provide detailed information**:
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Environment details
   - Screenshots if applicable

### Issue Labels

We use GitLab labels for organization:

- **Type**: `bug`, `feature`, `enhancement`, `documentation`
- **Priority**: `priority::high`, `priority::medium`, `priority::low`
- **Status**: `status::in-progress`, `status::blocked`, `status::needs-review`
- **Component**: `component::frontend`, `component::backend`, `component::database`

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for backward-compatible functionality
- **PATCH** version for backward-compatible bug fixes

### Release Workflow

1. **Create Release Branch**
   ```bash
   git checkout -b release/v1.2.0
   ```

2. **Update Version and Changelog**
   - Update version in relevant files
   - Update `CHANGELOG.md`
   - Test release candidate

3. **Create Release Tag**
   ```bash
   git tag -a v1.2.0 -m "Release version 1.2.0"
   git push origin v1.2.0
   ```

4. **Deploy to Production**
   - Automated deployment via GitLab CI/CD
   - Monitor application health
   - Create GitLab release with notes

## Community Guidelines

### Code of Conduct

- **Be respectful** and inclusive
- **Provide constructive feedback**
- **Help newcomers** get started
- **Focus on technical merit**
- **Maintain professional communication**

### Getting Help

- **Documentation**: Check the [docs/](README.md) folder first, including [Architecture](architecture.md) and [Deployment](deployment.md) guides
- **Setup Issues**: See the main [README](../README.md) for installation and setup
- **Discussions**: Use GitLab discussions for questions
- **Issues**: Create issues for bugs and feature requests
- **Contact**: Reach out to maintainers for urgent matters

## Security

### Reporting Security Issues

**Do not create public issues for security vulnerabilities.**

Contact maintainers privately:
- Email: security@baniobits.dev
- GitLab: Send confidential issue to project maintainers

### Security Best Practices

- **Never commit secrets** to the repository
- **Use environment variables** for sensitive configuration
- **Keep dependencies updated**
- **Follow Rails security guidelines**
- **Test security fixes thoroughly**

## Performance Guidelines

### Database Queries

```ruby
# Good: Use includes to avoid N+1 queries
@links = current_user.links.includes(:tags)

# Bad: N+1 queries
@links = current_user.links
@links.each { |link| puts link.tags.count }
```

### Frontend Performance

- **Minimize JavaScript bundle size**
- **Use Turbo for SPA-like navigation**
- **Optimize images and assets**
- **Implement proper caching strategies**

## Documentation

### Required Documentation

- **Code comments** for complex logic
- **README updates** for new features
- **API documentation** for endpoints
- **Migration guides** for breaking changes

### Documentation Style

- **Clear and concise** language
- **Code examples** when helpful
- **Step-by-step instructions**
- **Screenshots** for UI changes

## Acknowledgments

Thank you for contributing to LinkVault! Your efforts help make this project better for everyone. 

Special thanks to all our contributors:
- [Contributor list will be maintained here]

---

*Made with 💜 by [BanioBits](https://www.baniobits.dev/)*

For questions about contributing, please reach out to the maintainers or create a discussion on GitLab.