#!/bin/bash

# Переменные
CONTAINER_NAME="postgres-test-container"  # Имя контейнера с PostgreSQL
BACKUP_DIR="./backups"  # Папка для хранения бинарного бэкапа
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")  # Метка времени для имени бэкапа
BACKUP_NAME="binary_backup_$TIMESTAMP"  # Имя папки с бэкапом
PG_USER="postgres"  # Пользователь PostgreSQL
PG_PASSWORD="123"
PG_HOST="localhost"  # Имя контейнера с PostgreSQL, который будет использоваться как хост
PG_PORT="8080"  # Порт PostgreSQL

# Экспорт пароля PostgreSQL
export PGPASSWORD="$PG_PASSWORD"

# 1. Создание папки для бэкапа, если её нет
mkdir -p $BACKUP_DIR/$BACKUP_NAME

# 2. Остановка контейнера с PostgreSQL для безопасного бэкапа
echo "Останавливаем контейнер $CONTAINER_NAME..."
docker stop $CONTAINER_NAME

# 3. Проверка, что контейнер успешно остановлен
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  echo "Не удалось остановить контейнер. Прерывание."
  exit 1
fi

# 4. Создание бинарного бэкапа с использованием pg_basebackup
echo "Создаем бинарный бэкап с использованием pg_basebackup..."
docker run --rm \
  --network="host" \
  postgres:latest pg_basebackup -h $PG_HOST -p $PG_PORT -U $PG_USER -D /backups/$BACKUP_NAME -Fp -Xs -P -R

if [ $? -eq 0 ]; then
  echo "Бинарный бэкап успешно создан: $BACKUP_DIR/$BACKUP_NAME"
else
  echo "Ошибка при создании бинарного бэкапа."
  exit 1
fi

# 5. Запуск контейнера с PostgreSQL снова
echo "Запускаем контейнер $CONTAINER_NAME..."
docker start $CONTAINER_NAME

# 6. Проверка, что контейнер запущен
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  echo "Контейнер $CONTAINER_NAME успешно запущен."
else
  echo "Не удалось запустить контейнер."
  exit 1
fi
