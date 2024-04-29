from jinja2 import Template
import yaml

# Load Jinja template (replace with the actual path to your template)
with open('env.yml.j2') as file:
    template = Template(file.read())

# Context variables (replace with your actual variables)
context = {
    'prefix': 'raqo'
}

# Render the template
rendered_content = template.render(context)

# Save the rendered content to a new YAML file
with open('env.yml', 'w') as file:
    file.write(rendered_content)