# Fun with Linux for Cloud & DevOps Engineers

![linux](https://imgur.com/VpPW8PM.png)

***New to Linux? Below assignment covering all the required basics of Linux to be familiar for an DevOps engineer.***

![Linux](https://imgur.com/xedzuwy.png)

## Skills

Below skills are required to complete the deployment steps:

Linux User Management, Permissions, Directory Structure, File Systems, File Management

## Pre-Requisites

Login to AWS cloud and create Linux based EC2 instance to complete the below assignment.

## Deployment

1. Login to the server as super user and perform below
    1. Create users and set passwords – user1, user2, user3
    2. Create Groups – devops, aws
    3. Change primary group of user2, user3 to ‘devops’ group
    4. Add ‘aws’ group as secondary group to the ‘user1’
    5. Create the file and directory structure shown in the above diagram.
    6. Change group of /dir1, /dir7/dir10, /f2 to “devops” group
    7. Change ownership of /dir1, /dir7/dir10, /f2 to “user1” user.
2. Login as user1 and perform below
    1. Create users and set passwords – user4, user5
    2. Create Groups – app, database
3. Login as ‘user4’ and perform below
   1. Create directory – /dir6/dir4
   2. Create file – /f3
   3. Move the file from “/dir1/f1” to “/dir2/dir1/dir2”
   4. Rename the file ‘/f2′ to /f4’
4. Login as ‘user1’ and perform below
   1. Create directory – “/home/user2/dir1”
   2. Change to “/dir2/dir1/dir2/dir10” directory and create file “/opt/dir14/dir10/f1” using relative path method.
   3. Move the file from “/opt/dir14/dir10/f1” to  user1 home directory
   4. Delete the directory recursively “/dir4”
   5. Delete all child files and directories under “/opt/dir14” using single command.
   6. Write this text “Linux assessment for an DevOps Engineer!! Learn with Fun!!” to the /f3 file and save it.
5. Login as ‘user2’ and perform below
   1. Create file “/dir1/f2”
   2. Delete /dir6
   3. Delete /dir8
   4. Replace the “DevOps” text to “devops” in the /f3 file without using  editor.
   5. Using Vi-Editor copy the line1 and paste 10 times in the file /f3.
   6. Search for the pattern “Engineer” and replace with “engineer” in the file /f3 using single command.
   7. Delete /f3
6. Login as ‘root’ user and perform below
   1. Search for the file name ‘f3’ in the server and list all absolute  paths where f3 file is found.
   2. Show the count of the number of files in the directory ‘/’
   3. Print last line of the file ‘/etc/passwd’
7. Login to AWS and create 5GB EBS volume in the same AZ of the EC2 instance and attach EBS volume to the Instance.
8. Login as ‘root’user and perform below
   1. Create File System on the new EBS volume attached in the previous step
   2. Mount the File System on /data directory
   3. Verify File System utilization using ‘df -h’ command – This command must show /data file system
   4. Create file ‘f1’ in the /data file system.
9. Login as ‘user5’ and perform below
   1. Delete /dir1
   2. Delete /dir2
   3. Delete /dir3
   4. Delete /dir5
   5. Delete /dir7
   6. Delete /f1 & /f4
   7. Delete /opt/dir14
10. Logins as ‘root’ user and perform below
1. Delete users – ‘user1, user2, user3, user4, user5’
2. Delete groups – app, aws, database, devops
3. Delete home directories  of all users ‘user1, user2, user3, user4, user5’ if any exists still.
4. Unmount /data file system
5. Delete /data directory
11. Login to AWS and detach EBS volume to the EC2 Instance and delete the volume and then terminate EC2 instance.

All done? still not confident? repeat the steps!

**Happy Learning!**

## 🛠️ Author & Community  

This project is crafted by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.  
I’d love to hear your feedback! Feel free to share your thoughts.  

📧 **Connect with me:**

- **GitHub**: [@NotHarshhaa](https://github.com/NotHarshhaa)  
- **Blog**: [ProDevOpsGuy](https://blog.prodevopsguy.xyz)  
- **Telegram Community**: [Join Here](https://t.me/prodevopsguy)  
- **LinkedIn**: [Harshhaa Vardhan Reddy](https://www.linkedin.com/in/harshhaa-vardhan-reddy/)  

---

## ⭐ Support the Project  

If you found this helpful, consider **starring** ⭐ the repository and sharing it with your network! 🚀  

### 📢 Stay Connected  

![Follow Me](https://imgur.com/2j7GSPs.png)  
