# Building Scalable, Secure, and High-Performance Web Applications with AWS 3-Tier Architecture

## Architecture Overview

![alt text](image-1.png)

*In today’s digital age, building a scalable and secure web application is crucial for business success. The [AWS 3-Tier Web Application Architecture](https://www.ibm.com/topics/three-tier-architecture) stands out as a best practice for deploying cloud-based applications with efficiency and reliability. By leveraging [Amazon Web Services (AWS)](https://catalog.us-east-1.prod.workshops.aws/workshops/85cd2bb2-7f79-4e96-bdee-8078e469752a/en-US/part0/code) to create a three-tier architecture, businesses can achieve enhanced scalability, security, and performance. This architecture divides the application into three layers: the Web Tier, Application Tier, and Database Tier — each designed to handle specific tasks, ensuring seamless operation and optimal user experience. In this blog post, we’ll delve into how the AWS 3-Tier architecture can be leveraged to build resilient and high-performing web applications. You can are a Automation Geek, checkout my [**2 tier architecture**](https://readmedium.com/deploying-2-tier-architecture-in-aws-using-terraform-modules-9143ec6d2623) in AWS using Terraform.*

![alt text](image.png)

### **Practical Implementation**

Step 1: Start by creating an S3 bucket which will hold the code for you tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*IjRKhFdV8TSzusuj7T7wuw.png)

STEP 2: Create an instance role for ec2 service, allow access to S3 but only restricted read access.

