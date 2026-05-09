# browser-auto

Claude Code skill for browser automation with Microsoft Edge.

## Installation

### Claude Code

```bash
git clone https://github.com/your-org/browser-auto.git ~/.claude/skills/browser-auto
```

Or copy the `browser-auto` folder to `~/.claude/skills/`.

### VS Code Copilot

```bash
git clone https://github.com/your-org/browser-auto.git .github/skills/browser-auto
```

### Cursor

```bash
git clone https://github.com/your-org/browser-auto.git .cursor/rules/browser-auto
```

## Usage

In Claude Code, type:

```
/browser-auto 打开百度搜索"天气"并截图
/browser-auto 帮我写一个自动登录脚本
/browser-auto 抓取这个页面的所有链接
```

Every automation script creates an `output/` directory for screenshots and results.

## Requirements

- Windows 11
- Microsoft Edge (system-installed)
- Node.js 18+
- Playwright (`npm install playwright` in your project)

## What It Does

- Click buttons, fill forms, navigate pages
- Take screenshots (viewport, full-page, element)
- Extract page data and metadata
- Handle dialogs, file downloads, network requests
- All output in project-level `output/` directory — never the desktop
