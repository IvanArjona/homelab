if [ ! -f ~/.rclone/rclone.conf ]; then
    docker run \
        -it \
        --rm  \
        --volume ~/.rclone:/config/rclone \
        --user $(id -u):$(id -g) \
        rclone/rclone:latest \
        config
fi

docker run \
    --rm  \
    --volume ~/.rclone:/config/rclone \
    --volume ~/homelab:/homelab \
    --user $(id -u):$(id -g) \
    rclone/rclone:latest \
    sync \
    --skip-links \
    --exclude ".git/**" \
    --exclude "log/**" \
    --exclude "logs/**" \
    --exclude *.log \
    --exclude *.log.* \
    --exclude log.txt \
    --exclude log.txt.* \
    --exclude cache/** \
    --exclude Backups/** \
    --exclude "/*" \
    /homelab/** backups:backups/homelab
