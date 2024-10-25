#!/bin/bash

# Проверяем, существует ли внешний volume test-db
if ! docker volume inspect test-db > /dev/null 2>&1; then
  echo "Создаём внешний volume test-db..."
  docker volume create --name test-db
else
  echo "Внешний volume test-db уже существует."
fi
