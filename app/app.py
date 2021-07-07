from flask import Flask, render_template
from airtable import airtable
from collections import Counter
from dotenv import dotenv_values

config = dotenv_values(".env")

app = Flask(__name__)

def get_member_applications():
    at = airtable.Airtable(config["BASE_ID"], config["API_KEY"])
    r = at.get('Member Applications Stage 1', fields=['Name of organization', "Status"], filter_by_formula="IS_AFTER({Date of application}, '1/1/2021')")
    records = r['records']
    statuses = [record['fields']['Status'] for record in records]
    status_counts = Counter(statuses)
    return status_counts

def get_fellow_applications():
    at = airtable.Airtable(config["BASE_ID"], config["API_KEY"])
    r = at.get('Fellow Applications', fields=['Name', "Status"], filter_by_formula="IS_AFTER({Created}, '1/1/2021')")
    records = r['records']
    statuses = [record['fields']['Status'] for record in records]
    status_counts = Counter(statuses)
    return status_counts


@app.route("/")
def index():
    return render_template("metrics.html")
