FROM node:20-alpine

WORKDIR /app

# Copy package manifest files
COPY package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy application code
COPY index.js db.js init_db.js seed_admin_table.js schema.sql ./
COPY routes/ ./routes/
COPY middleware/ ./middleware/
COPY utils/ ./utils/
COPY client/dist/ ./client/dist/

# Expose the application port
EXPOSE 5000

# Set production environment
ENV NODE_ENV=production
ENV PORT=5000

# Run database initialization and seeding, then start the server
CMD node init_db.js && node seed_admin_table.js && node index.js
