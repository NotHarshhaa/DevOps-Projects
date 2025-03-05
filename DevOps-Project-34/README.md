# Complete DevOps Project: Multi-Tier Application Deployment Locally

![Preview image](https://miro.medium.com/v2/resize:fit:700/0*PiLR0cddi_gZMsq8)

# **Your First Complete DevOps Project: Multi-Tier Deployment from Scratch (PART 1/2)**

If you want to become a job-ready DevOps engineer, I strongly recommend not skipping any steps. It may seem challenging at first, but as you progress, you'll gain expertise.

Keep in mind that all these projects are based on real-world scenarios and are highly relevant in the industry.

Development and DevOps go hand in hand - developers build applications, while DevOps engineers ensure seamless operation across environments.

From experience, understanding the final output before deployment is crucial. Knowing its appearance, dependencies, and functionality helps in efficient setup. DevOps engineers orchestrate services to optimize performance, cost, and reliability. Once deployed, the application interface appears as follows. This Java-based application relies on five key services: **MySQL, Memcache, RabbitMQ, Tomcat, and Nginx**—working together for smooth operation across environments.

![None](https://miro.medium.com/v2/resize:fit:700/0*VgnKH-KW5LscXuTo)

Application UI after a successful deployment

This DevOps project is detailed and extensive, so I'm breaking it into two parts. In this first part, we'll focus on setting up a local environment using **VirtualBox** and **Vagrant**.

**VirtualBox** is used to create virtual machines (VMs), while **Vagrant** enables the automation and management of multiple VMs through code. The first time I created a VM using Vagrant, I was truly amazed—and I'm sure you will be too! These tools are essential for mastering DevOps, and this guide will walk you through their setup and usage.

![None](https://miro.medium.com/v2/resize:fit:700/1*RYEj9lV_NawVlE0v-5V2dA.png)

Here I will show the setup in Mac environment for the setup but you use any environment to setup the same

I am writing the whole project flow and setup step by step so that you can keep track easily and focus only one step at a time. But remember for starting each step, you need to successfully complete previous step.

**Install VirtualBox & Vagrant** This is a single-line command on Mac. If you encounter any installation issues, feel free to ask in the comments. Sometimes, even simple tasks can take longer than expected, but every problem has a solution.

If you're new to **VirtualBox**, take some time to understand how it works. Once you're familiar with it, **Vagrant** makes managing multiple VMs incredibly easy. In this post, you'll get hands-on experience with both!

Install by brew, the VirtualBox & Vagrant

```go
Copy> brew install virtualbox vagrant
```

Install vagrant plugin vagrant-hostmanager

```go
Copy> vagrant plugin install vagrant-hostmanager
```

Verify that VirtualBox & Vagrant are installed. If you see different version numbers, that are fine.

```go
Copy> VBoxManage --version
> vagrant --version
```

![None](https://miro.medium.com/v2/resize:fit:700/0*7cHqlyJ3eRp08aTM)

Verify that the plugin vagrant-hostmanager

![None](https://miro.medium.com/v2/resize:fit:700/0*gvcYRRyu_S_qqbb2)

**Note:** This plugin updates the **/etc/hosts** file across all newly created VMs. After setting up our five VMs in part 2, we'll verify its functionality. If you're unfamiliar with **/etc/hosts**, don't worry — we'll be using this term frequently and will provide a visual representation for clarity.

At this stage, when you open the VirtualBox, it will look like this. Your IP could be different, that's completely fine -

![None](https://miro.medium.com/v2/resize:fit:700/0*8huias5PxvaDwvCa)

Screenshot of the VirtualBox interface after installation.

### **Up & Running 5 VMs for 5 services**

#### **Understanding Virtual Machines (VMs) in a DevOps Environment**

Think of each Virtual Machine (VM) as a separate physical computer. Just like a laptop or desktop has its own **operating system (OS)** and **IP address**, each VM operates independently.

For example, if you have two computers at home connected to the same router, each gets a unique **local IP address**, allowing them to communicate. Similarly, in this setup, we will create **five VMs**—each with its own OS and IP. Services installed on these VMs will communicate with one another using their IP addresses or hostname.

When I say VMs "talk to each other," I mean that the **services running on them** communicate with each other. For instance, **Nginx** (running on one VM) might need to communicate with **Tomcat** (running on another VM). This communication happens over the network using their respective IPs.

I'm explaining this assuming you're a beginner because understanding **how services interact behind the scenes** is crucial for a DevOps engineer. When I started learning DevOps, I struggled with these concepts, so I hope this real-world analogy helps you grasp them more quickly.

Next, we'll clone a Git repository containing the **Vagrantfile**, which is essential for provisioning the five virtual machines (VMs) needed for this first part. In **Part 2**, we'll configure these VMs to set up the required services.

To clarify, each VM corresponds to one of the five key services: **MySQL, Memcache, RabbitMQ, Tomcat, and Nginx.**

**Clone the git repo**

```go
Copy> git clone https://github.com/Muncodex/digiprofile-project.git
```

Switch to the local-vagrant branch, as it is dedicated to this project, covering both Part 1 and Part 2.

```go
Copy> git checkout local-vagrant
```

![None](https://miro.medium.com/v2/resize:fit:700/0*GvD9mkB8sNDOLxOj)

![None](https://miro.medium.com/v2/resize:fit:700/0*4nBeSpS6fVAIrqhU)

**VM creation by Vagrant explained**

As mentioned earlier, **Vagrant** works alongside **VirtualBox**, allowing you to create virtual machines through code configuration. This approach not only simplifies VM management but also enhances understanding of how environments are provisioned. Since we need **five services** running in **five separate VMs**, we'll define the Vagrant configuration to automate their creation. Let's go step by step, writing and understanding the code as we go. VM for MySQL

![None](https://miro.medium.com/v2/resize:fit:700/1*26XwH5LX5kVlwtlTrdqfSg.jpeg)

Vagrantfile configuration for the MySQL virtual machine

VM for Memcache

![None](https://miro.medium.com/v2/resize:fit:700/1*Ww2Z54EaqEH36rTGHLSh3A.jpeg)

Vagrantfile configuration for the Memcache virtual machine

VM for RabbitMQ

![None](https://miro.medium.com/v2/resize:fit:700/1*UBl2AMtFzy4A-i6zDhINlA.jpeg)

Vagrantfile configuration for the RabbitMQ virtual machine

VM for Tomcat

![None](https://miro.medium.com/v2/resize:fit:700/1*2XKYDpYSK-2Bk-de0MV-oQ.jpeg)

Vagrantfile configuration for the Tomcat virtual machine

VM for Nginx

![None](https://miro.medium.com/v2/resize:fit:700/1*yMTlOO4Geih3UGsGkbXrIA.jpeg)

Vagrantfile configuration for the Nginx virtual machine

Take note of the IP address and hostname defined in the Vagrant configuration for the VMs. This is essential for understanding how services communicate with each other.

**MySQL =&gt;** hostname: db01, ip: 192.168.56.15 **Memcache =&gt;** hostname: mc01, ip: 192.168.56.14 **RabbitMQ =&gt;** hostname: rmq01, ip: 192.168.56.13 **Tomcat =&gt;** hostname: app01, ip: 192.168.56.12 **Nginx =&gt;** hostname: web01, ip: 192.168.56.11

### **Vagrantfile**

**Open the Vagrantfile in an IDE to go through the code.**

As we cloned the repo. You can open the code in any IDE, I will show you in the Visual Studio Code but you can use any IDE you like.

Vagrant executes code in a filename Vagrantfile. So, the 5 VMs creation code in a single file name Vagrantfile and it is located in the project code location /digiprofile-project/vagrant/Manual\_provisioning\_MacOSM1. All the code for creating the 5 VMs written above is in one file named Vagrantfile in this location as shown on the screenshot.

![None](https://miro.medium.com/v2/resize:fit:700/0*szfx2X7l9IHfy83N)

Vagrantfile code and its location when opened in an IDE

Full Vagrantfile code

```go
CopyVagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

### DB vm  ####
  config.vm.define "db01" do |db01|
    db01.vm.box = "eurolinux-vagrant/centos-stream-9"
    db01.vm.hostname = "db01"
    db01.vm.network "private_network", ip: "192.168.56.15"
    db01.vm.provider "virtualbox" do |vb|
     vb.memory = "600"
   end
  end

### Memcache vm  ####
  config.vm.define "mc01" do |mc01|
    mc01.vm.box = "eurolinux-vagrant/centos-stream-9"
    mc01.vm.hostname = "mc01"
    mc01.vm.network "private_network", ip: "192.168.56.14"
    mc01.vm.provider "virtualbox" do |vb|
     vb.memory = "600"
   end
  end

### RabbitMQ vm  ####
  config.vm.define "rmq01" do |rmq01|
    rmq01.vm.box = "eurolinux-vagrant/centos-stream-9"
  rmq01.vm.hostname = "rmq01"
    rmq01.vm.network "private_network", ip: "192.168.56.13"
    rmq01.vm.provider "virtualbox" do |vb|
     vb.memory = "600"
   end
  end

### tomcat vm ###
   config.vm.define "app01" do |app01|
    app01.vm.box = "eurolinux-vagrant/centos-stream-9"
    app01.vm.hostname = "app01"
    app01.vm.network "private_network", ip: "192.168.56.12"
    app01.vm.provider "virtualbox" do |vb|
     vb.memory = "800"
   end
   end


### Nginx VM ###
  config.vm.define "web01" do |web01|
    web01.vm.box = "ubuntu/jammy64"
    web01.vm.hostname = "web01"
  web01.vm.network "private_network", ip: "192.168.56.11"
  web01.vm.provider "virtualbox" do |vb|
     vb.gui = true
     vb.memory = "800"
   end
end

end
```

**Create the VMs**

From the terminal, go to this location as the Vagrantfile is located in it.

```go
Copy> cd digiprofile-project/vagrant/Manual/
```

![None](https://miro.medium.com/v2/resize:fit:700/0*K_0OzoET3lVAcw7d)

Once you're in the directory containing the **Vagrantfile**, run the following command to create the VMs as defined in the configuration.

Verify you are on the right location

![None](https://miro.medium.com/v2/resize:fit:700/0*bEF2TI_371o_7O8W)

Start and provision a virtual machines (VM)

```go
Copy> vagrant up
```

As shown in the screenshot, you'll be prompted to enter your computer password.

![None](https://miro.medium.com/v2/resize:fit:700/0*PKQR3upc9-3_TIp_)

The command above will create five virtual machines (VMs). Once completed, you can open VirtualBox to see that all five VMs are now ready, as shown in the screenshot.

![None](https://miro.medium.com/v2/resize:fit:700/0*snE9RzGNfcusDKQj)

Each VM's name reflects the hostname defined in the **Vagrantfile**. To help you better understand the setup, I'll provide the hostname for each VM. You'll need these hostnames to facilitate communication between the VMs.

**MySQL =&gt;** db01 **Memcache =&gt;** mc01 **RabbitMQ =&gt;** rmq01 **Tomcat =&gt;** app01 **Nginx =&gt;** web01

Lets check the same with vagrant command

```go
Copy> vagrant status
```

### **Access to VMs by ssh**

Access to MySQL VM - hostname db01

```go
Copy> vagrant ssh db01
```

Access to Memcache VM - hostname mc01

```go
Copy> vagrant ssh mc01
```

Access to RabbitMQ VM - hostname rmq01

```go
Copy> vagrant ssh rmq01
```

Access to Tomcat VM - hostname app01

```go
Copy> vagrant ssh app01
```

Access to Nginx VM - hostname web01

```go
Copy> vagrant ssh web01
```

Here is a screenshot showing how it looks after accessing all five VMs via SSH.

![None](https://miro.medium.com/v2/resize:fit:700/0*6-vx7Jrh9Daflpl_)

To split the terminal, simply use **Cmd + D** or **Shift + Cmd + D**. This allows you to work in multiple terminal panes simultaneously, making it easier to manage different tasks.

Now verify ip address of each VM. All the VMs are running in Centos Linux OS except Nginx VM which is running in Ubuntu

Check ip address in Centos by ip a

```go
Copy> ip a
```

Check ip address in Ubuntu by ip addr

```go
Copy> ip addr
```

![None](https://miro.medium.com/v2/resize:fit:700/0*vUuhRcx2Es-nwvLx)

Access to VMs by ssh and verify the IP address

Now we can communicate among VMs. We know the hostname and IP address of each VMs. We can communicate among VMs through their hostname or ip address

Lets verify MySQL VM to Memcache VM

```go
Copy> vagrant ssh db01
```

Once inside the MySQL VM, communicated with Memcache VM by ping

```go
Copy> ping mc01
```

![None](https://miro.medium.com/v2/resize:fit:700/0*CS1rVecF2e3x7E6J)

Similarly you can communicate with any vm by their hostname.

So our VM is up at this stage and in the next step we install the services. For example in the MySQL vm we will install MySQL, Nginx vm we will install Nginx and so on.

* Check the /etc/hosts file to view the list of VMs.

* SSH into any of the VMs to verify this.

* SSH into the Memcache VM and check the /etc/hosts file. The Memcache VM's hostname is mc01.

```go
Copy> vagrant ssh mc01
```

![None](https://miro.medium.com/v2/resize:fit:700/0*jdKJ142gnhVMnzRZ)

**Congratulations! You've completed Part 1/2 of this project, where you installed VirtualBox and Vagrant in your local environment and successfully set up five VMs: MySQL, Memcache, RabbitMQ, Tomcat, and Nginx.**

In the next and final part of this project (Part 2/2), we will configure these five VMs by installing the necessary services. We'll also deploy the application and provide a visual walkthrough of it running on our configured platform.

---

# **Your First Complete DevOps Project: Multi-Tier Deployment from Scratch (PART 2/2)**

![Preview image](https://miro.medium.com/v2/resize:fit:700/1*NH8_fds8SShCv-Cuw9TAxg.png)

<mark>Learn to set up a multi-tier DevOps project locally using VirtualBox and Vagrant — step by step, from scratch — by configuring five VMs: MySQL, Memcache, RabbitMQ, Tomcat, and Nginx.</mark>

![None](https://miro.medium.com/v2/resize:fit:700/1*fDWHO9LiF3MP5RdN76jbng.png)

This is continuation of part 1/2 and final part of the project, the part 2/2. In the first part, we successfully initiated five VMs for the services of MySQL, Memcache, RabbitMQ, Tomcat, and Nginx. And in this final part, we will configure each of the VMs installing relevant services and deploy the application digiprofile-project, from start to finish, cloning the repo, build, compile and deployment and finally we will verify the from the terminal and visually by the browser.

Before start configuring the VMs, lets understand the flow of the application, interactions of services and introduction of five of the services.

### **DevOps Project Flow**

![None](https://miro.medium.com/v2/resize:fit:700/1*n0xYU23piloCDATOSTSHAw.png)

This DevOps Project Flow

This DevOps project is designed to handle web application traffic efficiently using a combination of NGINX, Tomcat, MySQL, Memcached, and RabbitMQ.

**User Access & Load Balancing**

* A user accesses the application through a web-based login page.

* The request first reaches **NGINX**, which acts as a load balancer and forwards it to an available **Tomcat server** for processing.

**Application Processing**

* **Tomcat**, a Java web application server, receives the request and processes the login attempt.

* It first checks **Memcached**, an in-memory caching system, to see if the user's session or credentials are already stored.

* If the data is not found in Memcached, Tomcat queries **MySQL**, the primary database, to authenticate the user.

* The login details are either fetched from the database or retrieved from Memcached for faster response times.

**Message Queuing & Asynchronous Processing**

* After handling authentication, **Tomcat sends a message to RabbitMQ**, a message broker used for asynchronous communication between services.

* RabbitMQ queues tasks like logging user activity, sending login notifications, or triggering background jobs.

* A worker service (RabbitMQ consumer) picks up these messages and processes them accordingly.

#### **Why This Architecture?**

This setup ensures: ✅ **Scalability** — NGINX efficiently distributes traffic across multiple Tomcat servers. ✅ **Performance Optimization** — Memcached reduces database load by caching frequently accessed data. ✅ **Reliable Communication** — RabbitMQ enables smooth handling of asynchronous tasks, improving system efficiency.

By integrating these components, the system achieves **high availability, optimised load management, and structured communication**, making it suitable for real-world DevOps applications. 🚀

### **Services Introduction**

![None](https://miro.medium.com/v2/resize:fit:700/1*8X5IcEHh2OjMX6OFl6i2Rw.jpeg)

**1\. Nginx** \=&gt; Nginx is a high-performance web server and reverse proxy used for serving websites, load balancing, and handling HTTP requests efficiently.

**2\. Tomcat** =&gt; Tomcat is an open-source Java Servlet container that runs Java web applications and serves JSP and servlet-based content.

**3\. RabbitMQ** =&gt; RabbitMQ is an open-source message broker that facilitates communication between distributed systems by handling, storing, and forwarding messages between producers and consumers.

**4\. Memcache** =&gt; Memcache is an in-memory key-value store used to speed up dynamic web applications by caching frequently accessed data, reducing database load and improving performance.

**5\. MySQL** =&gt; MySQL is an open-source relational database management system (RDBMS) that uses SQL (Structured Query Language) for storing, managing, and retrieving data in a structured format.

### **1\. Setup MySQL. VM hostname db01**

ssh to db01

```go
Copy> vagrant ssh db01
```

![None](https://miro.medium.com/v2/resize:fit:700/0*WlRFsasK1QZwhpWK)

Verify hosts file content

![None](https://miro.medium.com/v2/resize:fit:700/0*luv23hUQHcH5_qC5)

We used CentOS for this VM and CentOS is a Linux-based operating system derived from Red Hat Enterprise Linux (RHEL).

Update CentOS

```go
Copy> sudo yum update -y
```

Install MySQL / MariaDB

```go
Copy> sudo dnf install -y mariadb-server mariadb
```

After installation, start and enable MariaDB to run on boot

```go
Copy> sudo systemctl start mariadb
> sudo systemctl enable mariadb
```

Secure MariaDB Installation. Run the security script to set a root password as "**admin**" and remove unwanted defaults:

```go
Copy> sudo mysql_secure_installation
```

![None](https://miro.medium.com/v2/resize:fit:700/0*cxVNjKqYtqC5m2sK)

![None](https://miro.medium.com/v2/resize:fit:700/0*k-J97Qx4d60QQnjq)

Verify the MySQL access. User is **root**, password is **admin**. If you never used MySQL from terminal don't worry, keep doing, you will be familiar and expert slowly.

```go
Copy> mysql -u root -padmin
```

![None](https://miro.medium.com/v2/resize:fit:700/0*0YBtSu8n13PWkd0I)

create database accounts;

```go
CopyMariaDB > create database accounts;
MariaDB > grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin';
MariaDB > grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin';
MariaDB > FLUSH PRIVILEGES;
MariaDB > exit;
```

We have a database dump file on our repo location src/main/resources/db\_backup.sql. Now we will restore that dump to our created database name "accounts". Lets copy that file content to the MySQL vm db01 and restore it to the database accounts.

Open the file src/main/resources/db\_backup.sql on the Visual Studio

![None](https://miro.medium.com/v2/resize:fit:700/0*fgb5Xyh7gcpL9TPs)

Copy the file content -&gt; Access to VM db01 -&gt; create a file on the vm -&gt; paste the file content that copied and restore that dump on the database "accounts"

User nano or vim editor whichever you are comfortable with

![None](https://miro.medium.com/v2/resize:fit:700/0*uTe-j8KnTcoaqBrQ)

![None](https://miro.medium.com/v2/resize:fit:700/0*A8XAFfNogFvP3QZ3)

Verify the file is created

![None](https://miro.medium.com/v2/resize:fit:700/0*TBZpdAvIheV6vINm)

Restore the database dump file db\_backup.sql to the database "accounts"

```go
Copy> mysql -u root -padmin accounts < db_backup.sql
> mysql -u root -padmin accounts
```

![None](https://miro.medium.com/v2/resize:fit:700/0*HIdkttaY-zAz_9BY)

Setting up firewall and allowing the mariadb to access from port 3306 because MySQL

sudo service runs at port 3306.

```go
Copy> systemctl start firewalld
> systemctl enable firewalld
> firewall-cmd --get-active-zones
> firewall-cmd --zone=public --add-port=3306/tcp --permanent
> firewall-cmd --reload
> systemctl restart mariadb
```

![None](https://miro.medium.com/v2/resize:fit:700/0*Tw-WI1Wj-fsKoR-e)

### **2\. Setup Memcache. VM hostname mc01**

ssh to Memcache vm

```go
Copy> vagrant ssh to mc01
```

Verify hosts

![None](https://miro.medium.com/v2/resize:fit:700/0*DpY4qgrnMpBKXdj6)

Update CentOS. Run the following command to update your system packages:

```go
Copy> sudo yum update -y
```

![None](https://miro.medium.com/v2/resize:fit:700/0*PBn2imvUmL6D_hdS)

Install memcache, start & enable, allowing it to be accessible from any IP address, not just [localhost](http://localhost), it on port 11211

```go
Copy> sudo dnf install epel-release -y
> sudo dnf install memcached -y
> sudo systemctl start memcached
> sudo systemctl enable memcached
> sudo systemctl status memcached
> sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
> sudo systemctl restart memcached
```

Setting Up Firewall Rules for Memcached (Ports 11211 & 11111)

```go
Copy> sudo systemctl start firewalld
> sudo systemctl enable firewalld
> sudo firewall-cmd --add-port=11211/tcp
> sudo firewall-cmd --runtime-to-permanent
> sudo firewall-cmd --add-port=11111/udp
> sudo firewall-cmd --runtime-to-permanent
> sudo memcached -p 11211 -U 11111 -u memcached -d
```

Verify firewall ports

```go
Copy> sudo firewall-cmd --list-ports
```

![None](https://miro.medium.com/v2/resize:fit:700/0*5ly77QRx8jWQYRhI)

Check if Memcached is listening on port 11211

![None](https://miro.medium.com/v2/resize:fit:700/0*XhqUDJtvQ4IeCySc)

### **3\. Setup RabbitMQ. VM hostname rmq01**

Ssh to RabbitMQ vm

```go
Copy> vagrant ssh rmq01
```

![None](https://miro.medium.com/v2/resize:fit:700/0*GYPrwPoiuGDo2YGz)

Update CentOS

Run the following command to update your system packages:

```go
Copy> sudo yum update -y
```

![None](https://miro.medium.com/v2/resize:fit:700/0*9rzQjitGEE7RTFkP)

Install RabbitMQ and enable service.

```go
Copy> sudo dnf install epel-release -y
> sudo dnf -y install centos-release-rabbitmq-38
> sudo dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
> sudo systemctl enable --now rabbitmq-server
```

Allow external access and set up user 'test' as an administrator in RabbitMQ ✅ Allowing external access (loopback\_users, \[\]) ✅ Creating the user test ✅ Granting admin privileges to test ✅ Setting permissions ✅ Restarting RabbitMQ to apply changes

```go
Copy> sudo echo "loopback_users = none" | sudo tee /etc/rabbitmq/rabbitmq.conf
> sudo rabbitmqctl add_user test test
> sudo rabbitmqctl set_user_tags test administrator
> sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
> sudo systemctl restart rabbitmq-server
```

Starting the Firewall and Allowing Port 5672 for RabbitMQ Access

```go
Copy> sudo ss -tulnp | grep beam
```

![None](https://miro.medium.com/v2/resize:fit:700/0*F58YvtRHfqiyPlPI)

### **4\. Setup Tomcat. VM hostname app01**

Ssh to Tomcat vm

```go
Copy> vagrant ssh app01
```

Verify hosts

![None](https://miro.medium.com/v2/resize:fit:700/0*E7n-NLAhw82UQb16)

Check CentOS version

![None](https://miro.medium.com/v2/resize:fit:700/0*dEzyP5uOeKiSWhJl)

Run the following command to update your system packages:

```go
Copy> sudo yum update -y
```

![None](https://miro.medium.com/v2/resize:fit:700/0*adPmB0Y-4TKx2dwk)

Installing Java, Git, Maven, and Wget

```go
Copy> sudo dnf -y install java-11-openjdk java-11-openjdk-devel
> sudo dnf install git maven wget -y
```

Verify Java and Maven installed version

```go
Copy> java --version
> mvn -version
```

![None](https://miro.medium.com/v2/resize:fit:700/0*wCOM8GIhWIaR7Rmn)

Downloading Apache Tomcat 9.0.75 using Wget

```go
Copywget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
```

![None](https://miro.medium.com/v2/resize:fit:700/0*S0FDro9HziWVl_LB)

Unzip that downloaded file

```go
Copy> tar xzvf apache-tomcat-9.0.75.tar.gz
```

![None](https://miro.medium.com/v2/resize:fit:700/0*CEkGnK4Y3Bfkr1G7)

Add user name tomcat. This is typically done when setting up Apache Tomcat, ensuring that the tomcat user exists but cannot log in, enhancing security.

```go
Copy> sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
```

Copy Tomcat all files that extracted from zip to /usr/local/tomcat that created for tomcat user

```go
Copy> sudo cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
```

Make tomcat user owner of tomcat home dir

```go
Copy> sudo chown -R tomcat.tomcat /usr/local/tomcat
```

Lets verify that folder /usr/local/tomcat owns by tomcat user

![None](https://miro.medium.com/v2/resize:fit:700/0*8X940wTn7LsaW9YJ)

Creating a Systemd Service for Tomcat

```go
Copy> sudo vim /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
```

Lets verify

![None](https://miro.medium.com/v2/resize:fit:700/0*9GZYR3srW4JvDuJq)

Reload systemd file

```go
Copy> sudo systemctl daemon-reload
```

Start & Enable service

```go
Copy> sudo systemctl start tomcat
> sudo systemctl enable tomcat
> sudo systemctl status tomcat
```

![None](https://miro.medium.com/v2/resize:fit:700/0*wrIrLQS8-C29re2b)

Configuring Firewall to Allow Tomcat on Port 8080

```go
Copy> sudo systemctl start firewalld
> sudo systemctl enable firewalld
> sudo firewall-cmd --get-active-zones
> sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
> sudo firewall-cmd --reload
```

Check if port 8080 is open

```go
Copy> sudo firewall-cmd --zone=public --query-port=8080/tcp
```

![None](https://miro.medium.com/v2/resize:fit:700/0*-fqhlTf1OSI4_1KX)

Setting Memory Limits for Maven

```go
Copy> export MAVEN_OPTS="-Xmx512m"
```

Code build and deploy. Java code needs to build before deployment.

* Clone the repo

* checkout to branch: local-setup-mun

* Staying in the /tmp folder

```go
Copy> git clone https://github.com/Muncodex/digiprofile-project.git
> cd digiprofile-project/
> git checkout local-setup-mun
```

Make sure you are at the branch: **local-setup-mun**

![None](https://miro.medium.com/v2/resize:fit:700/0*Zmq8H5FDl92JllIK)

Check the folder and files

![None](https://miro.medium.com/v2/resize:fit:700/0*BiIp7XbhZCXUQzfP)

Check the files at src/main/resources/

![None](https://miro.medium.com/v2/resize:fit:700/0*Q9k_hfhDcSpURWif)

We need to update the [`application.properties`](http://application.properties) file, as it contains the application's configuration settings. The configurations should be adjusted according to our VM host, IP, username, password, and other relevant details. This file is essential for the application to connect to the backend services, as it defines all backend service endpoints and authentication credentials.

Open the file with vim or nano whichever you are comfortable with.

MySQL vm db01:

* User: root

* Pass: admin

> **Note:** Before running any command, I always use the `pwd` command in the terminal to display my current location. This ensures clarity on the required directory before executing any further commands.

![None](https://miro.medium.com/v2/resize:fit:700/0*wSnmkobEG_h82qiZ)

[application.properties](http://application.properties)

```go
Copy#JDBC Configutation for Database Connection
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://db01:3306/accounts?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
jdbc.username=admin
jdbc.password=admin

#Memcached Configuration For Active and StandBy Host
#For Active Host
memcached.active.host=mc01
memcached.active.port=11211
#For StandBy Host
memcached.standBy.host=127.0.0.2
memcached.standBy.port=11211

#RabbitMq Configuration
rabbitmq.address=rmq01
rabbitmq.port=5672
rabbitmq.username=test
rabbitmq.password=test

#Elasticesearch Configuration
elasticsearch.host =192.168.1.85
elasticsearch.port =9300
elasticsearch.cluster=digiprofile
elasticsearch.node=digiprofilenode
```

Match your file with this one; it should be exactly the same. Go through the code and ensure that the hostname, username, password, port, and other details match.

> Now we are ready to make our source code to package by maven.

Following command will make the package from source code.

![None](https://miro.medium.com/v2/resize:fit:700/0*rw7RVjdwELD7IX8Y)

Once the above command finishes, it creates a new directory named '**target**,' where the compiled application is saved.

![None](https://miro.medium.com/v2/resize:fit:700/0*XDprwNNt9P6UaIEj)

Check files on the "**target**" folder

![None](https://miro.medium.com/v2/resize:fit:700/0*QuCkBSi5reDEdD7h)

Lets focus on the file **digiprofile-v2.war** in this directory.

* The .war file (Web Application Archive) is used to deploy Java-based web applications on a server Tomcat.

* This file created as war because our project is configured as a WAR project in **pom.xml** file, indicated by:

```go
Copy<packaging>war</packaging>
```

> Why is it named digiprofile-v2.war?

The name is derived from Maven project's artifact ID and version, as defined in **pom.xml**

```go
Copy<artifactId>digiprofile</artifactId>
<packaging>war</packaging>
<version>v2</version>
```

Lets explore what is an **artifact** in Maven. It is just the **final output file** that Maven creates when you build a project. Its crucial to know about artifact to be a DevOps expert.

Think of it like baking a cake:

* The **recipe** (Maven configuration in pom.xml) tells how to make it.

* The **ingredients** (source code and dependencies) are put together.

* The **oven** (Maven build process) bakes everything.

* The **cake** (artifact) is the final product you get at the end!

In our case, the artifact is digiprofile-v2.war, which is a **ready-to-use web application file** that can be deployed to a server Tomcat and in the next step, we will do that.

Before going to the next step, lets check the default page hosted at the tomcat server. The VM name of the Tomcat server is **app01** and the ip address is **192.168.56.12** and it is running on the **8080**. So browsing endpoint is **192.168.56.12:8080**

![None](https://miro.medium.com/v2/resize:fit:700/0*9IKN5yPst_W6TCVf)

> 192.168.56.12:8080

![None](https://miro.medium.com/v2/resize:fit:700/0*zW1dJEqGx-taV5yH)

Switch to the root user to avoid using sudo for every command.

```go
Copy> sudo -i
```

![None](https://miro.medium.com/v2/resize:fit:700/0*d-Aq6kpQ2QQ7Isa0)

The default webpage is displayed by Tomcat when we browse to 192.168.56.12:8080. It is served from the location: /usr/local/tomcat/webapps/ROOT/.

![None](https://miro.medium.com/v2/resize:fit:700/0*CskEGgqClz1IkzSA)

To ensure our application runs correctly, we will perform the following steps:

* Remove the ROOT directory.

* Copy the `digiprofile-v2.war` file to this location and rename it as `ROOT.war`.

Remove ROOT directory

![None](https://miro.medium.com/v2/resize:fit:700/0*0OeH0stNMpaSr-15)

Make sure you are at this location

![None](https://miro.medium.com/v2/resize:fit:700/0*cqEvhSwOSmvwMMvf)

Copy the `digiprofile-v2.war` file to the specified location and rename it as `ROOT.war`.

![None](https://miro.medium.com/v2/resize:fit:700/0*AhLPG7mVVsNL4yFx)

Now, let's check the endpoint to verify if our application is displayed after updating the build RAR file. At this point, you may see a blank page with a 404 — Not Found error. This occurs because the ROOT.RAR file is owned by the root user, as shown in the screenshot above. To resolve this, we need to change the ownership of the file to the **tomcat** user. We'll walk through this step in next.

![None](https://miro.medium.com/v2/resize:fit:700/0*EwTCeiKqjRKSJkzx)

Change the owner to tomcat

```go
Copy> chown tomcat.tomcat /usr/local/tomcat/webapps -R
```

Check again **192.168.56.12:8080** and application shows perfectly **User:** nextgen7 **Pass:** nextgen7

![None](https://miro.medium.com/v2/resize:fit:700/0*cvg0HBN7VnBaVJEF)

In the next step, we will set up the Nginx web server on the VM named '**web01**,' which is running inUbuntu.

### **5\. Setup Nginx. VM hostname web01**

ssh to Nginx vm

```go
Copy> vagrant ssh web01
```

Switch to the root user.

```go
Copy> sudo -i
```

![None](https://miro.medium.com/v2/resize:fit:700/0*6G0S6TUp0T0SxeVa)

Verify hosts

```go
Copy> cat /etc/hosts
```

![None](https://miro.medium.com/v2/resize:fit:700/0*3do6fwWE7I0Ko6cZ)

Update & Install Nginx

```go
Copy> apt update
> apt upgrade
> apt install nginx -y
```

Create a Nginx config file. Use vim or nano for it.

```go
Copy> vim /etc/nginx/sites-available/digiprofileapp
upstream digiprofileapp {
  server app01:8080;
}

server {
  listen 80;
  location / {
    proxy_pass http://digiprofileapp;
  }
}
```

Remove default Nginx config file

```go
Copy> rm -rf /etc/nginx/sites-enabled/default
```

**The following command will create a symbolic link** from the Nginx site configuration file for digiprofileapp, located in /etc/nginx/sites-available/, to the /etc/nginx/sites-enabled/ directory. The symlink allows Nginx to enable the configuration without duplicating the file, which is a common practice for managing Nginx server blocks.

```go
Copy> ln -s /etc/nginx/sites-available/digiprofileapp 
/etc/nginx/sites-enabled/digiprofileapp
```

Restart Nginx to apply the changes.

```go
Copy> systemctl restart nginx
```

All ready at this point. Now we can access the application through nginx. Let browse through Nginx vm ip which is running in port 80

**When you reach this milestone, take a moment to celebrate — it's a huge accomplishment! Congratulations!** 🎉

You've successfully set up the application with five essential services: **MySQL, Memcache, RabbitMQ, Tomcat, and Nginx**. This project lays the foundation for your next DevOps challenges.

Your success here is a testament to your hard work, dedication, and technical expertise. Take pride in mastering this crucial step in your DevOps journey.

Celebrate your progress — you've earned it! We'll be back soon with another exciting DevOps project to tackle together. Until then, keep up the fantastic work, and see you in the next challenge! 🚀

## 🛠️ Author & Community  

This project is crafted by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.  
I’d love to hear your feedback! Feel free to share your thoughts.  

📧 **Connect with me:**

- **GitHub**: [@NotHarshhaa](https://github.com/NotHarshhaa)
- **Blog**: [ProDevOpsGuy](https://blog.prodevopsguy.xyz)  
- **Telegram Community**: [Join Here](https://t.me/prodevopsguy)  

---

## ⭐ Support the Project  

If you found this helpful, consider **starring** ⭐ the repository and sharing it with your network! 🚀  

### 📢 Stay Connected  

![Follow Me](https://imgur.com/2j7GSPs.png)
