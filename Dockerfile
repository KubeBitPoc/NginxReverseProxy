FROM nginx:alpine

COPY frontend.conf /etc/nginx/conf.d/frontend.conf
RUN rm -rf /etc/nginx/conf.d/default.conf
EXPOSE 80

EXPOSE 8080

