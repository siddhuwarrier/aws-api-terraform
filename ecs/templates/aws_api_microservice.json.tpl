[
  {
    "name": "${env}-aws-api-microservice",
    "image": "${microservice_img}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${env}-aws-api-microservice",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${microservice_port},
        "hostPort": ${microservice_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "DB_ENDPOINT",
        "value": "${db_endpoint}"
      },
      {
        "name": "DB_URL",
        "value": "jdbc:postgresql://${db_endpoint}/${db_name}"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${db_password}"
      },
      {
        "name": "DB_USERNAME",
        "value": "${db_username}"
      }
    ]
  }
]
