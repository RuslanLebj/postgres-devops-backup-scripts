FROM postgres:15.1-alpine
  
LABEL author="Ruslan" 
LABEL description="Postgres Test Image" 
LABEL version="1.0"  

# Копируем SQL-файлы для инициализации
COPY migrations/*.sql /docker-entrypoint-initdb.d/