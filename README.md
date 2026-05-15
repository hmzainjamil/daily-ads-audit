# daily-ads-audit
Autonomous Google Ads + GA4 daily audit — 3 clients, XLSX + PDF + HTML output, zero manual steps

![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat&labelColor=555&logo=python)
![Google Ads](https://img.shields.io/badge/Google_Ads-API-4285F4?style=flat&labelColor=555)
![GA4](https://img.shields.io/badge/GA4-Analytics-orange?style=flat&labelColor=555)
![ReportLab](https://img.shields.io/badge/ReportLab-PDF-red?style=flat&labelColor=555)
![macOS](https://img.shields.io/badge/LaunchAgent-Scheduled-black?style=flat&labelColor=555)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=flat&labelColor=555)

[Concepts](#-concepts) · [How It Works](#️-how-it-works) · [Install](#-install) · [Output](#-output-format) · [Tips](#-tips-and-tricks-8) · [Startups](#️-startups--businesses)

---

## 🧠 CONCEPTS

| Feature | Location | Description |
|---------|----------|-------------|
| [**daily-ads-audit.py**](daily-ads-audit.py) | `daily-ads-audit.py` | 746-line audit engine — pulls Google Ads + GA4, generates 3-format reports |
| [**ads-audit-wake-check.sh**](ads-audit-wake-check.sh) | `ads-audit-wake-check.sh` | Wake guard — checks if Mac was asleep, reschedules missed audits |
| [**3-Client Support**](daily-ads-audit.py) | `CLIENT_CONFIGS` dict | DigiMinds, City Orthopedics, TackMedia — per-client brand palette |
| [**XLSX Output**](daily-ads-audit.py) | `~/Downloads/[Client]/` | Formatted Excel with KPI tables, CTR, CPC, ROAS per campaign |
| [**PDF Output**](daily-ads-audit.py) | `~/Downloads/[Client]/` | ReportLab 11-page branded PDF audit report |
| [**HTML Dashboard**](daily-ads-audit.py) | `~/Downloads/[Client]/` | Interactive HTML with Chart.js visualizations |

### 🔥 Hot

| Feature | Location | Description |
|---------|----------|-------------|
| [**Per-Client Brand Palette**](daily-ads-audit.py) | `brand_palette` | Each PDF uses client's actual brand colors — scraped from their URL |
| [**Wake Guard**](ads-audit-wake-check.sh) | `ads-audit-wake-check.sh` | Detects missed runs if Mac was asleep — auto-reruns on wake |
| [**Zero-Click Daily**](daily-ads-audit.py) | `LaunchAgent` | Fires at 8 AM daily via macOS LaunchAgent — no manual trigger |

---

## ⚙️ HOW IT WORKS

```
8:00 AM — LaunchAgent fires ads-audit-wake-check.sh
         ↓
Wake check passes → daily-ads-audit.py executes
         ↓
For each client (DigiMinds, CityOrtho, TackMedia):
  ├── Pull Google Ads API → campaigns, ad groups, keywords
  ├── Pull GA4 API → sessions, conversions, revenue
  ├── Calculate KPIs: CTR, CPC, ROAS, Quality Score
  ├── Generate XLSX → formatted workbook
  ├── Generate PDF → 11-page ReportLab branded report
  └── Generate HTML → Chart.js dashboard
         ↓
Output: ~/Downloads/[Client]/YYYY-MM-DD/HH-MM-SS/
```

---

## 🚀 INSTALL

```bash
git clone https://github.com/hmzainjamil/daily-ads-audit
cd daily-ads-audit
pip install google-ads google-analytics-data openpyxl reportlab
cp daily-ads-audit.py ads-audit-wake-check.sh ~/.claude/bin/
chmod +x ~/.claude/bin/ads-audit-wake-check.sh
```

**Configure credentials:**
```bash
# ~/.claude/google-ads.yaml
developer_token: YOUR_TOKEN
client_id: YOUR_CLIENT_ID
client_secret: YOUR_SECRET
refresh_token: YOUR_REFRESH_TOKEN
```

**Schedule (LaunchAgent):**
```bash
# ~/Library/LaunchAgents/com.hmz.daily-ads-audit.plist
# RunAtLoad + StartCalendarInterval hour=8 minute=0
```

---

## 📊 OUTPUT FORMAT

```
~/Downloads/
  DigiMinds/
    2026-05-15/
      08-00-01/
        DigiMinds_360_Audit_2026.xlsx
        DigiMinds_360_Audit_2026.pdf
        DigiMinds_360_Audit_2026.html
  CityOrtho/
    ...
```

**PDF sections:** Executive Summary · Campaign Performance · Keyword Analysis · Quality Score · Recommendations · Next Steps

---

## 💡 TIPS AND TRICKS (8)

[schedule](#tips-schedule) · [output](#tips-output) · [api](#tips-api) · [debug](#tips-debug)

<a id="tips-schedule"></a>■ **Scheduling (2)**

| Tip | Source |
|-----|--------|
| `ads-audit-wake-check.sh` compares last-run timestamp — detects missed audits after sleep | [HMZ](https://github.com/hmzainjamil) |
| Add `StartCalendarInterval` with `Weekday 1-5` to skip weekends in LaunchAgent | [Apple Docs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/ScheduledJobs.html) |

<a id="tips-output"></a>■ **Output (2)**

| Tip | Source |
|-----|--------|
| PDF uses client brand palette — update `brand_palette` dict with hex codes from client site | [HMZ](https://github.com/hmzainjamil) |
| XLSX column widths auto-fit — use `openpyxl` `auto_fit` before save for clean export | [HMZ](https://github.com/hmzainjamil) |

<a id="tips-api"></a>■ **API (2)**

| Tip | Source |
|-----|--------|
| Google Ads API quota: 15,000 ops/day — 3 clients × daily = well within limits | [Google Ads API Docs](https://developers.google.com/google-ads/api/docs/best-practices/quotas) |
| GA4 Data API free tier: 200k tokens/day — sufficient for daily audit | [GA4 Docs](https://developers.google.com/analytics/devguides/reporting/data/v1/quotas) |

<a id="tips-debug"></a>■ **Debug (2)**

| Tip | Source |
|-----|--------|
| Run `python3 daily-ads-audit.py --client DigiMinds --dry-run` to validate without API calls | [HMZ](https://github.com/hmzainjamil) |
| Check `~/Downloads/audit-errors.log` for failed runs — common: expired refresh token | [HMZ](https://github.com/hmzainjamil) |

---

## ☠️ STARTUPS / BUSINESSES

| This Repo / Feature | Replaced |
|-|-|
| **daily-ads-audit.py** | [Optmyzr](https://optmyzr.com), [Adalysis](https://adalysis.com), [WordStream](https://wordstream.com) |
| **PDF branded reports** | [AgencyAnalytics](https://agencyanalytics.com), [NinjaCat](https://ninjacat.io), [DashThis](https://dashthis.com) |
| **Multi-client automation** | [Reportz](https://reportz.io), [Klipfolio](https://klipfolio.com), [Supermetrics](https://supermetrics.com) |
| **Wake guard + scheduler** | [Zapier](https://zapier.com), [Make.com](https://make.com) scheduled triggers — zero monthly fee |

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=hmzainjamil/daily-ads-audit&type=Date)](https://star-history.com/#hmzainjamil/daily-ads-audit&Date)

---

---

## 🏗 ARCHITECTURE

```
~/.claude/
├── bin/                    ← All executable scripts
├── skills/                 ← SKILL.md files for Claude
├── agents/                 ← Agent definition files
├── tcc-logs/               ← Task execution logs
│   └── YYYY-MM-DD/         ← Daily log directories
└── tier0.env               ← API keys for all Tier 0 models
```

**Dependencies:** Python 3.11+ · Bash · GitHub CLI (`gh`) · Ollama (local models)

---

## ❓ FAQ

**Q: Do I need all API keys?**
A: No. Each Tier 0 model is optional. Ollama (free local) works standalone.

**Q: Will this work on Linux/Windows?**
A: Bash scripts → Linux ✓. Windows needs WSL2. All Python scripts cross-platform.

**Q: How much does it cost to run?**
A: Groq + Gemini free tiers cover 90% of tasks. DeepSeek/GPT-4o-mini ~$1-5/month heavy use.

**Q: Can I add my own models?**
A: Yes — add to `tier0.env` + update model list in `tier0-blast`.

---

## 📋 CHANGELOG

| Version | Date | Changes |
|---|---|---|
| v1.2 | 2026-05-15 | Added ollama watchdog, hermes integration, daily sync |
| v1.1 | 2026-05-12 | MAE engine, TCC queue, Tier 0 router |
| v1.0 | 2026-05-10 | Initial release — core scripts + skills |

---

## 🔗 RELATED REPOS

| Repo | Relation |
|---|---|
| [mae-master-automation-engine](https://github.com/hmzainjamil/mae-master-automation-engine) | Orchestrates this system |
| [tcc-task-command-center](https://github.com/hmzainjamil/tcc-task-command-center) | Task queue for parallel execution |
| [tier0-llm-router](https://github.com/hmzainjamil/tier0-llm-router) | LLM routing layer |
| [hermes-ai-system](https://github.com/hmzainjamil/hermes-ai-system) | Local model orchestration |
| [claude-ai-system](https://github.com/hmzainjamil/claude-ai-system) | Master backup repo |


<div align="center">
Built by <a href="https://github.com/hmzainjamil">HMZ</a> · <a href="https://digiminds.org">DigiMinds</a> · Zero-manual PPC reporting
</div>
