import json
import sys

text = sys.stdin.read()
obj = json.loads(text)

print("\n".join(obj.keys()))
