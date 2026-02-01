## Запуск

###
cd /home/sliderer/MUFFIN

### Запустить PostgreSQL
docker-compose -f docker-compose.yml up -d

### Запустить сервисы
helmfile apply

### Запустить все для мониторинга
kubectl apply -f k8s/monitoring


## Проверка

### Проверяем что сервисы работают

kubectl get pods

Убеждаемся что все сервисы подняты

### Проверяем функционал

# При необходимости надо прокинуть порты!

kubectl port-forward -n default svc/muffin-wallet-wallet  8081:80

curl -X 'POST' \
  'http://localhost:8081/v1/muffin-wallets' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "type": "CHOCOLATE",
  "owner_name": "account_1"
}'

curl -X 'POST' \
  'http://localhost:8081/v1/muffin-wallets' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "type": "PLAIN",
  "owner_name": "account_2"
}'

curl -X 'POST' \
  'http://localhost:8081/v1/muffin-wallet/3fa85f64-5717-4562-b3fc-2c963f66afa6/transaction' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "to_muffin_wallet_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "amount": 0
}'

### Проверяем метрики

Открываем http://localhost:3000 (тут должна быть графана)
Открываем http://localhost:9411 (тут должн быть zipkin)

В графане должен быть дашборд (он приложен в json версии)
На нем видно логи, можно поискать логи по trace_id с помощью { traceId = "$traceId" }