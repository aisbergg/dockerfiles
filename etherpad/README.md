# Etherpad (aisberg/etherpad)


## Argumente
Alle Argumente sind optional und werden, falls nicht gegeben, auf ihren Standardwert gesetzt.

| Argument | Beschreibung | Standardwert |
|----------|--------------|--------------|
| CONN_LIMIT_PER_IP | Maximale gleichzeitige Verbindungen pro IP. | 10 |
| REQ_LIMIT_PER_IP_BURST | Maximale Ausbruchrate an Anfragen pro Sekunde pro IP. | 10 |
| DATABASE_HOST | Initiale Name des Hosts der MySQL Datenbank; Kann später manuell in der Datei `/opt/etherpad/settings.json` angepasst werden. | mysql |
| DATABASE_NAME | Initialer Datenbankname | etherpad |
| DATABASE_USER | Initialer Datenbankbenutzer | etherpad |
| DATABASE_PW | Initiales Datenbankpasswort |  | 
