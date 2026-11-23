""" Load settings from .env file in the project root directory. """

import os
from pathlib import Path
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")

# Paths (relative to project root)
data_dir = os.getenv("DATA_DIR")
output_dir = os.getenv("OUTPUT_DIR")
if not data_dir or not output_dir:
    raise RuntimeError("DATA_DIR and OUTPUT_DIR must be set in .env file in the project root directory.")

DATA_DIR = BASE_DIR / data_dir
OUTPUT_DIR = BASE_DIR / output_dir

# APIs
EXCHANGE_API_URL = os.getenv("EXCHANGE_API_URL", "https://v6.exchangerate-api.com/v6")
EXCHANGE_API_KEY = os.getenv("EXCHANGE_API_KEY")
GITHUB_API_URL = os.getenv("GITHUB_API_URL", "https://api.github.com")
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")