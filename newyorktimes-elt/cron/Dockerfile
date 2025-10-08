# This Dockerfile is based on the image created for my extractload.py
FROM newyorktimes-elt-extractload

# Update packages and Install cron
RUN apt-get update && apt-get install -y cron procps

COPY scripts/scheduler.sh /app
RUN chmod +x /app/*.sh

COPY cron/crontab /etc/cron.d/
RUN chmod 0644 /etc/cron.d/crontab

RUN touch /var/log/cron.log

# Run cron, and tail the primary cron log
CMD cron && tail -f /var/log/cron.log