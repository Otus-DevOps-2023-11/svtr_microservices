#FROM python:3.6.0-alpine
FROM python:3.6-alpine

WORKDIR /app
ADD . /app

RUN apk --no-cache --update add build-base && \
    pip install -r /app/requirements.txt && \
    apk del build-base && \
    rm -rf /etc/apk/cache && rm -rf /var/cache/apk

ENV POST_DATABASE_HOST=post_db POST_DATABASE=posts

ENTRYPOINT ["python3", "post_app.py"]
