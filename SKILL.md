---
name: browser-auto
activation: /browser-auto
description: >-
  Browser automation with Microsoft Edge — click buttons, fill forms, take screenshots, navigate pages,
  extract data. All output files saved to a project-level output/ directory, never the desktop.
  Uses Playwright with channel:msedge for Edge browser automation on Windows 11.
license: MIT
provenance:
  maintainer: Claude Code
  source: https://github.com/microsoft/playwright
  version: 1.0.0
  created: 2026-05-10
metadata:
  review_interval_days: 90
  platforms:
    - claude-code
    - cursor
    - copilot
---

# /browser-auto — Browser Automation with Microsoft Edge

You are an expert in Playwright browser automation. Your job is to help users automate web browsers using Microsoft Edge — click buttons, fill and submit forms, take screenshots, navigate pages, extract data, and verify page content.

## Trigger

User invokes `/browser-auto` followed by their request:

```
/browser-auto 打开百度搜索"天气"并截图
/browser-auto 帮我自动登录这个网站
/browser-auto 抓取这个页面的所有链接
/browser-auto 填写这个表单并提交截图
/browser-auto 帮我写一个自动化脚本，定时检查网站状态
```

## Core Rules

### 1. Always Create a Project Directory

Never write scripts or save screenshots to the Desktop or home directory. Create a dedicated project:

```bash
# Windows
mkdir -p $env:USERPROFILE\browser-auto-jobs\<task-name>
cd $env:USERPROFILE\browser-auto-jobs\<task-name>
npm init -y
npm install playwright
```

### 2. Output Directory

Every script must define an `OUTPUT_DIR` at the top. All screenshots, downloads, and generated files go here:

```javascript
const path = require('path');
const fs = require('fs');
const OUTPUT_DIR = path.join(__dirname, 'output');
fs.mkdirSync(OUTPUT_DIR, { recursive: true });
```

### 3. Use Microsoft Edge

```javascript
const { chromium } = require('playwright');

const browser = await chromium.launch({
  channel: 'msedge',  // REQUIRED: use Edge instead of Chrome

  // Default: headless (no visible window)
  // Debugging: headless: false
});
```

The `channel: 'msedge'` flag tells Playwright to launch the system-installed Microsoft Edge instead of Chromium.

### 4. Error Handling

All scripts MUST use try/catch/finally to ensure the browser always closes:

```javascript
const browser = await chromium.launch({ channel: 'msedge' });
try {
  const page = await browser.newPage();
  // ... automation logic ...
} catch (err) {
  console.error('Error:', err.message);
  process.exit(1);
} finally {
  await browser.close();
}
```

### 5. Prefer Locator API Over Raw Selectors

Use Playwright's recommended locator strategies:

```javascript
// ✅ RECOMMENDED
page.getByRole('button', { name: 'Login' }).click();
page.getByPlaceholder('Username').fill('admin');
page.getByText('Submit').click();
page.getByTestId('submit-btn').click();
page.getByLabel('Email').fill('user@example.com');
page.getByTitle('Close').click();

// ⚠️ Acceptable when locators don't work
page.locator('.search-box').fill('query');
page.locator('#submit-btn').click();

// ❌ Avoid raw CSS selectors when locator API works
```

### 6. Windows Keyboard Keys

```javascript
// Windows key names
await page.keyboard.press('Control+a');     // Select all
await page.keyboard.press('Control+c');     // Copy
await page.keyboard.press('Control+v');     // Paste
await page.keyboard.press('Control+Shift+i'); // DevTools
await page.keyboard.press('Enter');
await page.keyboard.press('Escape');
await page.keyboard.press('Tab');
await page.keyboard.press('ArrowDown');
await page.keyboard.press('ArrowUp');
await page.keyboard.press('Delete');
await page.keyboard.press('Backspace');
```

### 7. Wait Strategies

```javascript
// ✅ RECOMMENDED (specific, reliable)
await page.waitForSelector('.result');           // Wait for element
await page.waitForURL('**/dashboard');            // Wait for navigation
await page.waitForResponse('**/api/data');        // Wait for API
await page.waitForLoadState('networkidle');       // Wait for network idle

// ⚠️ Use sparingly (fragile, slow)
await page.waitForTimeout(2000);
```

## Common Operations

### Navigate to a page
```javascript
await page.goto('https://example.com', { waitUntil: 'networkidle' });
```

### Click an element
```javascript
await page.getByText('Login').click();
```

### Type into an input
```javascript
await page.getByPlaceholder('Search').fill('query text');
```

### Take a screenshot
```javascript
await page.screenshot({ path: path.join(OUTPUT_DIR, 'page.png') });
await page.screenshot({ path: path.join(OUTPUT_DIR, 'full.png'), fullPage: true });
```

### Select from dropdown
```javascript
await page.selectOption('#country', 'china');
```

### Check a checkbox / radio
```javascript
await page.check('#agree');
```

### Get page info
```javascript
await page.title();
page.url();
await page.content();
await page.evaluate(() => document.title);
```

### Wait and assert
```javascript
await expect(page.locator('h1')).toContainText('Welcome');
```

### Handle dialogs
```javascript
page.on('dialog', dialog => dialog.accept());
```

## Script Template

Use this template for all automation tasks:

```javascript
const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

const OUTPUT_DIR = path.join(__dirname, 'output');
fs.mkdirSync(OUTPUT_DIR, { recursive: true });

(async () => {
  const browser = await chromium.launch({ channel: 'msedge' });
  try {
    const page = await browser.newPage({ viewport: { width: 1280, height: 720 } });
    // User automation logic here
    await browser.close();
  } catch (err) {
    console.error('Error:', err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
```

## References

- `references/setup-guide.md` — Full setup and installation
- `references/api-reference.md` — Complete Playwright API quick reference
- `assets/playwright.config.template.js` — Test runner config template
