#!/usr/bin/env node
/**
 * browser-auto — Initialize a new automation project
 *
 * Usage:
 *   node init-project.js <project-name>
 *
 * Creates:
 *   <project-name>/
 *     package.json
 *     output/          (all screenshots go here)
 *     automate.js      (ready-to-run script)
 */
const path = require('path');
const fs = require('fs');

const projectName = process.argv[2];
if (!projectName) {
  console.error('Usage: node init-project.js <project-name>');
  process.exit(1);
}

const dir = path.resolve(projectName);
if (fs.existsSync(dir)) {
  console.error(`Error: "${dir}" already exists`);
  process.exit(1);
}

fs.mkdirSync(path.join(dir, 'output'), { recursive: true });

// package.json
const pkg = {
  name: projectName,
  version: '1.0.0',
  private: true,
  scripts: {
    start: 'node automate.js',
    debug: 'node automate.js --headed',
  },
};
fs.writeFileSync(path.join(dir, 'package.json'), JSON.stringify(pkg, null, 2));

// automate.js (template)
const template = `const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

const OUTPUT_DIR = path.join(__dirname, 'output');
fs.mkdirSync(OUTPUT_DIR, { recursive: true });
const HEADED = process.argv.includes('--headed');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: !HEADED,
  });
  try {
    const page = await browser.newPage({ viewport: { width: 1280, height: 720 } });

    // ---- Your automation starts here ----
    await page.goto('https://example.com');
    console.log('Title:', await page.title());
    await page.screenshot({ path: path.join(OUTPUT_DIR, 'page.png') });
    // ---- Your automation ends here ----

    console.log(\`Done! Output in \${OUTPUT_DIR}/\`);
  } catch (err) {
    console.error('Error:', err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
`;
fs.writeFileSync(path.join(dir, 'automate.js'), template);

console.log(`\nCreated project: ${dir}`);
console.log('\nNext steps:');
console.log(`  cd ${projectName}`);
console.log('  npm install playwright');
console.log('  npm start');
