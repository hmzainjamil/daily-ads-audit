# daily-ads-audit

Daily Google Ads + Meta Ads audit pipeline: performance alerts, budget pacing checks, anomaly detection, and automated client reports.

![Google Ads](https://img.shields.io/badge/Google_Ads-API-blue?style=flat&labelColor=555) ![Meta Ads](https://img.shields.io/badge/Meta_Ads-API-green?style=flat&labelColor=555) ![Automation](https://img.shields.io/badge/Audit-Automated-orange?style=flat&labelColor=555) ![License](https://img.shields.io/badge/License-MIT-yellow?style=flat&labelColor=555)

[Concepts](#-concepts) · [How It Works](#-how-it-works) · [Install](#-install) · [Usage](#-usage) · [Config](#-configuration) · [Tips](#-tips-and-tricks-12) · [Troubleshooting](#-troubleshooting) · [Architecture](#-architecture) · [Startups](#️-startups--businesses)

---

## 🧠 CONCEPTS

| Feature | Location | Description |
|---|---|---|
| Google Ads Puller | `pullers/google_ads.py` | Pulls campaign/adgroup/keyword metrics via Google Ads API |
| Meta Ads Puller | `pullers/meta_ads.py` | Pulls ad/adset/campaign metrics via Meta Marketing API |
| Anomaly Detector | `detectors/anomaly.py` | Z-score + IQR detection on CPC, CVR, CTR, CPA |
| Budget Pacer | `detectors/budget_pacing.py` | Compares current spend vs ideal pacing curve |
| Alert Engine | `alerts/engine.py` | Triggers Slack/email alerts when thresholds breached |
| Report Generator | `reports/generate.py` | Daily PDF/HTML report with charts and anomalies |
| Benchmark Tracker | `benchmarks/tracker.py` | Track KPIs vs account historical avg and industry benchmarks |
| Scheduler | `scheduler/cron.py` | Runs full audit pipeline at 09:00 daily |
| Slack Notifier | `notifiers/slack.py` | Posts audit summary to Slack channel |
| Client Dashboard | `ui/dashboard.py` | Multi-account performance overview |
| Rules Engine | `rules/engine.py` | Configurable alert rules: budget, QS, CTR, impression share |
| Historical Store | `db/store.py` | SQLite store for 90-day metric history per account |

### 🔥 Hot

| Feature | Location | Description |
|---|---|---|
| Anomaly Detector | `detectors/anomaly.py` | Catches CTR drops / CPA spikes before client notices |
| Budget Pacer | `detectors/budget_pacing.py` | Real-time pacing prevents over/under spend |
| Alert Engine | `alerts/engine.py` | Zero-delay alerts — account managers notified before clients |
| Report Generator | `reports/generate.py` | Auto-generated daily report replaces 2-hour manual process |
| Rules Engine | `rules/engine.py` | Declarative rules — no code changes to add new alerts |

---

## ⚙️ HOW IT WORKS

```
09:00 Daily (Cron)
    │
    ▼
┌──────────────────────────────────┐
│  PULL PHASE                      │
│  google_ads.py + meta_ads.py     │
│  → metrics for all accounts     │
└──────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────┐
│  DETECT PHASE                    │
│  anomaly.py → flag outliers      │
│  budget_pacing.py → over/under   │
│  rules/engine.py → rule checks   │
└──────────────────────────────────┘
    │ (anomalies found)
    ▼
┌──────────────────────────────────┐
│  ALERT PHASE                     │
│  Slack → #ads-alerts             │
│  Email → account manager         │
└──────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────┐
│  REPORT PHASE                    │
│  Generate PDF + HTML report      │
│  Upload to GDrive / send email   │
└──────────────────────────────────┘
```

---

## 🚀 INSTALL

```bash
git clone https://github.com/hmzainjamil/daily-ads-audit
cd daily-ads-audit

pip install -r requirements.txt
# google-ads, facebook-business, pandas, scipy, reportlab, slack-sdk

cp .env.example .env
# Fill: GOOGLE_ADS_*, META_ACCESS_TOKEN, SLACK_BOT_TOKEN, SLACK_CHANNEL_ID

# Init database
python3 db/init.py

# Test pullers
python3 pullers/google_ads.py --test
python3 pullers/meta_ads.py --test

# Run full audit manually
python3 run_audit.py

# Schedule daily run
python3 scheduler/install_cron.py
```

---

## 📟 USAGE

```bash
# Run full daily audit now
python3 run_audit.py

# Audit specific account only
python3 run_audit.py --account GOOGLE:1234567890

# Pull metrics only (no alerts/report)
python3 run_audit.py --pull-only

# Check budget pacing for all accounts
python3 detectors/budget_pacing.py --today

# Detect anomalies in last 7 days
python3 detectors/anomaly.py --days 7

# Generate report for specific date
python3 reports/generate.py --date 2025-01-15 --output ~/Downloads/

# Test Slack alert
python3 notifiers/slack.py --test

# View multi-account dashboard
python3 ui/dashboard.py
```

---

## ⚙️ CONFIGURATION

| Variable | Default | Description |
|---|---|---|
| `AUDIT_RUN_TIME` | `09:00` | Daily audit cron time |
| `ANOMALY_ZSCORE_THRESHOLD` | `2.5` | Z-score above which metric flagged as anomaly |
| `BUDGET_PACING_ALERT_PCT` | `0.20` | Alert if spend deviates >20% from ideal pacing |
| `CPA_SPIKE_THRESHOLD_PCT` | `0.30` | Alert if CPA rises >30% vs 7-day avg |
| `CTR_DROP_THRESHOLD_PCT` | `0.25` | Alert if CTR drops >25% vs 7-day avg |
| `HISTORY_RETENTION_DAYS` | `90` | Days of metric history to retain |
| `REPORT_FORMAT` | `pdf` | `pdf` or `html` |
| `SLACK_CHANNEL_ID` | — | Slack channel for alerts |
| `GDRIVE_FOLDER_ID` | — | Google Drive folder for reports |
| `ACCOUNTS_CONFIG` | `config/accounts.yaml` | Multi-account configuration |

---

## 💡 TIPS AND TRICKS (12)

[Anomaly Detection](#tips-anomaly) · [Budget Pacing](#tips-pacing) · [Alerts](#tips-alerts) · [Reporting](#tips-reporting)

<a id="tips-anomaly"></a>■ **Anomaly Detection (3)**

| Tip | Source |
|---|---|
| Z-score >2.5 with 30-day baseline catches real anomalies without false positives | Anomaly detector config |
| Compare anomalies across accounts — cross-account drops indicate platform issue not account issue | Anomaly detector |
| Mark known anomalies (holidays, sales) in `config/exclusions.yaml` to suppress false alerts | Rules engine |

<a id="tips-pacing"></a>■ **Budget Pacing (3)**

| Tip | Source |
|---|---|
| Ideal pacing = linear by default — adjust to `front_loaded` for awareness campaigns | Budget pacer |
| 20% under-pacing by noon = flag for budget increase or bid adjustment | Budget pacing docs |
| Weekend pacing differs — configure `weekend_multiplier: 0.8` for B2B accounts | Config guide |

<a id="tips-alerts"></a>■ **Alert Management (3)**

| Tip | Source |
|---|---|
| Alert rules in `rules/engine.yaml` — no Python needed to add new checks | Rules engine |
| Use `severity: critical / warning / info` — Slack alerts filtered by severity | Alert config |
| `alerts/engine.py --mute 24h` during planned maintenance prevents alert spam | Alert engine |

<a id="tips-reporting"></a>■ **Reporting (3)**

| Tip | Source |
|---|---|
| PDF reports auto-uploaded to GDrive — share link with clients directly | Report generator |
| Include 7-day trend chart in every report — context prevents misinterpretation | Report template |
| `reports/generate.py --white-label` removes agency branding for client-facing reports | Report flags |

---

## 🔧 TROUBLESHOOTING

| Issue | Fix |
|---|---|
| Google Ads API auth fails | Refresh token: `python3 scripts/refresh_google_token.py` |
| Meta API 190 error | Access token expired — regenerate in Meta Business Manager |
| No anomalies detected | Check baseline period — need 14+ days of data |
| Slack alerts not sending | Test: `python3 notifiers/slack.py --test` |
| Report PDF empty | Check data pull succeeded: `python3 run_audit.py --pull-only` |
| Cron not running | `crontab -l` — verify entry; check system logs |
| Database locked | Kill stale Python process: `pkill -f run_audit.py` |

---

## 📊 ARCHITECTURE

```
daily-ads-audit/
├── pullers/
│   ├── google_ads.py           # Google Ads API client
│   └── meta_ads.py             # Meta Marketing API client
├── detectors/
│   ├── anomaly.py              # Z-score + IQR detection
│   └── budget_pacing.py        # Spend vs pacing curve
├── alerts/
│   └── engine.py               # Alert dispatch logic
├── rules/
│   ├── engine.py               # Rule evaluation
│   └── rules.yaml              # Declarative alert rules
├── reports/
│   ├── generate.py             # PDF/HTML report builder
│   └── templates/              # Report templates
├── notifiers/
│   ├── slack.py                # Slack notifier
│   └── email.py                # Email notifier
├── benchmarks/
│   └── tracker.py              # KPI benchmark tracking
├── db/
│   ├── init.py
│   └── store.py                # SQLite metric store
├── scheduler/
│   ├── cron.py
│   └── install_cron.py
├── ui/
│   └── dashboard.py            # Multi-account overview
├── config/
│   ├── accounts.yaml           # Account configuration
│   └── alerts.yaml             # Alert thresholds
├── run_audit.py                # Main entry point
└── .env.example
```

---

## 📋 BUILT-IN ALERT RULES

| Rule | Trigger | Severity |
|---|---|---|
| Budget overpace | Spend >20% above ideal pacing | Warning |
| Budget underpace | Spend >20% below ideal pacing | Info |
| CPA spike | CPA >30% above 7-day avg | Critical |
| CTR crash | CTR <25% of 7-day avg | Critical |
| QS degradation | Avg QS drops below 6 | Warning |
| Impression share loss | IS drops >10% week-over-week | Warning |
| Zero conversions | No conversions in last 24h | Critical |
| Ad disapproval | Any active ad disapproved | Critical |

---

## ☠️ STARTUPS / BUSINESSES

| This Repo / Feature | Replaced |
|---|---|
| Anomaly Detector | Client noticing issues before account manager |
| Budget Pacer | End-of-month budget exhaustion or under-delivery |
| Daily Audit Pipeline | 2-hour manual daily account review |
| Alert Engine | Checking accounts manually after client complaint |
| Report Generator | Manual weekly report in Google Slides (4+ hours) |
| Rules Engine | Hard-coded alert logic requiring developer changes |
| Multi-account Dashboard | Switching between 10+ accounts manually |
| Historical Store | No trend data for anomaly context |

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=hmzainjamil/daily-ads-audit&type=Date)](https://star-history.com/#hmzainjamil/daily-ads-audit&Date)

---
<div align="center">Built by <a href="https://github.com/hmzainjamil">HMZ</a> · Part of HMZ Claude AI System</div>

---

## 🔄 CONTRIBUTING

PRs welcome. Please:
1. Fork the repo
2. Create a feature branch
3. Add tests for new functionality
4. Submit PR with description of changes

---

## 📋 ACCOUNT CONFIG FORMAT

```yaml
# config/accounts.yaml
accounts:
  - name: "DigiMinds - Client A"
    platform: google_ads
    customer_id: "1234567890"
    daily_budget_usd: 150
    alert_email: "manager@digiminds.com"
    slack_channel: "#client-a-alerts"

  - name: "DigiMinds - Client B"
    platform: meta_ads
    ad_account_id: "act_987654321"
    daily_budget_usd: 200
    alert_email: "manager@digiminds.com"
    slack_channel: "#client-b-alerts"
```

---

## 📊 SAMPLE DAILY REPORT SECTIONS

1. Executive Summary — yesterday vs 7-day avg
2. Budget Pacing — all accounts spend vs plan
3. Anomalies Detected — flagged metrics with context
4. Top Performing Campaigns — ranked by ROAS/CPA
5. Underperforming Campaigns — below threshold
6. Quality Score Changes — QS movement table
7. Search Impression Share — by campaign
8. Recommendations — auto-generated action items
