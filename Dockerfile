FROM python:2
WORKDIR /app

COPY requirements.txt . 
RUN apt-get -qq update \
&& DEBIAN_FRONTEND=noninteractive apt-get -y install \
libmapnik2-dev mapnik-utils libboost-python-dev \
&& apt-get clean
RUN pip install --no-cache-dir -r requirements.txt

COPY setup.py .
COPY ogcserver ./ogcserver
COPY bin ./bin
COPY bin/ogcserver-regular /usr/local/bin/
COPY bin/ogcserver-retina /usr/local/bin/
RUN python setup.py install

VOLUME /data /conf
EXPOSE 80
ENV conf "/conf/ogcserver-osm.conf"
ENV mapfile "/data/osm-crisp/osm-mapnik.xml"
ENTRYPOINT [ "ogcserver", "-b", "0.0.0.0", "-p", "80", "-c", "$conf", "$mapfile" ]

