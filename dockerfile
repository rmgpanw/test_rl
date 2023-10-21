# Use the base image with the desired OS
FROM debian:stable

# Set the mirror URL for Debian
RUN sed -i 's|http://deb.debian.org/debian/|http://ftp.us.debian.org/debian/|g' /etc/apt/sources.list.d/debian.sources

# Install necessary packages
RUN apt-get update && apt-get -y install r-base wget vim libfontconfig1-dev libssl-dev libxml2-dev libharfbuzz-dev libfribidi-dev libcurl4-openssl-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libmagick++-dev

# Install R packages
RUN Rscript -e 'install.packages("R.utils", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("tidyverse", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("haven", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("stringr", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("readr", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("glue", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("glue", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("janitor", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("future", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("future.batchtools", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("listenv", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("fs", repos="https://cloud.r-project.org")'
RUN Rscript -e 'install.packages("summarytools", repos="https://cloud.r-project.org")'

# Download and install PLINK
RUN wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip
RUN unzip plink_linux_x86_64_20230116.zip
RUN cp plink /usr/local/bin

# Download and install PLINK 2
RUN wget https://s3.amazonaws.com/plink2-assets/plink2_linux_avx2_20231018.zip
RUN unzip plink2_linux_avx2_20231018.zip 
RUN cp plink2 /usr/local/bin

# Download and install Regenie
RUN wget https://github.com/rgcgithub/regenie/releases/download/v3.2.7/regenie_v3.2.7.gz_x86_64_Linux_mkl.zip
RUN unzip regenie_v3.2.7.gz_x86_64_Linux_mkl.zip
RUN cp regenie_v3.2.7.gz_x86_64_Linux_mkl /usr/local/bin/regenie
RUN cp regenie_v3.2.7.gz_x86_64_Linux_mkl /usr/local/bin/

# Set environment variables
ENV LC_ALL=C
ENV PATH=/usr/games:$PATH
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

# Copy the RegeniePipeline into the image and make executable (dummy program for now)
COPY ./capitalise /usr/local/bin/capitalise
RUN chmod +x /usr/local/bin/capitalise

# Define the run script
ENTRYPOINT ["/usr/local/bin/capitalise"]
CMD ["$@"]
