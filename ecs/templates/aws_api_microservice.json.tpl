[
  {
    "name": "aws-api-microservice",
    "image": "${microservice_img}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/aws-api-microservice",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${microservice_port},
        "hostPort": ${microservice_port}
      }
    ]
  }
]
