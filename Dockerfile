FROM ruby

ARG USER_ID=0
ARG GROUP_ID=0

## Rails needs a JS runtime for uglifier
RUN apt-get -yqq install curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -yqq install nodejs unzip libaio1 sudo

## Remove the host user's group id from the container if it already exists
RUN grep -v ":${GROUP_ID}:" /etc/group > /tmp/group && cp /tmp/group /etc/group

## Add the host user's group id to the container as the 'code_runner' group
RUN groupadd -g ${GROUP_ID} code_runner

## Remove the host user's user id from the container if it already exists
RUN U=`getent passwd ${USER_ID} | cut -d: -f1` && grep "^$U:" /etc/passwd && userdel -f $U || :

## Add the host user's user id to the container as the 'code_runner' user
RUN useradd code_runner -u ${USER_ID} -g ${GROUP_ID} --home-dir /usr/src/code_runner --create-home

## Add the code_runner user as a sudoer
RUN usermod -a -G sudo code_runner
RUN echo 'code_runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## next 3 RUN lines install the dependencies for the tiny_tds gem 
## freetds-0.95.80 was the latest one that would compile with no
## errors on this platform
RUN wget http://www.freetds.org/files/stable/freetds-0.95.80.tar.gz
RUN tar -xzf freetds-0.95.80.tar.gz
RUN cd freetds-0.95.80 && ./configure --prefix=/usr/local --with-tdsver=7.3 && make && make install

## next 9 lines install the dependencies for ruby-oci8
COPY instantclient-basiclite-linux.x64-18.3.0.0.0dbru.zip /tmp
COPY instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip /tmp
COPY instantclient-sqlplus-linux.x64-18.3.0.0.0dbru.zip /tmp
RUN mkdir -p /opt/oracle
WORKDIR /opt/oracle
RUN bash -c "unzip /tmp/instantclient-basiclite*"
RUN bash -c "unzip /tmp/instantclient-sdk*"
RUN bash -c "unzip /tmp/instantclient-sqlplus*"
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_18_3

## preparing for 'bundle install' which will
## install all the gems in the Gemfile
RUN chown ${USER_ID}:${GROUP_ID} /usr/src
WORKDIR /usr/src/code_runner
COPY app_init .
COPY guard_init .
COPY Gemfile .
COPY Gemfile.lock .
COPY Guardfile .
RUN chown ${USER_ID}:${GROUP_ID} Gemfile
RUN chown ${USER_ID}:${GROUP_ID} Gemfile.lock
RUN chown ${USER_ID}:${GROUP_ID} Guardfile
USER ${USER_ID}:${GROUP_ID}
RUN bundle install

## patch ajax-datatables-rails so that it will support MSSQL server
USER root
COPY ajax-datatables-rails-1.0.0.patch .
RUN patch -d /usr/local/bundle/gems -p0 < ajax-datatables-rails-1.0.0.patch

## initialize the guard gem
USER ${USER_ID}:${GROUP_ID}
RUN cp Gemfile /var/tmp
RUN cp Gemfile.lock /var/tmp
RUN ./guard_init
RUN cp Guardfile /var/tmp
