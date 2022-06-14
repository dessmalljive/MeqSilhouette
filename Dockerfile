FROM kernsuite/base:7

RUN docker-apt-install apt-utils libboost-all-dev \
         locales locales-all \
         sudo time vim less wget git \
         python-bs4 \ 
         casalite python3-numpy python3-casacore \ 
         python3-pip \
         python3-seaborn \
			meqtrees \
         simms \
         wsclean \
         python3-seaborn \
         pyxis python3-pyxis
         
         
RUN pip install --upgrade pip
RUN pip install mpltools astLib
RUN pip install termcolor 

RUN mkdir /downloaded_files
RUN wget -P /downloaded_files http://www.mrao.cam.ac.uk/~bn204/soft/aatm-0.5.tar.gz
RUN tar xzf /downloaded_files/aatm-0.5.tar.gz --directory / && rm /downloaded_files/aatm-0.5.tar.gz
RUN cd /aatm-0.5 && ./configure && make && make install
ENV LD_LIBRARY_CONFIG=/usr/local/lib
RUN ldconfig

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# RUN apt update
# RUN apt install -y --download-only 
ARG BUID=1001
RUN useradd -l -m -s /bin/bash -N -u $BUID mequser
RUN usermod -aG sudo mequser
# RUN echo -e "meq\nmeq" | passwd mequser
RUN echo "mequser:meq" | chpasswd

ENV MEQTREES_CATTERY_PATH=/usr/lib/python3/dist-packages/Cattery
USER mequser
WORKDIR /home/mequser
RUN git clone https://github.com/dessmalljive/MeqSilhouette.git


ENV PYTHONPATH /home/mequser/MeqSilhouette
ENV MEQS_DIR /home/mequser/MeqSilhouette

RUN 2to3-2.7 -w MEQS_DIR/driver/run_meqsilhouette.py
RUN 2to3-2.7 -w framework/*py

RUN ln -sf $MEQTREES_CATTERY_PATH/Siamese/turbo-sim.py /home/mequser/MeqSilhouette/framework/turbo-sim.py


# And the following to your PYTHONPATH:
# - /path/to/MeqSilhouette/framework

RUN echo -e "\nexit" | casa 
RUN python3 -c "import matplotlib.pyplot"

CMD ["/bin/bash"] 


