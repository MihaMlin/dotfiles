# PostgreSQL with Docker Compose

## Quick Start

### Docker Compose Setup

Create a `docker-compose.yml` file:

```yaml
services:
  db:
    image: postgres:15-alpine
    container_name: postgres_container
    restart: always
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydatabase
    ports:
      - "5432:5432"
    networks:
      - postgres_network
    volumes:
      - postgres_db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser -d mydatabase"]
      interval: 10s
      timeout: 5s
      retries: 5

  pgAdmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin_container
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "8080:80"
    networks:
      - postgres_network
    depends_on:
      db:
        condition: service_healthy

networks:
  postgres_network:
    driver: bridge

volumes:
  postgres_db_data:
    driver: local
```

### Start the Services

```bash
# Start in detached mode
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Stop and remove volumes (deletes all data)
docker compose down -v
```

## Connecting to PostgreSQL

### Using pgAdmin4

1. Open pgAdmin4 in your browser: `http://localhost:8080`

2. Login with credentials:
   - **Email:** `admin@admin.com`
   - **Password:** `admin`

3. Register a new server:
   - Right-click **Servers** → **Register** → **Server...**

4. In the **General** tab:
   - **Name:** `Local PostgreSQL` (or any name you prefer)

5. In the **Connection** tab:
   - **Host name/address:** `db` (container name, not localhost!)
   - **Port:** `5432`
   - **Maintenance database:** `mydatabase`
   - **Username:** `myuser`
   - **Password:** `mypassword`
   - Check **Save password** if desired

6. Click **Save** to connect

### Using psql (CLI)

```bash
# Connect from host machine
psql -h localhost -p 5432 -U myuser -d mydatabase

# Connect from inside the container
docker exec -it postgres_container psql -U myuser
```

## Basic pgAdmin4 Usage

### Creating a Database

1. Expand **Servers** → **Local PostgreSQL** → **Databases**
2. Right-click **Databases** → **Create** → **Database...**
3. Enter a name and click **Save**

### Creating a Table

1. Expand your database → **Schemas** → **public** → **Tables**
2. Right-click **Tables** → **Create** → **Table...**
3. Configure columns in the **Columns** tab
4. Click **Save**

### Running SQL Queries

1. Right-click on a database → **Query Tool**
2. Write your SQL in the editor
3. Press **F5** or click the **Execute** button (▶)

### Viewing Table Data

1. Navigate to your table under **Tables**
2. Right-click → **View/Edit Data** → **All Rows**

### Importing/Exporting Data

1. Right-click on a table → **Import/Export Data...**
2. Choose import or export mode
3. Select file format (CSV, JSON, etc.)
4. Configure options and execute

## Environment Variables Reference

### PostgreSQL

| Variable            | Description                     | Default                    |
| ------------------- | ------------------------------- | -------------------------- |
| `   `               | Superuser username              | `postgres`                 |
| `POSTGRES_PASSWORD` | Superuser password              | -                          |
| `POSTGRES_DB`       | Default database name           | `postgres`                 |
| `PGDATA`            | Data directory inside container | `/var/lib/postgresql/data` |

### pgAdmin4

| Variable                   | Description              | Default |
| -------------------------- | ------------------------ | ------- |
| `PGADMIN_DEFAULT_EMAIL`    | Login email              | -       |
| `PGADMIN_DEFAULT_PASSWORD` | Login password           | -       |
| `PGADMIN_LISTEN_PORT`      | Internal port            | `80`    |
| `PGADMIN_CURRENT_USER`     | View current user        | -       |
| `PGADMIN_INSERT`           | Insert data into a table | -       |
| `PGADMIN_REMOVE`           | Remove data from a table | -       |
| `PGADMIN_DROP`             | Drop a table             | -       |
| `PGADMIN_UPDATE`           | Update existing data     | -       |
| `PGADMIN_JOIN`             | Join tables in a query   | -       |

## PgAdmin4 CheatSheet

