![Actively maintained](https://img.shields.io/maintenance/yes/2018.svg) ![Nginx 1.12.2](https://img.shields.io/badge/Nginx-1.12.2-brightgreen.svg) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../LICENSE)

# Nginx (aisberg/nginx)



## Configuration Parameters
Alle Argumente sind optional und werden, falls nicht gegeben, auf ihren Standardwert gesetzt.

##### Nginx

Parameter | Description | Default
----------|-------------|--------
`NGINX_WORKER_PROCESSES` | Number of worker processes. A good starting point for a value could be the number of available cpu cores. | 1
`NGINX_WORKER_CONNECTIONS` | Maximale simultane Verbindungen pro Worker-Prozess. | 1024
`NGINX_WORKER_OPENED_FILES` | Maximale simultane Verbindungen pro Worker-Prozess. | 20000
`NGINX_POST_MAX_SIZE` | Maximale Größe der Anfrage. Bei Uploads von größeren Dateien, muss diese Einstellung entsprechend angepasst werden. | 512M
`NGINX_KEEPALIVE_TIMEOUT` | Ein länger laufende Anfrage wird nach dieser Zeit (s) abgebrochen. | 75
`NGINX_CONN_LIMIT_PER_IP` | Maximale gleichzeitige Verbindungen pro IP. | 10
`NGINX_REQ_LIMIT_PER_IP_RATE` | Maximal durchschnittliche Rate an Anfragen, die pro Sekunde pro IP verarbeitet werden. Übersteigt ein Client die Anfragenrate, dann werden die überschüssigen Anfragen in eine Warteschalnge gelegt und mit der maximalen Rate verarbeitet. | 7
`NGINX_REQ_LIMIT_PER_IP_BURST` | Maximale Ausbruchrate an Anfragen pro Sekunde pro IP. Nachdem ein Client die maximale Anfragenrate überschritten hat, werden die überschüssigen Anfragen in eine Warteschlange gelegt. Übersteigt die Ratejedoch auch die Ausbruchsrate, dann werden diese überschüssigen Anfragen mit 503 (Service Temporarily Unavailable) beantwortet. | 10
`NGINX_MULTI_ACCEPT` | Wenn diese Option aktiviert ist, dann akzeptiert nginx so viele neue Verbindungen gleichzeitig, wie es eben möglich ist. Standardmäßig bearbeitet ein Worker nur eine neue Verbindung zu jeder Zeit. | off
`NGINX_BEHIND_PROXY` | Befindet sich der Webserver hinter einem Proxy, so muss dieser einen 'X-Forwarded-For' Header injizieren, damit die Client-IPs ausgelesen werden können. Ansosnten ist nur die IP des Proxys sichtbar. | true
`NGINX_TLS_TERMINATED` | Wenn die TLS Verbindung mit einem Reverse-Proxy terminiert wird, dann wird keine Verschlüsselte Verbindung zum Backend mehr benötigt (Wenn nur innerhalb eines Systems kommuniziert wird). | true
`NGINX_TLS_KEY` | Pfad zum SSL-Key | Falls `SSL=on` gesetzt worden ist, wird dieser automatisch erzeugt.
`NGINX_TLS_CERT` | Pfad zum SSL-Zertifikat  | Falls `SSL=on` gesetzt worden ist, wird dieses automatisch erzeugt.
`NGINX_REWRITE_HTTPS` | Unencrypted requests will be redirect to encrypted https version | false
`NGINX_DH_SIZE` | Falls die Diffie-Hellman-Parameter-Datei automatisch erzeugt wird, wird diese Größe (bit) für die Primzahl verwendet | 512

##### Supervisor
https://github.com/Aisbergg/dockerfile#supervisor

## License
This Dockerfile is released under the MIT License. See [LICENSE](../LICENSE) for more information.
