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

### Add an Authelia user

Create at least one user for the authentication portal before starting:

```bash
make add-user user=admin email=admin@example.com pass=yourpassword groups=admin
make add-user user=user email=user@example.com pass=yourpassword groups=user
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
make add-user      # Add an Authelia user (user= email= pass= groups=)
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

## Authentication

[Authelia](https://www.authelia.com/) provides SSO for services behind Traefik. The login portal is available at `https://auth.<DOMAIN>`.

Services with their own authentication (Jellyfin, n8n, Seerr) bypass Authelia. All other services require login.

To add more users:

```bash
make add-user user=username email=user@example.com pass=password groups=admin
make recreate s=authelia
```
