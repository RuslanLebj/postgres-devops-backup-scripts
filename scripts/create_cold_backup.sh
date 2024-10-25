#!/bin/bash

# Переменные
CONTAINER_NAME="postgres-test-container"   # Имя контейнера
BACKUP_DIR="./backups"          # Папка для хранения бэкапа
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S") # Метка времени для бэкапа
BACKUP_NAME="postgres_backup_$TIMESTAMP.tar.gz" # Имя бэкапа

# 1. Остановка контейнера с базой данных
echo "Останавливаем контейнер $CONTAINER_NAME..."
docker stop $CONTAINER_NAME

# 2. Проверка, что контейнер успешно остановлен
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  echo "Не удалось остановить контейнер. Прерывание."
  exit 1
fi

# 3. Создание папки для бэкапа, если её нет
mkdir -p $BACKUP_DIR

# 4. Копирование данных из тома базы данных
echo "Создаем бэкап данных..."
docker run --rm \
  -v test-db:/data/test-db \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/$BACKUP_NAME -C /data/test-db .

if [ $? -eq 0 ]; then
  echo "Бэкап успешно создан: $BACKUP_DIR/$BACKUP_NAME"
else
  echo "Ошибка при создании бэкапа."
  exit 1
fi

# 5. Запуск контейнера с базой данных снова
echo "Запускаем контейнер $CONTAINER_NAME..."
docker start $CONTAINER_NAME

# 6. Проверка, что контейнер запущен
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  echo "Контейнер $CONTAINER_NAME успешно запущен."
else
  echo "Не удалось запустить контейнер."
  exit 1
fi
