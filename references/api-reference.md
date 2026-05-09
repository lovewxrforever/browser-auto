# Playwright API Quick Reference

## Browser

```javascript
const { chromium, firefox, webkit } = require('playwright');

// Launch Edge (default)
const browser = await chromium.launch({ channel: 'msedge' });

// Launch with visible window
const browser = await chromium.launch({ channel: 'msedge', headless: false });

// Launch with specific Edge path
const browser = await chromium.launch({
  channel: 'msedge',
  executablePath: 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe'
});

// Create context (like incognito)
const context = await browser.newContext();

// Create page
const page = await browser.newPage();
// or
const page = await context.newPage();
```

## Navigation

| Method | Description |
|--------|-------------|
| `page.goto(url)` | Navigate to URL |
| `page.goBack()` | Go back |
| `page.goForward()` | Go forward |
| `page.reload()` | Reload page |
| `page.waitForURL(pattern)` | Wait for URL to match |
| `page.waitForLoadState('networkidle')` | Wait for network idle |

## Locators

```javascript
page.getByRole('button', { name: 'text' })
page.getByLabel('label text')
page.getByPlaceholder('placeholder text')
page.getByText('text content')
page.getByAltText('alt text')
page.getByTitle('title text')
page.getByTestId('test-id')
```

## Actions

| Action | Code |
|--------|------|
| Click | `element.click()` |
| Double click | `element.dblclick()` |
| Right click | `element.click({ button: 'right' })` |
| Fill input | `element.fill('text')` |
| Type (slow) | `element.type('text', { delay: 50 })` |
| Clear | `element.fill('')` |
| Select option | `page.selectOption('#select', 'value')` |
| Check | `element.check()` |
| Uncheck | `element.uncheck()` |
| Hover | `element.hover()` |
| Focus | `element.focus()` |
| Press key | `page.keyboard.press('Enter')` |
| Scroll | `page.evaluate(() => window.scrollTo(0, 500))` |

## Assertions

```javascript
await expect(page).toHaveTitle(/title/);
await expect(page).toHaveURL(/pattern/);
await expect(element).toBeVisible();
await expect(element).toBeHidden();
await expect(element).toHaveText('text');
await expect(element).toHaveValue('value');
await expect(element).toHaveCount(3);
await expect(element).toBeChecked();
```

## Screenshots

```javascript
await page.screenshot({ path: 'page.png' });                     // Viewport
await page.screenshot({ path: 'full.png', fullPage: true });     // Full page
await element.screenshot({ path: 'element.png' });                // Element only
```

## Waiting

| Method | Best for |
|--------|----------|
| `waitForSelector()` | Element appears in DOM |
| `waitForURL()` | Page navigation completes |
| `waitForResponse()` | API call finishes |
| `waitForLoadState()` | Page resources loaded |
| `waitForTimeout()` | Last resort only |

## Page Info

```javascript
await page.title();
page.url();
await page.content();
await page.evaluate(() => document.title);
await page.evaluate(() => window.scrollY);
```

## Window

```javascript
await page.setViewportSize({ width: 1920, height: 1080 });
await page.emulateMedia({ reducedMotion: 'reduce' });
const size = page.viewportSize();
```
