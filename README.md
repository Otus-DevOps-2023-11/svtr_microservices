# svtr_microservices
svtr microservices repository

ДЗ 12 / Введение в Docker

1. Осовные комманды
   docker run # создает и запускает новый контейнер из образа
   docker ps # отображает список запущенных контейнеров
   docker images # отображает список доступных образов
   docker pull # загружает образ из репозитория Docker Hub
   docker build # создает новый образ на основе Dockerfile
   docker stop # останавливает контейнер
   docker start # запускает ранее остановленный контейнер
   docker rm # удаляет контейнер
   docker rmi # удаляет образ
   docker info # информация о работоспособности клиент-сервера
   docker inventori # Полная информация о онтейнере

2. Удалени образов:
   docker ps -a
   docker stop $(docker ps -q)
   docker rm $(docker ps -a -q)
   docker rmi $(docker images -q)

3. Установка docker-machine
   curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
   docker-machine -v

4. ssh-keygen -h

yc compute instance create \
--name docker-host \
--zone ru-central1-a \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
--ssh-key ~/.ssh/id_rsa.pub

docker-machine create \
--driver generic \
--generic-ip-address=51.250.70.208 \
--generic-ssh-user yc-user \
--generic-ssh-key ~/.ssh/id_rsa \
docker-host

docker-machine ls
eval $(docker-machine env docker-host) # переключение на работу в докер машине
eval $(docker-machine env --unset)  # переключение обратно на локальную машину

5. docker-hub
   docker tag reddit:latest ivengar/otus-reddit:1.0
   docker push ivengar/otus-reddit:1.0
   docker run --name reddit -d -p 9292:9292 ivengar/otus-reddit:1.0

6. docker-machine rm docker-host
   yc compute instance delete docker-host


docker-machine env --shell cmd docker-host


ДЗ 14 / Микросервисы
1.
docker pull mongo:4
docker build -t svtr/post:1.0 ./post-py
docker build -t svtr/comment:1.0 ./comment
docker build -t svtr/ui:1.0 ./ui
2.
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:4
docker run -d --network=reddit --network-alias=post svtr/post:1.0
docker run -d --network=reddit --network-alias=comment svtr/comment:1.0
docker run -d --network=reddit -p 9292:9292 svtr/ui:1.0

http://158.160.60.248:9292/
3.
docker run --rm -i hadolint/hadolint < Dockerfile
4.
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:4
docker run -d --network=reddit --network-alias=post svtr/post:2.0
docker run -d --network=reddit --network-alias=comment svtr/comment:1.0
docker run -d --network=reddit -p 9292:9292 svtr/ui:2.0

http://158.160.60.248:9292/
