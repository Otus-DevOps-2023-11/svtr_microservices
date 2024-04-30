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


## ДЗ #15. Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов

Выполнены все основные и дополнительные пункты ДЗ

#### Основное задание
- Изучена работа контейнера с сетевыми драйверами `none`, `host`, `bridge`;
- Проанализирован вывод команды `ifconfig` при запуске контейнера в сетевом пространстве docker-хоста:
   - Команда выводит состояние активных интерфейсов хостовой машины, т.к. в случае драйвера `host` устраняется сетевая изолированность между контейнером и хостом docker и напрямую используются сетевые ресурсы хоста;
- Проведен эксперимент многократного запуска контейнера `nginx` с сетью `host`:
   - `docker ps` вывел активное состояние только первого запущенного контейнера. Это связано с тем, что остальные контейнеры не смогли сделать bind на 80 порт, т.к. его занял первый контейнер. Остальные nginx контейнеры выдали ошибку:
```
nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
```
- Исследовано поведение net-namespaces при запуске контейнеров с драйверами `none` и `host`;
- Изучен функционал сетевых алиасов при запуске проекта reddit с использованием bridge-сети;
- Изучена работа контейнеров одновременно в нескольких сетях;
- Исследовано поведение сетевого стека Linux при запуске контейнеров с `bridge` сетями;
- Исследовано изменение цепочек `iptables` при запуске контейнеров с `bridge` сетями;

#### Работа с Docker-compose
- Проект reddit описан в файле `docker-compose.yml`;
- Файл изменен под кейс с множеством сетей, сетевых алиасов;
- `docker-compose.yml` параметризирован с помощью переменных окружения, описанных в файле `.env`:
```
COMPOSE_PROJECT_NAME=reddit
UI_PORT=9292
DB_TAG=4
UI_TAG=3.0
COMMENT_TAG=2.0
POST_TAG=1.0
DB_PATH=/data/db/
USERNAME=shrkga
```
- Базовое имя проекта изменено при помощи переменной `COMPOSE_PROJECT_NAME=reddit`;
- Создан файл `docker-compose.override.yml` с целью переопределения инструкции `command` контейнеров `comment` и `ui`, а также пробрасывания папки с кодом с хоста внутрь контейнеров:
```
version: '3.3'
services:
  ui:
    volumes:
      - ./ui/:/app/
    command: ["puma", "--debug", "-w", "2"]
  comment:
    volumes:
      - ./comment/:/app/
    command: ["puma", "--debug", "-w", "2"]
  post:
    volumes:
      - ./post-py/:/app/
```

====================
Домашнее задание №16:
====================

## В процессе сделано:

    Кратко:
    Отработаны все задания в соотвествии с документом к ДЗ
        Подготовить инсталляцию Gitlab CI
        Подготовить репозиторий с кодом приложения
        Описать для приложения этапы пайплайна
        Определить окружения
    * Кроме заданий со *

## Как запустить проект:

        Основное. Создание ВМ для DZ
        > yc compute instance create \
            --name gitlab-ci-vm \
            --hostname gitlab-ci-vm \
            --memory=8 \
            --cores=2 \
            --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50GB \
            --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
            --metadata serial-port-enable=1 \
            --metadata-from-file='user-data=ya_gitlab-ci-vm_startup.yaml'

        Подготовить докер на ней-
        > docker-machine create \
            --driver generic \
            --generic-ip-address=51.250.7.249 \
                    --generic-ssh-user ap1 \
                    --generic-ssh-key ~/.ssh/id_rsa \
                    gitlab-ci-vm
        docker-machine ls
        eval $(docker-machine env gitlab-ci-vm)

        На хосте с докером подготовиться, развернуть контейнер для Gitlab
            mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
            cd /srv/gitlab
            touch docker-compose.yml
            vi docker-compose.yml
            cat docker-compose.yml
                        web:
                          image: 'gitlab/gitlab-ce:latest'
                          restart: always
                          hostname: 'gitlab.example.com'
                          environment:
                            GITLAB_OMNIBUS_CONFIG: |
                              external_url 'http://51.250.7.249'
                          ports:
                            - '80:80'
                            - '443:443'
                            - '2222:22'
                          volumes:
                            - '/srv/gitlab/config:/etc/gitlab'
                            - '/srv/gitlab/logs:/var/log/gitlab'
                            - '/srv/gitlab/data:/var/opt/gitlab'
            apt install docker-compose
            docker-compose up -d
            sudo docker exec -it a6d06 grep 'Password:' /etc/gitlab/initial_root_password

        Действия через вебинтерфейс Gitlab,
        Первоночальные подстройки, настройки узеров, групп и проектов, проверки работы папйплайнов тут -
            http://51.250.7.249/

        Добавление раннера, на хосте
            docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
        Регистрация раннера
            docker exec -it gitlab-runner gitlab-runner register \
                --url http://51.250.7.249/ \
                --non-interactive \
                --locked=false \
                --name DockerRunner \
                --executor docker \
                --docker-image alpine:latest \
                --registration-token XXXXXXXNNNNNNNNNNDDDDDDDDD \
                --tag-list "linux,xenial,ubuntu,docker" \
                --run-untagged
                !!! ..... 'register' command has been deprecated ...., но пока работает

        Работа локально с гитом
            git remote add gitlab http://51.250.7.249/homework/example.git
            git push gitlab gitlab-ci-1
            Работа по настройке pipeline, в разных вариантах, в файле.gitlab-ci.yml
            подготовка тестового проекта, работа с "окружениями" и тп
            и др.

## Как проверить работоспособность:

        Например, перейти по ссылке Gitlab http://51.250.7.249/homework/example,  ссылки Pipeline, Enviroment и др