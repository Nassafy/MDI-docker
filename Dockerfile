exposeFROM ubuntu:18.04 as builder

RUN apt-get update
RUN apt-get install -y git cmake maven ant software-properties-common openjdk-8-jdk

RUN git clone git://github.com/opencv/opencv.git
WORKDIR /opencv

RUN apt-get install -y build-essential
RUN apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN export JAVA_HOME

RUN git checkout 3.4 && mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=OFF .. && make -j8

WORKDIR /
RUN git clone https://github.com/Nassafy/ESIRTPDockerSampleApp
WORKDIR /ESIRTPDockerSampleApp

RUN mvn install:install-file \
   -Dfile=/opencv/build/bin/opencv-346.jar \
   -DgroupId=org.opencv \
   -DartifactId=opencv \
   -Dversion=3.4.6 \
   -Dpackaging=jar \
   -DgeneratePom=true && mvn package   

FROM ubuntu:18.04 as prod

RUN apt-get update
RUN apt-get install -y openjdk-8-jre-headless
RUN apt-get install -y libtiff5 libdc1394-22 ffmpeg
RUN mkdir -p opencv/lib && mkdir -p opencv/data/
COPY --from=builder /opencv/build/lib/libopencv_java346.so /opencv/lib/libopencv_java346.so
COPY --from=builder /opencv/data/haarcascades /opencv/data/haarcascades
COPY --from=builder /ESIRTPDockerSampleApp/target/fatjar-0.0.1-SNAPSHOT.jar /fatjar-0.0.1-SNAPSHOT.jar
CMD ["java", "-Djava.library.path=/opencv/lib/", "-jar", "/fatjar-0.0.1-SNAPSHOT.jar"]



