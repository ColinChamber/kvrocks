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


FROM ubuntu:focal

ARG MORE_BUILD_ARGS
RUN set -x ; echo ${MORE_BUILD_ARGS}

ARG TARGETARCH
RUN set -x ; echo ${TARGETARCH}
COPY tools/redis-cli-${TARGETARCH} /usr/bin/redis-cli
RUN chmod a+x /usr/bin/redis-cli

RUN apt update && apt install -y libssl-dev

WORKDIR /kvrocks



VOLUME /var/lib/kvrocks

COPY ./LICENSE ./NOTICE ./DISCLAIMER ./
COPY ./licenses ./licenses
COPY ./kvrocks.conf  /var/lib/kvrocks/

EXPOSE 6666:6666
CMD while true; do sleep 1000; done
