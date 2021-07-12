FROM python:3.8-buster
WORKDIR /app
ADD . /app
RUN pip3 install --upgrade pip
RUN pip3 install flask redis
EXPOSE 5000
CMD ["python3", "app.py"]
