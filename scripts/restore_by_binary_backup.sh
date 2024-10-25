#!/bin/bash

# Переменные
CONTAINER_NAME="postgres-test-container"  # Имя контейнера с PostgreSQL
BACKUP_DIR="./backups"  # Папка с бинарными бэкапами
BACKUP_NAME=$1  # Имя папки с бинарным бэкапом, передается как аргумент

# Проверка, что имя бэкапа передано
if [ -z "$BACKUP_NAME" ]; then
  echo "Ошибка: Необходимо указать имя папки с бинарным бэкапом для восстановления."
  echo "Пример: ./restore_by_binary_backup.sh binary_backup_2024-10-05_02-21-35"
  exit 1
fi

# Полный путь к папке с бэкапом
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Проверка, существует ли папка с бэкапом
if [ ! -d "$BACKUP_PATH" ]; then
  echo "Ошибка: Папка с бэкапом $BACKUP_PATH не существует."
  exit 1
fi

# 1. Остановка контейнера с базой данных
echo "Останавливаем контейнер $CONTAINER_NAME..."
docker stop $CONTAINER_NAME

# 2. Проверка, что контейнер успешно остановлен
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  echo "Не удалось остановить контейнер. Прерывание."
  exit 1
fi

# 3. Удаление текущих данных базы данных
echo "Удаляем текущие данные базы данных..."
docker run --rm \
  -v test-db:/data/test-db \
  alpine rm -rf /data/test-db/*

if [ $? -eq 0 ]; then
  echo "Текущие данные успешно удалены."
else
  echo "Ошибка при удалении текущих данных."
  exit 1
fi

# 4. Восстановление данных из бинарного бэкапа
echo "Восстанавливаем данные из бинарного бэкапа $BACKUP_NAME..."
docker run --rm \
  -v test-db:/data/test-db \
  -v $BACKUP_PATH:/backup \
  alpine cp -r /backup/* /data/test-db

if [ $? -eq 0 ]; then
  echo "Данные успешно восстановлены из бинарного бэкапа $BACKUP_NAME."
else
  echo "Ошибка при восстановлении данных."
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
