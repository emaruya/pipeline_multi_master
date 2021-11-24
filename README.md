<h1 align="center">
<img src="https://imgur.com/ZomXVbq" title="Grupo Three" />
</h1>

<h3 align="center">
  Grupo Three
</h3>

<p align="center">
  <a href="#sobre o projeto">Sobre o projeto</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#Desenvolvedores">Desenvolvedores</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#tecnologias">Tecnologias</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#iniciando">Iniciando</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#funcionalidades">Funcionalidades</a>
</p>

## 👨🏻‍💻 Sobre o projeto

<p>Objetivo:<BR><BR>
Exercitar os conhecimentos adquiridos do treinamento

Meta:<br><BR>
●	Criar uma rede isolada para esta aplicação

●	Criar uma pipeline de infraestrutura para provisionar uma imagem que será utilizada em um cluster kubernetes(single master)

●	Criar uma pipeline para provisionar um cluster multi master utilizando a imagem criada na pipeline de infraestrutura 

●	Criar uma pipeline para provisionar o banco de dados (dev, stage, prod) que será utilizado nas aplicações que estarão no kubernetes. Esta base de dados, será provisionada em uma instância privada, com acesso a Internet via Nat Gateway na mesma vpc do kubernetes multi master 

●	Criar uma pipeline de desenvolvimento para deployar os ambientes de uma aplicação Java (dev, stage, prod) com ligação a um banco de dados mysql-server (utilizar o cluster kubernetes(multi master) provisionado pela pipeline de infraestrutura 
</br>

### 💻 Desenvolvedores
- [Erico](https://github.com/jhsmiranda)
- [Erika](https://github.com/gustavolening)
- [Fábio](https://github.com/fdutrac)
- [Felipe](https://github.com/flipdantas)

## 🚀 Tecnologias

Tecnologias que utilizamos para desenvolver este Projeto:

- [AWS](https://aws.amazon.com/)
- [Ubuntu](https://ubuntu.com/)
- [MySql](https://www.mysql.com/)
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- [Jenkins](https://www.jenkins.io/)

## 💻 Iniciando

- As instruções a seguir irão te guiar para que você crie uma cópia do projeto na sua máquina local.

### Pré-requisitos

- Máquina com Jenkins instalado.

**Clone o projeto e acesse a pasta**

```bash
$ git clone https://github.com/yyy/xxx/ && cd xxx
```

**Siga as etapas abaixo**

xxx

xxx

Tudo pronto! 


## ⚙️ Funcionalidades
Funcionalidades que o sistema oferece:
- Criação automática de Imagem (AMI) baseada em script Terraform/Ansible
- Criação de Infra Multi Master com 3 Máquinas Master, 4 Nodes, HAProxy
- Criação de Máquinas MySql em rede privada
- Deploy de Sistema
