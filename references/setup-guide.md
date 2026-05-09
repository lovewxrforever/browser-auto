# Setup Guide

## Prerequisites

- Windows 11
- Microsoft Edge (system-installed)
- Node.js 18+
- npm

## Installation

### 1. Install Playwright

```bash
# Create a project directory
mkdir my-automation && cd my-automation
npm init -y
npm install playwright
```

### 2. Verify Edge

```bash
node -e "const { chromium } = require('playwright'); (async () => { const b = await chromium.launch({channel:'msedge'}); const p = await b.newPage(); console.log('Edge OK:', await p.evaluate(() => navigator.userAgent.includes('Edg'))); await b.close(); })()"
```

Should print: `Edge OK: true`

## Usage

```bash
# Run an automation script
node my-script.js

# Run with visible browser (debugging)
node my-script.js --headed

# Specify custom output directory
node my-script.js C:\reports\screenshots
```

## Common Issues

| Problem | Solution |
|---------|----------|
| `channel: msedge` not found | Install Edge or set `executablePath` |
| Browser doesn't close | Script missing `finally { await browser.close() }` |
| Element not found | Add `await page.waitForSelector()` before interacting |
| Timeout on navigation | Use `{ waitUntil: 'domcontentloaded' }` instead of `networkidle` |
| Screenshots are blank | Page might need `await page.waitForTimeout(1000)` after load |
