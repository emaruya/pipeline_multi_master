provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "k8s_proxy" {
  subnet_id = "subnet-0e6a2c0827160332c"
  ami = "${var.amiId}"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "chave-key-erika"
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "k8s-haproxy-projeto"
  }
  vpc_security_group_ids = [aws_security_group.acessos_haproxy.id]
}

resource "aws_instance" "k8s_masters" {
  subnet_id = "subnet-07384d1338e0f2f61"
  ami = data.aws_ami.projeto-final.id
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "chave-key-erika"
  count         = 3
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "k8s-master-projeto${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_masters.id]
  depends_on = [
    aws_instance.k8s_workers,
  ]
}

resource "aws_instance" "k8s_workers" {
  subnet_id = "subnet-0e6a2c0827160332c"
  ami = data.aws_ami.projeto-final.id
  instance_type = "t2.medium"
  associate_public_ip_address = true
  key_name = "chave-key-erika"
  count         = 3
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "k8s_workers-projeto${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
}


resource "aws_security_group" "acessos_masters" {
  name        = "k8s-acessos-masters-projeto"
  description = "acessos inbound traffic"
  vpc_id      = "vpc-010ad4cd4b8ad8a3c"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "Liberando pro mundo"
      from_port        = 30000
      to_port          = 30100
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = "Libera acesso k8s_masters"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = true
      to_port          = 0
    },
    # {
    #   cidr_blocks      = []
    #   description      = "Libera acesso k8s_haproxy"
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     "sg-0e3d8c9ba44e65ec4",
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "k8s-acessos-masters-projeto"
  }
}

resource "aws_security_group" "acessos_haproxy" {
  name        = "k8s-haproxy-projeto"
  description = "acessos inbound traffic"
  vpc_id      = "vpc-010ad4cd4b8ad8a3c"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    # {
    #   cidr_blocks      = []
    #   description      = "Libera acesso para as masters"
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     "sg-0fe677272e040989e",
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
    # {
    #   cidr_blocks      = []
    #   description      = "Libera acesso para as workers"
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     "sg-0857b0e2752740ad6",
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "k8s-haproxy-projeto"
  }
}

resource "aws_security_group" "acessos_workers" {
  name        = "k8s-workers-projeto"
  description = "acessos inbound traffic"
  vpc_id      = "vpc-010ad4cd4b8ad8a3c"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    # {
    #   cidr_blocks      = []
    #   description      = "Libera acesso para as masters"
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     "sg-0fe677272e040989e",
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "k8s-workers-projeto"
  }
}

output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master ${key+1} - ${item.private_ip} - ssh -i /home/ubuntu/.ssh/id_rsa ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
      "k8s-workers ${key+1} - ${item.private_ip} - ssh -i /home/ubuntu/.ssh/id_rsa ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_proxy" {
  value = [
    "k8s_proxy - ${aws_instance.k8s_proxy.private_ip} - ssh -i /home/ubuntu/.ssh/id_rsa ubuntu@${aws_instance.k8s_proxy.public_dns} -o ServerAliveInterval=60"
  ]
}

output "security-group-haproxy" {
  value = aws_security_group.acessos_haproxy.id
}

output "security-group-workers" {
  value = aws_security_group.acessos_workers.id
}

output "security-group-masters" {
  value = aws_security_group.acessos_masters.id
}

variable "amiId" {
  type = string
  description = "amiId"
}

variable "sgMasters" {
  type = string
  description = "sgMasters"
}

variable "sgWorkers" {
  type = string
  description = "sgWorkers"
}

variable "sgHaproxy" {
  type = string
  description = "sgHaproxy"
}


# terraform refresh para mostrar o ssh