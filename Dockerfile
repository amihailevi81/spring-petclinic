FROM openjdk:17

RUN mkdir /build
WORKDIR /build

COPY ./target .

CMD ["java", "-jar", "spring-petclinic-3.1.0-SNAPSHOT.jar"]
