# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM ubuntu:focal as build

ARG MORE_BUILD_ARGS

# workaround tzdata install hanging
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update &&\
    apt install -y git gcc g++ make cmake autoconf automake libtool python3 libssl-dev \
    curl apt-utils pkg-config 

WORKDIR /kvrocks

COPY . .

RUN curl -O https://download.redis.io/releases/redis-6.2.7.tar.gz && \
    tar -xzvf redis-6.2.7.tar.gz

RUN mkdir tools && \
    cd redis-6.2.7 && \
    make redis-cli 

    
RUN ls -l redis-6.2.7/src/redis-cli
RUN mv redis-6.2.7/src/redis-cli tools/redis-cli
RUN ls -lh tools/redis-cli

RUN mkdir build && touch build/kvrocks

FROM ubuntu:focal



WORKDIR /kvrocks

COPY --from=build /kvrocks/build/kvrocks ./bin/
COPY --from=build /kvrocks/tools/redis-cli ./bin/

RUN ls -lh ./bin
ARG TARGETARCH
RUN echo "TARGETARCH is set to???: ${TARGETARCH}"



VOLUME /var/lib/kvrocks

COPY ./LICENSE ./NOTICE ./DISCLAIMER ./
COPY ./licenses ./licenses
COPY ./kvrocks.conf  /var/lib/kvrocks/

EXPOSE 6666:6666
CMD while true; do sleep 1000; done