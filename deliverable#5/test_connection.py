from dotenv import load_dotenv
load_dotenv()

import os
print("HOST=", os.getenv("DB_HOST"))
print("USER=", os.getenv("DB_USERNAME"))
