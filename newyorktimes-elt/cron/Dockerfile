# This Dockerfile is based on the image created for my extractload.py
FROM dbt-transform:latest

# Update packages and Install cron
RUN apt-get update && apt-get install -y cron procps docker.io && rm -rf /var/lib/apt/lists/*

# COPY cron/entrypoint.sh /app/entrypoint.sh
# RUN chmod +x /app/entrypoint.sh

# COPY scripts/scheduler.sh /app
RUN chmod +x /app/*.sh

# COPY scripts/create_dbt_profile.sh /app/create_dbt_profile.sh
# RUN chmod +x /app/create_dbt_profile.sh

COPY cron/crontab /etc/cron.d/
RUN chmod 0644 /etc/cron.d/crontab

RUN touch /var/log/cron.log

ENTRYPOINT ["/app/entrypoint.sh"]