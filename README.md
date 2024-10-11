# MysqlDumpInstaller

**MysqlDumpInstaller** is a batch script that lists SQL files from a specified directory and installs them into your MySQL database.

## Getting Started

Follow these steps to set up and run the application:

### Prerequisites

Ensure you have the following installed on your system:

- [MySQL](https://www.mysql.com/) server
- Windows operating system (for running the `run.bat` file)

### Configuration

Before executing the application, you need to set the environment variables in a `.env` file. Create a file named `.env` in the root directory of the project and add the following variables:

```env
# MySQL Database Configuration
DB_NAME=your_database_name      # Name of the database (can be empty)
MYSQL_HOST=your_mysql_host      # Host of the MySQL server (can be empty)
MYSQL_USER=your_mysql_user      # Username for the MySQL server (can be empty)
MYSQL_PASS=your_mysql_password   # Password for the MySQL server (can be empty)

# Directory to fetch SQL files
DOWNLOADS_DIR=path_to_your_sql_files_directory
