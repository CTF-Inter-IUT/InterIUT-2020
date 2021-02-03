FROM registry.alfred.cafe/interiut/interiut-base-python

COPY app /challenge
COPY flag /
RUN chmod -R 555 /challenge && chmod 555 /flag

RUN pip3 install -r requirements.txt

EXPOSE 80

CMD ["python3", "app.py"]