![None](https://miro.medium.com/v2/resize:fit:700/1*1pl0uEvyKM6MQZnzdvRzlg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*2wS9jSoDalfxM-md7bLgUw.png)

STEP 3: Create an Separate VPC for this architecture, Separate VPC provides network Isolation.

![None](https://miro.medium.com/v2/resize:fit:700/1*KESuWrZGocXcn0kf7KG_0w.png)

STEP 4: Create Subnets in different AZ, to create a multi AZ setup.We Will be having two Public and Two private subnets.

![None](https://miro.medium.com/v2/resize:fit:700/1*bWT_qmXnAJ7SjfIWPrH9dA.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*fZmYMh75YeL_H3479NX5RA.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*RNkKtGCEbuSxL6LskDITbw.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*bVkBSD5_7nLpDi2lQwaDGw.png)

STEP 5: Create a 5th and 6th subnet for the private Database, again in multi AZ.

![None](https://miro.medium.com/v2/resize:fit:700/1*M4xjvquhnliA7A-Kgmltjw.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*lrlYtzQsRPFOKH91PEPO2w.png)

After all the configuration we'll be having 6 subnets, As shown below:

![None](https://miro.medium.com/v2/resize:fit:700/1*tpKAHneT4ync8Q1qE4gZrA.png)

STEP 6: Create an internet Gateway, IGW is used to route traffic from internet to instance and vice versa, if all the newtork restrictions are allowed.

![None](https://miro.medium.com/v2/resize:fit:700/1*la67IfJr7cUyk3_IkAYYJw.png)

STEP 7: Attach this to the VPC which we just created above.

![None](https://miro.medium.com/v2/resize:fit:700/1*7UDgUgolHljAG4YA11Pabg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*8XgnYr9NbJtPQXTeNwaN9w.png)

STEP 8: Create NAT Gateway, NAT in simpler allows instance to access network outside the instance, but doesn't allow external Traffic to come inside the instance.As its A subnet level resource we attach the first NAT to the public subnet 1 in AZ1.

![None](https://miro.medium.com/v2/resize:fit:700/1*5Cj8ZoXA5PbXCaEXoMBPdw.png)

STEP 9: Create a second NAT Gateway and attach it to the second public AZ subnet.

![None](https://miro.medium.com/v2/resize:fit:700/1*MJ1WmEes_mxST4VcGzxbPg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*dp2VzmuOi0xuLOxWr-ZeLw.png)

STEP 10: Create the route Tables with the specified subnet and routes.

![None](https://miro.medium.com/v2/resize:fit:700/1*09INiA9QTufJUjTrLYZCcQ.png)

STEP 11: Edit route table for public destination internet and source IGW.

![None](https://miro.medium.com/v2/resize:fit:700/1*8B1_q6PjiCTdAI24QxaeQg.png)

STEP 12: Subnet Association with the public subnet.

![None](https://miro.medium.com/v2/resize:fit:700/1*yEc0oszDxu6Osh75FC-K3A.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*bKW9pOKM2inP6VrzH8vDvA.png)

Create route table for the private subnet, but this time in routes add Nat Gateway, Private Subnet.

![None](https://miro.medium.com/v2/resize:fit:700/1*y4HsC7hJXPsSlIiV-94bSw.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*fwNyqdVX69x4LpPD5dFs3g.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*EUqQkjeGdX6ccq0dL3YScg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*jP_S96Tn3PaY_64zzmAlmA.png)

#### **CREATING SECURITY GROUPS**

In this section we will be creating security groups for all requirments. Security groups plays an integral part of the AWS security best practices, Regulating them can be benificial for you overall security.

1. ALB security group:
    

This allow's internet traffic to reach you ALB.

![None](https://miro.medium.com/v2/resize:fit:700/1*r_w4tVetqRYLl0xpAmrdEg.png)

2) Web Tier Security Group:

This allows traffic from ALB to web Tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*W6zhGNK-C2YU_w-F_-0cdQ.png)

3) Internal LB SG:

There's an Internal ALB security group, which internally used for networking.

![None](https://miro.medium.com/v2/resize:fit:700/1*RMdLP2jX4DfHiWkRWOpxDg.png)

4) SG for private instance:

These allows only Certain IP(MY IP) to access the private instance.

![None](https://miro.medium.com/v2/resize:fit:700/1*Sng0RMfl_iG2hFiBK6Rxhg.png)

5) DB private SG:

This allows the DB to be accessible from the instance.

![None](https://miro.medium.com/v2/resize:fit:700/1*hkLVzlx_7oaI-BKMlevWnw.png)

#### **Creating Database**

In this Setup We are using RDS as a Database, In This secrion we'll be doing configurations related to the RDS intance.

STEP 1: Creating Subnet Group for RDS

![None](https://miro.medium.com/v2/resize:fit:700/1*j6qinhnt9yrn4jBFgb5mqA.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*2fYJmmwJmQTuHQZY6P6wWw.png)

STEP 2: After Subnet Group create Database.We'll be creating a minimal setup of the RDS database as this is for testing purpose, you should not use this for a production setup.

![None](https://miro.medium.com/v2/resize:fit:700/1*ui6osOmpDFN-FMbYjJ3LMQ.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*oxH3Oah5bQZW88PVI6PRDQ.png)

2) Using the Dev Test version for lesser costing.

![None](https://miro.medium.com/v2/resize:fit:700/1*ZyD0oleaqdkdS2wKBvLqdQ.png)

STEP 3: Create a solid Master password for your database access.

![None](https://miro.medium.com/v2/resize:fit:700/1*-vkSa-9bA0TlyIDgaZrXRg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*i0ZHoj-G4uLcZaoqvw1drw.png)

STEP 4: Disable the ec2 connect options as we'll be managing that independently using security groups.

![None](https://miro.medium.com/v2/resize:fit:700/1*puwOfGRAZRqzO9bNx67dPQ.png)

STEP 5: Attach the VPC and security group for the database that we just created in the security group section.

![None](https://miro.medium.com/v2/resize:fit:700/1*DiTGc6pMpnjeJAEVnqezxQ.png)

As we have used most of the things for demo, This setup can cost you for database. You can fine tune more settings for reducing you infra cost.

![None](https://miro.medium.com/v2/resize:fit:700/1*G6tSVIxlYgPqVa70aAJN4g.png)

Wait for some time and you can see your database instance:

![None](https://miro.medium.com/v2/resize:fit:700/1*1nrfVd368hzNIyvd2vPjOg.png)

#### **Instance Management**

STEP 1: Create first instance in the private subnet with no public IP, attach the created security group to it.

![None](https://miro.medium.com/v2/resize:fit:700/1*GKatnXUuqy2iwwraMculFA.png)

STEP 2: Attach an role we just created in the first part.

![None](https://miro.medium.com/v2/resize:fit:700/1*L3M7V8SjUHmaAt_WEXWQwg.png)

We'll be connecting this instance using the session manager, for better management of the instance accessibility without using the keys, we can use the session manager.

![None](https://miro.medium.com/v2/resize:fit:700/1*-wvMX1_4tuPKkADwC8y-XA.png)

STEP 3: For Testing purpose, Download the myswl dependencies for testing your RDS Database accessibility.

![None](https://miro.medium.com/v2/resize:fit:700/1*9R1SPaELN-4P_Ku1AfTIkQ.png)

STEP 4: Copy the writer endpoint from the RDS service page.

![None](https://miro.medium.com/v2/resize:fit:700/1*9HJ7cp_qshv1zTLdZns1Ag.png)

STEP 5: login the database using the endpoint. If you are unable to login then you must check your database security group settings.

![None](https://miro.medium.com/v2/resize:fit:700/1*P1oQHValB-1YHrwVqkep9w.png)

STEP 6 Adding data in the database.

![None](https://miro.medium.com/v2/resize:fit:700/1*__CkijZ-KbPTsbvDVgDJdA.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*mX08BBgW07x5RMTIt8y2Og.png)

Refer to this code repository: *git clone* [*https://github.com/aws-samples/aws-three-tier-web-architecture-workshop.git*](https://github.com/aws-samples/aws-three-tier-web-architecture-workshop.git)

#### **Setting up S3 bucket Code Section**

In this section we will be adding the code repository in the s3 bucket storage.

![None](https://miro.medium.com/v2/resize:fit:700/1*_EoQD6-aRZ14V9o2807lRQ.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*uLF3-bX1fFIWNL-9WeEC5Q.png)

STEP 1: edit the DB config file with the db specific argument, like writer endpoints.

STEP 2: Upload the files of the app tier code in this S3 bucket.

![None](https://miro.medium.com/v2/resize:fit:700/1*v1HAsWWNDzWwsWbJGw1ePg.png)

STEP 3: Testing this code Successfully running node application using pm2.

![None](https://miro.medium.com/v2/resize:fit:700/1*EEBSrvDDPdRd9XkvzZwA_g.png)

STEP 4: Testing Endpoints.

![None](https://miro.medium.com/v2/resize:fit:700/1*xTQPJfgiKagZeHA8KvrWEA.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*qL0HwolgPF0f1nstf-YzJw.png)

STEP 5: AS this is an multi AZ setup hence, We have to do the same setup in the second AZ, Hence we'll be creating an Image out of this, And then Creating the Instance in the second AZ.

![None](https://miro.medium.com/v2/resize:fit:700/1*cgGtzR0lYL2Z5r0_IVUJVw.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*jY91mAYxQVeD32rzUHQlcQ.png)

Security group for private instance and as its app tier

![None](https://miro.medium.com/v2/resize:fit:700/1*TBYh5dQdsVPNfoEwCYMyFw.png)

choose the instance profile from the advance section

![None](https://miro.medium.com/v2/resize:fit:700/1*sk_hTRDGV5_veCKxTSCW5g.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*pjODq4t7DmsUtgizBhdHTg.png)

STEP 6: Creating Target Groups, for load balancing of the app tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*a8hu3c2E4kZy-hO-zbSZlg.png)

Choosing the cutom VPC we created in the earlier steps, 4000 is the target port.

![None](https://miro.medium.com/v2/resize:fit:700/1*roDR5oXpKfOxNf7jCCb-3Q.png)

/health as the health check endpoint.

![None](https://miro.medium.com/v2/resize:fit:700/1*2R0_uhJE6X44KeV5TFZRdg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*eb0gy5Cl7P8aWwFK0Aas3w.png)

STEP 7: Now create an Load Balancer and attach this Target group to this LB.

![None](https://miro.medium.com/v2/resize:fit:700/1*vObXwE1CRohod8InQC-_2Q.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*yJcktRKwU_iVkoNqoKbwAg.png)

STEP 8: Select internal as its not an internet facing load balancer.Use the private subnet as its internal.

![None](https://miro.medium.com/v2/resize:fit:700/1*XaSw5eGeC9BK97CGyKxaRg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*BqcgBHAn27Kq2r9Zt2gqrA.png)

STEP 9: Attach the internal ALB sg which we created to this ALB.

![None](https://miro.medium.com/v2/resize:fit:700/1*K2FfCOsorXqn2KuoeRaW-Q.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*j5NURcjPSyZKodmOMv_CCA.png)

STEP 10: Creating Launch template for auto scaling for the app tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*CRUoq4JlOHcZwXrYeFTOOg.png)

STEP 11: Select Subnet for the app tier private.

![None](https://miro.medium.com/v2/resize:fit:700/1*LzqSyoeqQz2WrXUbTOgT4w.png)

STEP 12: Select the existing Load Balancer for the intenal routing , and the taraget group we created above.

![None](https://miro.medium.com/v2/resize:fit:700/1*ip-yKGYOVr5NKhaOjn9TwA.png)

STEP 13: Setup Dynamic scaling , keeping desired and all as 2 for maximum fault tolerance and avalability.

![None](https://miro.medium.com/v2/resize:fit:700/1*RGcgKJoejRUXSo6TKBAqig.png)

Autoscaling group for the app tier will be created successfully.

![None](https://miro.medium.com/v2/resize:fit:700/1*dj8EatE8Ufk5v04rGA1fKw.png)

So the summary for the app tier was that we did all the setup in the ec2 from which we created an image and then put that image as the ami image for the other instance in the launch template , and this launch template will be used by the autoscaling group.. The load balancer wil contact to this instance.

![None](https://miro.medium.com/v2/resize:fit:700/1*syQAMCUs8aHmTALe7XXdpg.png)

#### **Setting up the web tier**

This Tier will be holding our frontend Tier.

STEP 1: Setup nginx,Edit the nginx conf file, add the proxy pass as the endpoint for the ALB.

![None](https://miro.medium.com/v2/resize:fit:700/1*uNaePUaQA4tL5X88ljWK-Q.png)

Copy the DNS name for the Internal LB.

![None](https://miro.medium.com/v2/resize:fit:700/1*gZB0nCV-qs0oDGzogH4sCw.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*oIFTv5ruZ3GSsGMnCRz_eA.png)

STEP 2: Edit these files with the endpoint and database connections, and upload this to the S3 bucket under the web-tier folder.

![None](https://miro.medium.com/v2/resize:fit:700/1*afA0AJBQ80qN0bbHf_apLg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*C9ZopEiku9FiohYutySzgQ.png)

STEP 3: Now setting up instances for the web tier, all the rest configuration is same as for the app tier just change the seurity groups.

![None](https://miro.medium.com/v2/resize:fit:700/1*k3GZVBNcSVFNMU43tfApiw.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*f2xPvGX68vwzFjnSyGbk4w.png)

STEP 4: Connect it using the session manager.

![None](https://miro.medium.com/v2/resize:fit:700/1*Nt4V2GdFhTGLyz200cRdzQ.png)

STEP 5: Setup the instance web tier application same as we did it in the app tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*xjTyVKWIM7GDMbJEqT5W2w.png)

STEP 6: Install nginx.

![None](https://miro.medium.com/v2/resize:fit:700/1*9wIX1CENMy0tXf_ZAVGvLw.png)

replacing the ngnix.conf file from the edit one which we uploaded in the s3 in the /etc/nginx.

![None](https://miro.medium.com/v2/resize:fit:700/1*CJ0GZ9qqHjOR2FCLUSpUcA.png)

STEP 7: starting nginx server and checking the status.

![None](https://miro.medium.com/v2/resize:fit:700/1*EaAQJNgDg1FxKy9BeXUdxg.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*qAL0dkpQJbIcTAj54s6P0Q.png)

#### **Now setting up the load balancer**

In this section we'll be creating web Tier autoscaling groups and Load Balancer configurations.

STEP 1: Create ami image for the web instance image as as we did in the app tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*z953K_2d-lWr9huyl0-VCA.png)

STEP 2: After successfullt creating the image,Create Target group for this load balancer.

![None](https://miro.medium.com/v2/resize:fit:700/1*ASNXeFrnai0UOxNrjDf12g.png)

STEP 3: As its an web tier , this time the port is 80.

![None](https://miro.medium.com/v2/resize:fit:700/1*jzi80-D2ek8A4HtDurSKRQ.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*PvK7H7EDWHOQ5926fL5hvw.png)

Now we have two target group one for app tier and other for web tier

![None](https://miro.medium.com/v2/resize:fit:700/1*u684yjWl-n-Py-ADa8Dk0g.png)

STEP 4: As it is internet facing load balancer enable intenet facing and select the public subnet for both the AZ.

![None](https://miro.medium.com/v2/resize:fit:700/1*gOMqFMSuOOxI4_4qpMNZqQ.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*E57Or4ZVeah3qalYRL2zZw.png)

STEP 5: Select the public facing Load Balancer security group.

![None](https://miro.medium.com/v2/resize:fit:700/1*I55rvIDIIiyhPEiUOu2L0g.png)

![None](https://miro.medium.com/v2/resize:fit:700/1*sGZCgLnfMVx8I_x4WBjx8w.png)

Now create the launch template similarlly to the app tier one jst change the images and the security group related to the web tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*RCrR_ogD6Ucbm5ESyoqbdg.png)

STEP 6: Creating auto sclaing group for web tier.

![None](https://miro.medium.com/v2/resize:fit:700/1*Vd7q4c4GTxhlTTT_zpJmZg.png)

As its an web tier and public hence the Subnet will be Public for both AZ

![None](https://miro.medium.com/v2/resize:fit:700/1*BvcaMkynuseaj-oZ2dohaw.png)

STEP 7: Add the dynamic scaling policy for this web tier auto scaling group.

![None](https://miro.medium.com/v2/resize:fit:700/1*ZfBY3IHkdJGZUgW9SGU9eg.png)

Launched the web tier load balancer with the 2 capacity.

![None](https://miro.medium.com/v2/resize:fit:700/1*myEKN12r2gTqLhs_LYsvsA.png)

After the complete setup of both the app and web tier, copy the dns of the web tier load balancer and hit it it will display this page.

![None](https://miro.medium.com/v2/resize:fit:700/1*YpMheCnnvYZIgtUb-cvs2Q.png)

The database demo can also be done here, and the amount and description can be directly added to the database from the UI.

![None](https://miro.medium.com/v2/resize:fit:700/1*e11AKydj09_3DtbHJlRVog.png)

### **Conclusion**

Adopting the **AWS 3-Tier Web Application Architecture** is a strategic move for businesses seeking to build secure, scalable, and high-performing applications in the cloud. By effectively separating the web, application, and database layers, this architecture not only enhances performance but also provides robust security and fault tolerance. As organizations continue to scale, the AWS 3-Tier architecture proves to be a reliable and flexible foundation for deploying cloud-based applications. Whether you're launching a new web app or optimizing an existing one, embracing this architecture will set your business up for long-term success in the cloud.

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
