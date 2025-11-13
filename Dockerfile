# Purpose:  Project Work
# Author:  Jayant Danech

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

# Copy application data.
COPY index.html /usr/share/nginx/html/
COPY images /usr/share/nginx/html/images/

# Expose port 80
EXPOSE 80

