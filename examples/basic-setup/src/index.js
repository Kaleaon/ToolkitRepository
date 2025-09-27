#!/usr/bin/env node

/**
 * Example application demonstrating ToolkitRepository usage
 * This file contains intentional issues for PROVV to detect
 */

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const compression = require('compression');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(morgan('combined'));
app.use(express.json());

// Example function with potential issues for PROVV to detect
function calculateAverage(numbers) {
    // Potential division by zero issue
    const sum = numbers.reduce((acc, num) => acc + num, 0);
    return sum / numbers.length; // PROVV should detect this
}

function getUserName(user) {
    // Potential null pointer dereference
    return user.name.toUpperCase(); // PROVV should detect this
}

function processData(data) {
    let result = null;
    
    if (data && data.length > 0) {
        result = data.map(item => {
            // Potential undefined access
            return {
                id: item.id,
                value: item.value.toString(), // Could be undefined
                processed: true
            };
        });
    }
    
    return result;
}

// API Routes
app.get('/', (req, res) => {
    res.json({
        message: 'ToolkitRepository Example API',
        version: '1.0.0',
        endpoints: [
            'GET /',
            'GET /health',
            'POST /calculate',
            'POST /process'
        ]
    });
});

app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

app.post('/calculate', (req, res) => {
    try {
        const { numbers } = req.body;
        
        if (!numbers || !Array.isArray(numbers)) {
            return res.status(400).json({
                error: 'Numbers array is required'
            });
        }
        
        const average = calculateAverage(numbers);
        
        res.json({
            numbers,
            average,
            count: numbers.length
        });
    } catch (error) {
        res.status(500).json({
            error: 'Calculation failed',
            message: error.message
        });
    }
});

app.post('/process', (req, res) => {
    try {
        const { data } = req.body;
        const result = processData(data);
        
        res.json({
            success: true,
            processed: result?.length || 0,
            result
        });
    } catch (error) {
        res.status(500).json({
            error: 'Processing failed',
            message: error.message
        });
    }
});

app.post('/user', (req, res) => {
    try {
        const { user } = req.body;
        const userName = getUserName(user);
        
        res.json({
            originalUser: user,
            userName
        });
    } catch (error) {
        res.status(500).json({
            error: 'User processing failed',
            message: error.message
        });
    }
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({
        error: 'Internal server error',
        message: err.message
    });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        error: 'Not found',
        path: req.path
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Health check: http://localhost:${PORT}/health`);
});

module.exports = app;