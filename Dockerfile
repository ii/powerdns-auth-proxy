FROM python:3.9.17-alpine3.18

RUN apk add --no-cache tzdata ca-certificates bash the_silver_searcher
RUN adduser -D proxy

WORKDIR /home/proxy/pdns-proxy/

COPY . .

RUN rm proxy.ini \
    && chown -R proxy:proxy /home/proxy/pdns-proxy

USER proxy
ENV VIRTUAL_ENV=/home/proxy/pdns-proxy
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --upgrade pip \
    && pip install requests \
    && pip install waitress \
    && pip install -r requirements-dev.txt

EXPOSE 8000

CMD /home/proxy/pdns-proxy/bin/waitress-serve --listen=0.0.0.0:8000 --call powerdns_auth_proxy:create_app
