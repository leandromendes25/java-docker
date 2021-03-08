FROM maven:3.6.3-ibmjava-alpine AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:17-jdk-alpine3.13
RUN adduser -u 1000 -h /home/leandro -D leandro
RUN touch /home/leandro/.bashrc | echo "PS1='\w\$ '" >> /home/leandro/.bashrc

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
RUN apk add --no-cache npm nodejs \
    && apk add --no-cache bash 
    
WORKDIR /home/leandro/app
COPY --from=build /home/app/target/0.0.1-SNAPSHOT.jar  /usr/local/lib/app.jar

USER leandro

# ENTRYPOINT /bin/sh -c "while sleep 1000; do :; done"
ENTRYPOINT ["java","-jar","/usr/local/lib/app.jar"]
