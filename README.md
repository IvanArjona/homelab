# HomeLab

## Setup

### Clone the repository

```bash
git clone https://github.com/IvanArjona/homelab.git
cd homelab
```

### Copy the example environment file

```bash
cp .env.example .env
chmod 600 .env
```

### Run the setup script

```bash
make setup
```

### Start all services

```bash
make up
```

## Usage

```bash
make help          # Show all available commands
make up            # Start all services
make down          # Stop all services
make restart       # Restart all services (or: make restart s=jellyfin)
make logs          # Tail logs (or: make logs s=traefik)
make ps            # List running containers
make status        # Show CPU/memory usage per container
make pull          # Pull latest images
make update        # Pull latest changes (reset local modifications)
make validate      # Validate compose file
make clean         # Remove stopped containers and dangling images
make shell s=NAME  # Open a shell in a container
make recreate s=N  # Force recreate a service
```

## Post-startup

Some services generate API keys on first run. After starting, grab the keys from each service's UI and update your `.env` file, then restart:

```bash
make restart
```
