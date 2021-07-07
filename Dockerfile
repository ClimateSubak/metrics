FROM python:3.6

ENV FLASK_APP app/app.py

COPY gunicorn-cfg.py requirements.txt ./

COPY app app

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["gunicorn", "--config", "gunicorn-cfg.py", "app.app:app"]