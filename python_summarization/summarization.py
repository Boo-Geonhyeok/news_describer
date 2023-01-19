from summarizer import Summarizer
import sys

body = sys.argv[1]
model = Summarizer()
result = model(body, min_length=60)
full = ''.join(result)
print(full)
