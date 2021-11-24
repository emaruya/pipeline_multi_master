provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "k8s_proxy" {
  subnet_id = "${element(var.subnets, 0)}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "chave-key-erika"
  root_block_device {
    encrypted = true
    volume_size = 30
  }
  tags = {
    Name = "k8s-haproxy-projeto"
  }
  vpc_security_group_ids = [aws_security_group.acessos_haproxy.id]
}

resource "aws_instance" "k8s_masters" {
  subnet_id = "${element(var.subnets, count.index)}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "chave-key-erika"
  count         = "${length(var.subnets)}"
  root_block_device {
    encrypted = true
    volume_size = 30
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
  subnet_id = "${element(var.subnets, count.index)}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "chave-key-erika"
  count         = "${length(var.subnets)}"
  root_block_device {
    encrypted = true
    volume_size = 30
  }
  tags = {
    Name = "k8s_workers-projeto${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
}


resource "aws_security_group" "acessos_masters" {
  name        = "k8s-masters-projeto"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"

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
    # {
    #   cidr_blocks      = [
    #     "0.0.0.0/0",
    #   ]
    #   description      = ""
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "tcp"
    #   security_groups  = []
    #   self             = false
    #   to_port          = 65535
    # },
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
    Name = "k8s-masters-projeto"
  }
}

resource "aws_security_group" "acessos_haproxy" {
  name        = "k8s-haproxy-projeto"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"

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
  vpc_id      = "${var.vpcId}"

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


# Master -> Worker
resource "aws_security_group_rule" "extra_rule1" {
  security_group_id        = "${aws_security_group.acessos_workers.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.acessos_masters.id}"
}

# Worker -> Master
# resource "aws_security_group_rule" "extra_rule" {
#   security_group_id        = "${aws_security_group.acessos_masters.id}"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   type                     = "ingress"
#   source_security_group_id = "${aws_security_group.acessos_workers.id}"
# }

# Worker -> HAProxy
resource "aws_security_group_rule" "extra_rule2" {
  security_group_id        = "${aws_security_group.acessos_haproxy.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.acessos_workers.id}"
}

# HAProxy -> Master
resource "aws_security_group_rule" "extra_rule3" {
  security_group_id        = "${aws_security_group.acessos_masters.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.acessos_haproxy.id}"
}


output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master ${key+1} - ${item.private_ip} - ssh -i var/lib/jenkins/.ssh/id_rsa ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
      "k8s-workers ${key+1} - ${item.private_ip} - ssh -i var/lib/jenkins/.ssh/id_rsa ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_proxy" {
  value = [
    "k8s_proxy - ${aws_instance.k8s_proxy.private_ip} - ssh -i var/lib/jenkins/.ssh/id_rsa ubuntu@${aws_instance.k8s_proxy.public_dns} -o ServerAliveInterval=60"
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

variable "subnets" {
  type        = list(string)
}
variable "vpcId" {
  type = string
  description = "vpcId"
}

#variable "sgMasters" {
#  type = string
#  description = "sgMasters"
#}
#
#variable "sgWorkers" {
#  type = string
#  description = "sgWorkers"
#}
#
#variable "sgHaproxy" {
#  type = string
#  description = "sgHaproxy"
#}


# terraform refresh para mostrar o ssh