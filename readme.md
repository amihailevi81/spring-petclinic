# PetClinic Assignment task

## Running the project locally

I  run the project on my Amazon EC2 linux 2.

There are pre-request package to install in the host before we can start:
- git
- Docker 
- JDK 17  
- Jenkins


<br>

### Make sure all dependencies are resolved from Maven Central

> Before we can compile the code we need to make sure that all the  dependencies are resolved from Maven Central.

> To ensure that all dependencies are resolved from Maven Central, you can follow these steps:

1. Open your project's pom.xml file in your preferred text editor.

2. Check if the following lines are present under the repositories and under the pluginRepositories section of your pom.xml file:

```diff
<repositories>
+     <repository>
+       <id>central</id>
+        <url>https://repo.maven.apache.org/maven2</url>
+        <releases>
+            <enabled>true</enabled>
+        </releases>
+    </repository>

  </repositories>

  <pluginRepositories>
+    <pluginRepository>
+      <id>central</id>
+        <url>https://repo.maven.apache.org/maven2</url>
+        <releases>
+            <enabled>true</enabled>
+        </releases>
+    </pluginRepository>
  </pluginRepositories>

```
3. If the lines in step 2 aren't present please add those lines and disable the current repository

```diff
!   <!-- <repository>
!      <id>spring-snapshots</id>
!      <name>Spring Snapshots</name>
!      <url>https://repo.spring.io/snapshot</url>
!      <snapshots>
!        <enabled>true</enabled>
!      </snapshots>
!    </repository>
!    <repository>
!      <id>spring-milestones</id>
!      <name>Spring Milestones</name>
!      <url>https://repo.spring.io/milestone</url>
!      <snapshots>
!        <enabled>false</enabled>
!      </snapshots>
!    </repository> -->

!    <!--<pluginRepository>
!      <id>spring-snapshots</id>
!      <name>Spring Snapshots</name>
!      <url>https://repo.spring.io/snapshot</url>
!      <snapshots>
!        <enabled>true</enabled>
!      </snapshots>
!    </pluginRepository>
!    <pluginRepository>
!      <id>spring-milestones</id>
!      <name>Spring Milestones</name>
!      <url>https://repo.spring.io/milestone</url>
!      <snapshots>
!        <enabled>false</enabled>
!      </snapshots>
!    </pluginRepository>-->

```
<br>

## To compile,run and test the project locally

### Clone git repo
```
git clone https://github.com/spring-projects/spring-petclinic
```

### Instsall dependencies
```
./mvnw dependency:resolve
```
> please check that all the dependencies are download from Maven central

### Compile the code
```
./mvnw compile
```

### Run the tests
```
./mvnw test
```

### Package the application
```
./mvnw package
```

### Run the application
```
java -jar target/*.jar
```

<br>

Please browser to: http://<YOUR_MACHINE_IP>:8080/ to check if the application work

<br>


## Running the project as a Docker container

After we check that the app is running without errors then we can create Docker Image by creating  Dockerfile 

<br>
Here is the Dockerfile content:

```
FROM openjdk:17
RUN mkdir /build
WORKDIR /build
COPY ./target .
CMD ["java", "-jar", "spring-petclinic-3.1.0-SNAPSHOT.jar"]
```
<br>
Building the Docker Image.

```
docker build . -t "amihaipet"
```
<br>
Test the image

```
docker run -p 80:8080 amihaipet
```

> NOTE: Because the app and Jenkins run on the same TCP port 8080  
> 
> I used -p 80:8080 to manipulate and map tcp port 80 (my machine) to tcp port 8080 of the container
---

<br><br>

## Working with the Jenkinsfile

<br>

 Jenkinsfile have two  section Stages and Environment.

<br>

### Stages

The stages part defines the stages in the pipeline .

The pipeline contains the following stages:

## Compile

Will compile the code 
<br>

## Test

Will test the compiled code.

<br>

## Package
Build the Docker Image 

<br>

## Publish

Tag the Docker Image and push is to Artifactory.

<br>

### Environment

<br>

The Environment  contains variables which will be used in the stage

Some of the varibles are clean test and the Username/Password that are secret you need to config it in the Jenkins

```
Artifactory_Repo = 'docker'
Artifactory_Username = credentials('username')
Artifactory_Password = credentials('password')
Artifactory_SRV = 'amihai.jfrog.io'
Image_Name = 'amihaipet'
```
> Note: You need to modify the jenkins user permissions to run docker commands.   
>```  
>sudo usermod -aG docker jenkins  
>```  
><br>
<br>


## Manualy pushing the Image to Artifactory

Let's push the image.
> Note:  For this step you will need a Jfrog Artifactory server. I used the cloud version of Jfrog Artifactory.

> Note:  Make sure you have the necessary permissions to upload files to Jfrog Artifactory.

In my environment login is required.
```
docker login myRTtenant.jfrog.io
```
Enter you credentials.

Once you get `Login Succeeded`, you can continue with the Push command.

Before that, you must tag the Image

```
docker tag ImageName myRTtenant.jfrog.io/MyDockerRepo/ImageName:latest
```

<br>
Now let's push it

```
docker push myRTtenant.jfrog.io/MyDockerRepo/ImageName:latest
```
<br>

---

## Pull the image and make it a running container

Let's pull the image from our Jfrom Artifactory repo and run it.

```
docker run -d -p 80:8080 myRTtenant.jfrog.io/MyDockerRepo/ImageName:latest
```

> Note: Since we purged all the images previously created, The image will be automatically pulled.

<br>

Verify the container is up 

```
docker ps
```

You can now  access petclinic here: http://<YOUR_MACHINE_IP>

<br>

---






<br><br><br><br><br><br> 



### References:
[mvn Commands and Options](https://www.digitalocean.com/community/tutorials/maven-commands-options-cheat-sheet)

[Using a Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/)


[Jfrog Pushing and Pulling Images](https://www.jfrog.com/confluence/display/JFROG/Docker+Registry#:~:text=4.9.0%22%2C%20%22targetTag%22%20%3A%20%22latest%22%7D%27-,Pushing%20and%20Pulling%20Images,-Set%20Me%20Up)

[Dockerfile Commands and Variables](https://docs.docker.com/engine/reference/builder/)
