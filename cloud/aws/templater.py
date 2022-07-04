import yaml
import json
from jinja2 import Environment, FileSystemLoader

with open('conf/specs.yml') as specs_yaml:
    specs_dict = yaml.safe_load(specs_yaml)

env = Environment(loader=FileSystemLoader('./conf'))
specs_template = 'specs.json.tmpl'
env_template = env.get_template(specs_template)
specs_json_data = env_template.render(specs=specs_dict)

specs_json_file = 'conf/specs.json'
with open(specs_json_file, 'w') as file:
    file.write(specs_json_data)
