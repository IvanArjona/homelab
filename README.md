# HomeLab

## Setup

### Clone the repository

```bash
git clone https://github.com/IvanArjona/homelab.git
```

### Copy the example environment file

```bash
cp .env.example .env
```

### Run the setup script

```bash
sudo chmod +x setup.sh
./setup.sh
```

### Run docker compose

```bash
docker-compose up -d
```

### Run backups

```bash
./backup.sh
```
