FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

# Copy application data.
COPY index.html /usr/share/nginx/html/
COPY image /usr/share/nginx/html/image/

# Expose port 80
EXPOSE 80

