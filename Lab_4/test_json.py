import json
import jsonschema
from pprint import pprint


VALIDATION_SCHEMA_FILE = "information_schema.json"
SCHEMA_TEST_FILE = "schema_test.json"


def load_json(file_name):
    with open(file_name) as f:
        return json.load(f)


def validateJson(data, schema):
    try:
        jsonschema.validate(instance=data, schema=schema)
    except jsonschema.exceptions.ValidationError as err:
        print(err)
        return False
    return True

if __name__ == '__main__':
    schema = load_json(VALIDATION_SCHEMA_FILE)
    data = load_json(SCHEMA_TEST_FILE)
    print(validateJson(data, schema))