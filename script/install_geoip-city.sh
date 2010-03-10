#!/bin/sh

# NOTE: Note sure if ARCHFLAGS needs to be set on all these places, but this works.

# Install GeoIP C API
echo "Installing dependency GeoIP C API..."
cd /tmp
curl -O http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz
tar -zxvf GeoIP*.tar.gz
cd GeoIP*
sudo env ARCHFLAGS="-arch i386" ./configure --prefix=/opt/GeoIP
sudo env ARCHFLAGS="-arch i386" make
sudo env ARCHFLAGS="-arch i386" make install

# Get the GeoLiteCity database
echo "Installing GeoLiteCity database..."
cd /tmp
curl -O http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
sudo tar -zxvf GeoLiteCity.dat.gz --directory=/opt/GeoIP/share/GeoIP/

# Install gem geoip-city
echo "Installing gem geoip-city..."
sudo env ARCHFLAGS="-arch i386" gem install geoip_city -- --with-geoip-dir=/opt/GeoIP

echo "Installation complete."
