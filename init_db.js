require('dotenv').config();
const mysql = require('mysql2/promise');
const fs = require('fs');

async function initDB() {
    try {
        const connection = await mysql.createConnection({
            host: process.env.DB_HOST || 'localhost',
            port: parseInt(process.env.DB_PORT) || 3306,
            user: process.env.DB_USER || 'root',
            password: process.env.DB_PASSWORD || '',
            ssl: (process.env.DB_SSL === 'true' || (process.env.DB_HOST && !['localhost', '127.0.0.1'].includes(process.env.DB_HOST) && process.env.DB_HOST.includes('tidbcloud.com'))) ? {
                minVersion: 'TLSv1.2',
                rejectUnauthorized: true
            } : null,
            multipleStatements: true
        });

        console.log("Connected to MySQL server.");
        
        const schema = fs.readFileSync('./schema.sql', 'utf8');
        
        await connection.query(schema);
        console.log("Database initialized successfully!");
        
        await connection.end();
    } catch (err) {
        console.error("Error initializing DB:", err.message);
    }
}

initDB();
