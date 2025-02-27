# LinkVault

<img src="public/icons8-safe-64.svg" alt="LinkVault Logo" width="120">

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

![LinkVault Screenshot](public/screenshot.png)

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

## Testing

Run the test suite with:

```bash
rails test
```

## Deployment

The application can be deployed using Docker and Kamal:

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

Made with Love by [Baniobits](https://www.baniobits.dev/)

