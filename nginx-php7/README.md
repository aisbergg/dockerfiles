# Nginx and PHP7-FPM (aisberg/nginx-php)

## Argumente
Alle Argumente sind optional und werden, falls nicht gegeben, auf ihren Standardwert gesetzt.

| Argument| Beschreibung | Standardwert |
|----------|--------------|--------------|
| PHP_MAX_EXECUTION_TIME| Maximale Zeit, die das Script ausgeführt wird, bevor der Parser die Ausführung stoppt. | 300 |
| PHP_MAX_INPUT_TIME| Maximale Zeit, die ein Script brauchen darf, um Eingabedaten (POST, GET und Dateiuploads) zu verarbeiten. Die Zeitmessung beginnt mit dem Aufruf des Scriptes und endet, wenn dessen Ausführung beginnt. | 300 |
| PHP_MEMORY_LIMIT| Beschränkt den maximal verfügbaren Speicher, den ein Script verbrauchen darf. | 128M |
| PHP_POST_MAX_SIZE| Maximale Größe der Anfrage. Bei Uploads von größeren Dateien, muss diese Einstellung entsprechend angepasst werden. | 300M |
| PHP_MAX_FILE_UPLOADS| Maximale Anzahl an Dateien, die gleichzeitig hochgeladen werden dürfen. | 40 |