| Action                     | Steps                                                                            |
| -------------------------- | -------------------------------------------------------------------------------- |
| **Login**                  | Open `http://localhost:8080` → Enter email & password                            |
| **Register Server**        | Right-click **Servers** → **Register** → **Server...** → Fill connection details |
| **Create Database**        | Right-click **Databases** → **Create** → **Database...**                         |
| **Create Table**           | Right-click **Tables** → **Create** → **Table...** → Configure columns           |
| **Run Query**              | Right-click database → **Query Tool** → Write SQL → **F5** or click ▶            |
| **View Table Data**        | Right-click table → **View/Edit Data** → **All Rows**                            |
| **Edit Data**              | Right-click table → **View/Edit Data** → **All Rows** → Click cells to edit      |
| **Import Data**            | Right-click table → **Import/Export Data...** → Select file (CSV, JSON)          |
| **Export Data**            | Right-click table → **Import/Export Data...** → Choose export format             |
| **Drop Table**             | Right-click table → **Delete/Drop**                                              |
| **Refresh**                | Press **F5** or click refresh icon                                               |
| **View Server Properties** | Right-click server → **Properties**                                              |
| **Disconnect Server**      | Right-click server → **Disconnect**                                              |
| **Create Schema**          | Right-click **Schemas** → **Create** → **Schema...**                             |
| **View Logs**              | Tools → **Server Log**                                                           |

## SQL Queries CheatSheet

### Database & Session Info

```sql
-- Current user
SELECT current_user;

-- Current database
SELECT current_database();

-- Current schema
SELECT current_schema();

-- PostgreSQL version
SELECT version();

-- List all databases
SELECT datname FROM pg_database WHERE datistemplate = false;

-- List all schemas
SELECT schema_name FROM information_schema.schemata;
```

### Tables & Structure

```sql
-- List all tables in current schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- List all tables with row counts
SELECT schemaname, relname, n_live_tup
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- Describe table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'your_table';

-- Show table size
SELECT pg_size_pretty(pg_total_relation_size('your_table'));
```

### Create & Drop

```sql
-- Create table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table with foreign key
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    total DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Drop table
DROP TABLE your_table;

-- Drop table if exists
DROP TABLE IF EXISTS your_table;

-- Drop table with dependencies
DROP TABLE your_table CASCADE;
```

### Insert Data

```sql
-- Insert single row
INSERT INTO users (name, email)
VALUES ('John Doe', 'john@example.com');

-- Insert multiple rows
INSERT INTO users (name, email) VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com'),
    ('Charlie', 'charlie@example.com');

-- Insert with returning
INSERT INTO users (name, email)
VALUES ('Jane', 'jane@example.com')
RETURNING id, name;
```

### Update Data

```sql
-- Update single column
UPDATE users SET name = 'John Smith' WHERE id = 1;

-- Update multiple columns
UPDATE users
SET name = 'John Smith', email = 'johnsmith@example.com'
WHERE id = 1;

-- Update with subquery
UPDATE orders
SET total = total * 1.1
WHERE user_id IN (SELECT id FROM users WHERE name LIKE 'J%');
```

### Delete Data

```sql
-- Delete specific rows
DELETE FROM users WHERE id = 1;

-- Delete with condition
DELETE FROM users WHERE created_at < '2024-01-01';

-- Delete all rows (keeps table structure)
DELETE FROM users;

-- Truncate (faster for deleting all rows)
TRUNCATE TABLE users;

-- Truncate with restart identity
TRUNCATE TABLE users RESTART IDENTITY CASCADE;
```

### Select & Query

```sql
-- Select all
SELECT * FROM users;

-- Select specific columns
SELECT name, email FROM users;

-- Select with condition
SELECT * FROM users WHERE name LIKE 'J%';

-- Select with ordering
SELECT * FROM users ORDER BY created_at DESC;

-- Select with limit
SELECT * FROM users LIMIT 10 OFFSET 20;

-- Select distinct
SELECT DISTINCT name FROM users;

-- Count rows
SELECT COUNT(*) FROM users;

-- Group by with aggregation
SELECT user_id, COUNT(*), SUM(total)
FROM orders
GROUP BY user_id;
```

### Joins

```sql
-- Inner join
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- Left join
SELECT u.name, o.total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- Right join
SELECT u.name, o.total
FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;

-- Full outer join
SELECT u.name, o.total
FROM users u
FULL OUTER JOIN orders o ON u.id = o.user_id;
```

### Alter Table

```sql
-- Add column
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Drop column
ALTER TABLE users DROP COLUMN phone;

-- Rename column
ALTER TABLE users RENAME COLUMN name TO full_name;

-- Change column type
ALTER TABLE users ALTER COLUMN name TYPE TEXT;

-- Add constraint
ALTER TABLE users ADD CONSTRAINT email_unique UNIQUE (email);

-- Drop constraint
ALTER TABLE users DROP CONSTRAINT email_unique;

-- Rename table
ALTER TABLE users RENAME TO customers;
```

### Indexes

```sql
-- Create index
CREATE INDEX idx_users_email ON users(email);

-- Create unique index
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Drop index
DROP INDEX idx_users_email;

-- List indexes on a table
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'users';
```
