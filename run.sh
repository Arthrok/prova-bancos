docker compose up --build -d
docker exec -it postgres_d /bin/bash
psql -U pg -d pg