import os
import yaml
import json
from jinja2 import Environment, FileSystemLoader

# print(os.getcwd())

with open('aws/conf/data.yml') as data_yaml:
    data_dict = yaml.safe_load(data_yaml)

env = Environment(loader=FileSystemLoader('aws/conf'))
data_template = 'data.json.tmpl'
env_template = env.get_template(data_template)
data_json = env_template.render(data=data_dict)

data_json_file = 'aws/conf/data.json'
with open(data_json_file, 'w') as file:
    file.write(data_json)
