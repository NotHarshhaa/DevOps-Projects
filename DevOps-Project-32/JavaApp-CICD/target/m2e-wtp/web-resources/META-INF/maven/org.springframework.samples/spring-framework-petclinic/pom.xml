<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>org.springframework.samples</groupId>
    <artifactId>spring-framework-petclinic</artifactId>
    <version>5.3.13</version>

    <name>Spring Framework Petclinic</name>
    <packaging>war</packaging>
    <description>A Spring Framework application based on JSP, Spring MVC, Spring Data JPA, Hibernate and JDBC</description>
    <url>https://spring-petclinic.github.io/</url>

    <properties>

        <!-- Generic properties -->
        <java.version>1.8</java.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <maven.compiler.source>${java.version}</maven.compiler.source>
        <maven.compiler.target>${java.version}</maven.compiler.target>

        <!-- Spring -->
        <!-- For framework compatibility, refer to the Spring Boot Dependencies BOM -->
        <!-- https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-dependencies/build.gradle -->
        <spring-framework.version>5.3.18</spring-framework.version>

        <!-- Web dependencies -->
        <!-- Version update should also be done in wro.xml, petclinic.less and static resources: htmlHeader.tag and footer.tag-->
        <webjars-bootstrap.version>3.3.6</webjars-bootstrap.version>
        <webjars-jquery-ui.version>1.12.1</webjars-jquery-ui.version>
        <webjars-jquery.version>3.5.1</webjars-jquery.version>
        <wro4j.version>1.8.0</wro4j.version> <!-- wro4j 1.0.0 requires Java 9 -->

        <!-- Java EE / Java SE dependencies -->
        <tomcat.version>9.0.46</tomcat.version>
        <jaxb-api.version>2.3.1</jaxb-api.version>
        <jaxb-runtime.version>2.3.4</jaxb-runtime.version>
        <javax-activation.version>1.2.0</javax-activation.version>
        <servlet-api.version>4.0.4</servlet-api.version>
        <taglibs-standard.version>1.2.5</taglibs-standard.version>

        <!-- Persistence -->
        <spring-data.version>2021.1.0-RC1</spring-data.version>
        <hibernate.version>5.6.0.Final</hibernate.version>
        <hibernate-validator.version>6.2.0.Final</hibernate-validator.version>
        <hsqldb.version>2.5.2</hsqldb.version>
        <h2database.version>1.4.200</h2database.version>

        <!-- Logging -->
        <slf4j.version>1.7.32</slf4j.version>
        <logback.version>1.2.6</logback.version>

        <!-- Test -->
        <assertj.version>3.21.0</assertj.version>
        <json-path.version>2.6.0</json-path.version>
        <mockito.version>4.0.0</mockito.version>
        <hamcrest.version>2.2</hamcrest.version>
        <junit-jupiter.version>5.8.1</junit-jupiter.version>

        <!-- JDBC Drivers -->
        <mysql-driver.version>8.0.19</mysql-driver.version>
        <postgresql-driver.version>9.4.1211.jre7</postgresql-driver.version>

        <!-- Others -->
        <jackson.version>2.12.4</jackson.version>
        <aspectj.version>1.9.7</aspectj.version>

        <!-- Maven plugins -->
        <jetty-maven-plugin.version>9.4.43.v20210629</jetty-maven-plugin.version>
        <maven-assembly-plugin.version>3.3.0</maven-assembly-plugin.version>
        <maven-compiler-plugin.version>3.8.1</maven-compiler-plugin.version>
        <maven-eclipse-plugin.version>2.10</maven-eclipse-plugin.version>
        <maven-resources-plugin.version>3.1.0</maven-resources-plugin.version>
        <maven-surefire-plugin.version>2.22.1</maven-surefire-plugin.version>
        <maven-war-plugin.version>3.3.1</maven-war-plugin.version>
        <jacoco-maven-plugin>0.8.6</jacoco-maven-plugin>

        <!-- Docker image -->
        <docker.jib-maven-plugin.version>2.6.0</docker.jib-maven-plugin.version>
        <docker.image.prefix>springcommunity</docker.image.prefix>

    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>com.fasterxml.jackson</groupId>
                <artifactId>jackson-bom</artifactId>
                <version>${jackson.version}</version>
                <scope>import</scope>
                <type>pom</type>
            </dependency>
            <dependency>
                <groupId>org.springframework.data</groupId>
                <artifactId>spring-data-bom</artifactId>
                <version>${spring-data.version}</version>
                <scope>import</scope>
                <type>pom</type>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependencies>
        <dependency>
            <groupId>org.apache.tomcat</groupId>
            <artifactId>tomcat-servlet-api</artifactId>
            <version>${tomcat.version}</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.tomcat</groupId>
            <artifactId>tomcat-jasper-el</artifactId>
            <version>${tomcat.version}</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>org.apache.taglibs</groupId>
            <artifactId>taglibs-standard-jstlel</artifactId>
            <version>${taglibs-standard.version}</version>
        </dependency>
        <!--  JSon -->
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-core</artifactId>
        </dependency>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
        </dependency>
        <dependency>
            <groupId>com.jayway.jsonpath</groupId>
            <artifactId>json-path</artifactId>
            <version>${json-path.version}</version>
            <scope>test</scope>
        </dependency>
        <!-- SPRING, SPRING, SPRINGITY SPRING -->
        <dependency>
            <groupId>org.springframework.data</groupId>
            <artifactId>spring-data-jpa</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>${spring-framework.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>${spring-framework.version}</version>
        </dependency>
        <!-- used for EhCacheCacheManager -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context-support</artifactId>
            <version>${spring-framework.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-oxm</artifactId>
            <version>${spring-framework.version}</version>
        </dependency>

        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjrt</artifactId>
            <version>${aspectj.version}</version>
        </dependency>
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <version>${aspectj.version}</version>
            <scope>runtime</scope>
        </dependency>

        <!-- Database connection pool
        See here for more details on commons-dbcp versus tomcat-jdbc:
        http://blog.ippon.fr/2013/03/13/improving-the-performance-of-the-spring-petclinic-sample-application-part-3-of-5/
    -->
        <dependency>
            <groupId>org.apache.tomcat</groupId>
            <artifactId>tomcat-jdbc</artifactId>
            <version>${tomcat.version}</version>
            <scope>runtime</scope>
        </dependency>

        <!-- Logging with SLF4J & LogBack -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>${slf4j.version}</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>${logback.version}</version>
            <scope>runtime</scope>
        </dependency>

        <!-- HIBERNATE -->
        <dependency>
            <groupId>org.hibernate</groupId>
            <artifactId>hibernate-entitymanager</artifactId>
            <version>${hibernate.version}</version>
        </dependency>
        <dependency>
            <groupId>org.hibernate.validator</groupId>
            <artifactId>hibernate-validator</artifactId>
            <version>${hibernate-validator.version}</version>
        </dependency>
        <dependency>
            <groupId>org.hibernate</groupId>
            <artifactId>hibernate-ehcache</artifactId>
            <version>${hibernate.version}</version>
        </dependency>


        <!-- Webjars -->
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>jquery</artifactId>
            <version>${webjars-jquery.version}</version>
        </dependency>
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>jquery-ui</artifactId>
            <version>${webjars-jquery-ui.version}</version>
        </dependency>
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>bootstrap</artifactId>
            <version>${webjars-bootstrap.version}</version>
        </dependency>

        <!-- Test Artifacts -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>${spring-framework.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-engine</artifactId>
            <version>${junit-jupiter.version}</version>
        </dependency>
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>${assertj.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>${mockito.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>${mockito.version}</version>
        </dependency>
        <dependency>
            <groupId>org.hamcrest</groupId>
            <artifactId>hamcrest</artifactId>
            <version>${hamcrest.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- JAXB and Activation added for Java 9 compatibility.
             The JAXB API is considered to be Java EE API and therefore is
             no longer contained on the default class path in Java SE 9 -->
        <dependency>
            <groupId>javax.xml.bind</groupId>
            <artifactId>jaxb-api</artifactId>
            <version>${jaxb-api.version}</version>
        </dependency>
        <dependency>
            <groupId>org.glassfish.jaxb</groupId>
            <artifactId>jaxb-runtime</artifactId>
            <version>${jaxb-runtime.version}</version>
        </dependency>
        <dependency>
            <groupId>javax.activation</groupId>
            <artifactId>javax.activation-api</artifactId>
            <version>${javax-activation.version}</version>
        </dependency>

    </dependencies>

    <!-- Maven plugin versions are mentioned in order to guarantee the build reproducibility in the long term -->
    <build>
        <defaultGoal>install</defaultGoal>
        <finalName>petclinic</finalName>
        <resources>
            <resource>
                <directory>${basedir}/src/main/resources</directory>
                <filtering>true</filtering>
            </resource>
        </resources>
        <testResources>
            <testResource>
                <!-- declared explicitly so Spring config files can be placed next to their corresponding JUnit test class  -->
                <directory>${project.basedir}/src/test/java</directory>
            </testResource>
            <testResource>
                <directory>${project.basedir}/src/test/resources</directory>
            </testResource>
        </testResources>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>${maven-compiler-plugin.version}</version>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>${maven-surefire-plugin.version}</version>
                <configuration>
                    <includes>
                        <include>**/*Tests.java</include>
                    </includes>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>${maven-war-plugin.version}</version>
                <configuration>
                    <failOnMissingWebXml>false</failOnMissingWebXml>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-eclipse-plugin</artifactId>
                <version>${maven-eclipse-plugin.version}</version>
                <configuration>
                    <downloadSources>true</downloadSources>
                    <downloadJavadocs>true</downloadJavadocs>
                    <wtpversion>2.0</wtpversion>
                    <sourceIncludes>
                        <sourceInclude>**/*.*</sourceInclude>
                    </sourceIncludes>
                    <additionalBuildcommands>
                        <buildCommand>
                            <name>org.springframework.ide.eclipse.core.springbuilder</name>
                        </buildCommand>
                        <buildCommand>
                            <name>org.eclipse.m2e.core.maven2Builder</name>
                        </buildCommand>
                    </additionalBuildcommands>
                    <additionalProjectnatures>
                        <projectnature>org.eclipse.jdt.core.javanature</projectnature>
                        <projectnature>org.springframework.ide.eclipse.core.springnature</projectnature>
                        <projectnature>org.eclipse.m2e.core.maven2Nature</projectnature>
                    </additionalProjectnatures>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>${maven-assembly-plugin.version}</version>
                <configuration>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>${jacoco-maven-plugin}</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>report</id>
                        <phase>prepare-package</phase>
                        <goals>
                            <goal>report</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

            <!--Specify the encoding for copying resources-->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-resources-plugin</artifactId>
                <version>${maven-resources-plugin.version}</version>
                <configuration>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>

            <plugin>
                <groupId>ro.isdc.wro4j</groupId>
                <artifactId>wro4j-maven-plugin</artifactId>
                <version>${wro4j.version}</version>
                <executions>
                    <execution>
                        <phase>generate-resources</phase>
                        <goals>
                            <goal>run</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <wroManagerFactory>ro.isdc.wro.maven.plugin.manager.factory.ConfigurableWroManagerFactory</wroManagerFactory>
                    <cssDestinationFolder>${project.build.directory}/petclinic/resources/css</cssDestinationFolder>
                    <wroFile>${basedir}/src/main/wro/wro.xml</wroFile>
                    <extraConfigFile>${basedir}/src/main/wro/wro.properties</extraConfigFile>
                    <contextFolder>${basedir}/src/main/webapp/resources/less</contextFolder>
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>org.webjars</groupId>
                        <artifactId>bootstrap</artifactId>
                        <version>${webjars-bootstrap.version}</version>
                    </dependency>
                    <!-- Required for Java 9 and above -->
                    <dependency>
                        <groupId>org.mockito</groupId>
                        <artifactId>mockito-core</artifactId>
                        <version>${mockito.version}</version>
                    </dependency>
                </dependencies>
            </plugin>

            <plugin>
                <groupId>org.eclipse.jetty</groupId>
                <artifactId>jetty-maven-plugin</artifactId>
                <version>${jetty-maven-plugin.version}</version>
            </plugin>

            <plugin>
                <groupId>com.google.cloud.tools</groupId>
                <artifactId>jib-maven-plugin</artifactId>
                <version>${docker.jib-maven-plugin.version}</version>
                <configuration>
                    <to>
                        <image>docker.io/${docker.image.prefix}/${project.artifactId}</image>
                        <tags>
                            <tag>${project.version}</tag>
                            <tag>latest</tag>
                        </tags>
                    </to>
                </configuration>
            </plugin>

        </plugins>
    </build>

    <profiles>
        <profile>
            <id>H2</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <db.script>h2</db.script>
                <jpa.database>H2</jpa.database>
                <jdbc.driverClassName>org.h2.Driver</jdbc.driverClassName>
                <jdbc.url>jdbc:h2:mem:petclinic</jdbc.url>
                <jdbc.username>sa</jdbc.username>
                <jdbc.password/>
            </properties>
            <dependencies>
                <dependency>
                    <groupId>com.h2database</groupId>
                    <artifactId>h2</artifactId>
                    <version>${h2database.version}</version>
                    <scope>runtime</scope>
                </dependency>
            </dependencies>
        </profile>
        <profile>
            <id>HSQLDB</id>
            <properties>
                <db.script>hsqldb</db.script>
                <jpa.database>HSQL</jpa.database>
                <jdbc.driverClassName>org.hsqldb.jdbcDriver</jdbc.driverClassName>
                <jdbc.url>jdbc:hsqldb:mem:petclinic</jdbc.url>
                <jdbc.username>sa</jdbc.username>
                <jdbc.password/>
            </properties>
            <dependencies>
                <dependency>
                    <groupId>org.hsqldb</groupId>
                    <artifactId>hsqldb</artifactId>
                    <version>${hsqldb.version}</version>
                    <scope>runtime</scope>
                </dependency>
            </dependencies>
        </profile>
        <profile>
            <id>MySQL</id>
            <properties>
                <db.script>mysql</db.script>
                <jpa.database>MYSQL</jpa.database>
                <jdbc.driverClassName>com.mysql.cj.jdbc.Driver</jdbc.driverClassName>
                <jdbc.url>jdbc:mysql://localhost:3306/petclinic?useUnicode=true</jdbc.url>
                <jdbc.username>petclinic</jdbc.username>
                <jdbc.password>petclinic</jdbc.password>
            </properties>
            <dependencies>
                <dependency>
                    <groupId>mysql</groupId>
                    <artifactId>mysql-connector-java</artifactId>
                    <version>${mysql-driver.version}</version>
                    <scope>runtime</scope>
                </dependency>
            </dependencies>
        </profile>
        <profile>
            <id>PostgreSQL</id>
            <properties>
                <db.script>postgresql</db.script>
                <jpa.database>POSTGRESQL</jpa.database>
                <jdbc.driverClassName>org.postgresql.Driver</jdbc.driverClassName>
                <jdbc.url>jdbc:postgresql://localhost:5432/petclinic</jdbc.url>
                <jdbc.username>postgres</jdbc.username>
                <jdbc.password>petclinic</jdbc.password>
            </properties>
            <dependencies>
                <dependency>
                    <groupId>org.postgresql</groupId>
                    <artifactId>postgresql</artifactId>
                    <version>${postgresql-driver.version}</version>
                    <scope>runtime</scope>
                </dependency>
            </dependencies>
        </profile>
   </profiles>

    <repositories>
        <repository>
            <id>repository.spring.milestone</id>
            <name>Spring Milestone Repository</name>
            <url>https://repo.spring.io/milestone</url>
        </repository>
    </repositories>

</project>
