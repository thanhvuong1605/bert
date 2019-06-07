FROM tensorflow/tensorflow:1.12.0-py3

RUN apt-get update --fix-missing && apt-get install -y wget unzip

# supervisor installation &&
# create directory for child images to store configuration in
RUN apt-get -y install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

RUN wget https://storage.googleapis.com/bert_models/2018_11_23/multi_cased_L-12_H-768_A-12.zip
RUN unzip multi_cased_L-12_H-768_A-12.zip -d /app
RUN rm multi_cased_L-12_H-768_A-12.zip

COPY ./requirements.txt /app/requirements.txt
COPY . /app
WORKDIR /app
EXPOSE 5555
EXPOSE 5556
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf
# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
#CMD bert-serving-start -model_dir /app/multi_cased_L-12_H-768_A-12/ -num_worker=1


