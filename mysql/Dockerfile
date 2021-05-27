FROM centos
LABEL maintainer="Gustavo Gianini <gustavoogian@mail.com>" 

RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install mysql-server

ENTRYPOINT ["/bin/bash"]