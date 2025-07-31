#!/usr/bin/env python3
"""
Robot Framework variable file for environment variables.
"""

import os
from dotenv import load_dotenv

# Load .env file if it exists
if os.path.exists('.env'):
    load_dotenv()

# Robot Framework variables
# Sensitive data should be set via environment variables or .env file
BASE_URL = os.getenv('BASE_URL', '')  # Set via .env file or environment variable
USERNAME = os.getenv('USERNAME', '')  # Set via .env file or environment variable
PASSWORD = os.getenv('PASSWORD', '')  # Set via .env file or environment variable
EMPTY_PASSWORD = ''
AUTH_TOKEN = '' 