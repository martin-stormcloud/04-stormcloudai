# ── StormCloud AI — Static Site ──
# Serves static HTML/CSS/JS via nginx
# Phase 1: local dev & S3+CloudFront deployment target

FROM nginx:1.27-alpine

# Remove default nginx config and default content
RUN rm /etc/nginx/conf.d/default.conf \
    && rm -rf /usr/share/nginx/html/*

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/stormcloud.conf

# Copy static site files
COPY index.html    /usr/share/nginx/html/
COPY about.html    /usr/share/nginx/html/
COPY services.html /usr/share/nginx/html/
COPY contact.html  /usr/share/nginx/html/
COPY pricing.html  /usr/share/nginx/html/
COPY digital-marketing.html /usr/share/nginx/html/
COPY favicon.svg   /usr/share/nginx/html/
COPY css/          /usr/share/nginx/html/css/
COPY js/           /usr/share/nginx/html/js/

# Run as non-root user (nginx worker already does, but harden the setup)
RUN chown -R nginx:nginx /usr/share/nginx/html \
    && chmod -R 755 /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
