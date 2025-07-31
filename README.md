# Robot Framework Test Suite

This repository contains Robot Framework tests for API testing.

## Setup

### Local Development

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Create `.env` file** (not committed to repository):
   ```bash
   # Copy this template and fill in your values
   BASE_URL=your-base-url
   USERNAME=your-test-username@example.com
   PASSWORD=your-encrypted-password
   WRONG_PASSWORD=your-wrong-encrypted-password
   NON_EXISTING_USERNAME=nonexistent@example.com
   ```

3. **Activate virtual environment:**
   ```bash
   source robot_env/bin/activate
   ```

4. **Run tests:**
   ```bash
   robot --outputdir . TEST/
   ```

### GitHub Actions

The workflow uses GitHub Secrets for sensitive data. Add these secrets in your repository:

- `BASE_URL`: API base URL (sensitive - contains endpoint)
- `USERNAME`: Test username
- `PASSWORD`: Encrypted test password
- `WRONG_PASSWORD`: Wrong encrypted password
- `NON_EXISTING_USERNAME`: Non-existing username

## Security Notes

- `.env` file is excluded from git via `.gitignore`
- Sensitive data is stored as GitHub Secrets
- Environment variables are used instead of hardcoded values
- Test outputs are uploaded as artifacts in CI/CD

## File Structure

```
├── TEST/
│   └── login.robot          # Login test cases
├── RESOURCES/
│   └── COMMON.robot        # Common keywords and variables
├── .github/workflows/
│   └── robot-tests.yml     # GitHub Actions workflow
├── .env                    # Local environment variables (not committed)
├── .gitignore             # Excludes sensitive files
├── variables.py            # Robot Framework variable file
├── requirements.txt       # Python dependencies
└── README.md             # This file
``` 