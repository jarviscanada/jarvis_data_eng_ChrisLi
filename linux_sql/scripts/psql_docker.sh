#! /bin/bash
cmd=$1
#start docker service
systemctl status docker  || systemctl  start docker

#handle arguments
case $cmd in
  "create")
    #checks
    if [ "$(docker container ls -a -f name=jrvs-psql | wc -l)" = 2 ]; then
      echo "Error: docker container already existed"
      exit 1
    fi

    if [ -z $2 ]; then
      echo "Error: Missing db_username argument"
      exit 1
    else
        db_username=$2
    fi

    if [ -z $3 ]; then
      echo "Error: Missing db_password argument"
      exit 1
    else
        db_password=$3
    fi

    #create docker volume
    docker volume create pgdata
    #create psql container
    docker run --name jrvs-psql -e POSTGRES_PASSWORD="${db_password}" -e POSTGRES_USER="${db_username}" -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
    echo "container created successfully"
    exit $?
    #check if contain is created
    if [ "$(docker container ls -a -f name=jrvs-psql | wc -l)" != 2 ]; then
      echo "Error: docker container cannot be created"
      exit 1
    fi
    ;;

    "start")
      docker container start jrvs-psql
      echo "container started"
      exit $?
      ;;

    "stop")
      docker container stop jrvs-psql
      echo "container stopped"
      exit $?
      ;;

    *)
      echo "Error: invalid operation; [start]|[stop]|[create]"
      exit 1
      ;;
  esac