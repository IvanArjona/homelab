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

## Deployment

```bash
make deploy        # Sync files to server and run make up
make sync          # Sync files to server without restarting
make ssh           # Open an SSH session to the server
```

`deploy` syncs all git-tracked and modified files to the server via rsync, then runs `make up` remotely. Use `sync` alone if you just want to push files without restarting services.

The server connection is configured via `USER` and `PUBLIC_DOMAIN` in your `.env` file.

## Post-startup

Some services generate API keys on first run. After starting, grab the keys from each service's UI and update your `.env` file, then restart:

```bash
make restart
```
