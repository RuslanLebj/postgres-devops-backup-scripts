#!/bin/bash

# Переменные
CONTAINER_NAME="postgres-test-container"  # Имя контейнера с PostgreSQL
BACKUP_DIR="./backups"  # Папка с бэкапами
BACKUP_NAME=$1  # Имя файла бэкапа (передаётся как аргумент)
DATA_DIR="/var/lib/postgresql/data"  # Путь к данным базы данных внутри контейнера

# Проверка, передан ли файл бэкапа
if [ -z "$BACKUP_NAME" ]; then
  echo "Ошибка: Необходимо указать имя файла бэкапа для восстановления."
  echo "Пример: ./restore_cold_backup.sh postgres_backup_2024-01-01_00-00-00.tar.gz"
  exit 1
fi

# Полный путь к файлу бэкапа
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Проверка, существует ли файл бэкапа
if [ ! -f "$BACKUP_PATH" ]; then
  echo "Ошибка: Файл бэкапа $BACKUP_PATH не существует."
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

# 3. Удаление всех данных базы данных
echo "Удаляем все данные базы данных..."
docker run --rm \
  -v test-db:/data/test-db \
  alpine sh -c "rm -rf /data/test-db/*"

if [ $? -eq 0 ]; then
  echo "Данные успешно удалены."
else
  echo "Ошибка при удалении данных."
  exit 1
fi

# 4. Восстановление всех данных из бэкапа
echo "Восстанавливаем данные из бэкапа $BACKUP_NAME..."
docker run --rm \
  -v test-db:/data/test-db \
  -v $BACKUP_DIR:/backup \
  alpine tar xzf /backup/$BACKUP_NAME -C /data/test-db

if [ $? -eq 0 ]; then
  echo "Данные успешно восстановлены из бэкапа $BACKUP_NAME."
else
  echo "Ошибка при восстановлении данных из бэкапа."
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
