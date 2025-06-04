# LinkVault

LinkVault is a beautifully designed bookmark manager that helps you organize and access your favorite links. Built with Ruby on Rails and styled with the beautiful Catppuccin Mocha theme.

## Features

- 🔐 User authentication with secure password reset
- 📝 Save and organize your web links
- 🏷️ Tag links for easier organization
- 🔍 Filter links by tags and read/unread status
- 📱 Responsive design works on all devices
- 🖼️ Link previews with images
- ⚡ Real-time updates with Hotwire Turbo

## Screenshots

<img src="public/linkvault.png" alt="LinkVault Screenshot" width="800">

## Tech Stack

- Ruby 3.3.6
- Rails 8.0.1
- PostgreSQL
- Hotwire (Turbo and Stimulus)
- Tailwind CSS with Catppuccin Mocha theme
- Docker for deployment

## Getting Started

### Prerequisites

- Ruby 3.3.6
- PostgreSQL
- Node.js and Yarn
- Docker (optional, for deployment)

### Installation

1. Clone the repository

```bash
git clone https://github.com/yourusername/linkvault.git
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

## Development

For local development, the project uses:

- Solid Queue for background job processing
- Ruby's built-in testing framework
- Tailwind CSS for styling

### Creating a User via Console

To create a user using the Rails console:

```bash
# Start the Rails console
rails console

# Create a new user (adjust email and password as needed)
User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123")

# Verify the user was created
User.count
```

## Testing

Run the test suite with:

```bash
rails test
```

## Deployment

### Docker

**⚠️ Important**: This Docker setup requires a PostgreSQL database. You'll need to run a PostgreSQL container or connect to an external database.

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

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Catppuccin](https://github.com/catppuccin/catppuccin) for the beautiful color scheme
- [Tailwind CSS](https://tailwindcss.com/) for the utility-first CSS framework
- [Hotwire](https://hotwired.dev/) for the modern, HTML-over-the-wire approach

## About

Made with 💜 by [Baniobits](https://www.baniobits.dev/)
