#!/bin/bash

# Check if the tempdir exists, if not, create it along with its subdirectories
mkdir -p tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Copy the necessary files into the tempdir
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Create or overwrite the Dockerfile in tempdir
cat <<EOF > tempdir/Dockerfile
FROM python
RUN pip install --upgrade pip
RUN pip install flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python", "/home/myapp/sample_app.py"]
EOF

# Navigate into tempdir and build the Docker image
cd tempdir
docker build -t sampleapp .

# Run the Docker container
docker run -t -d -p 5050:5050 --name samplerunning sampleapp

# List the running containers
docker ps -a
