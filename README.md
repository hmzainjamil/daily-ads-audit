# daily-ads-audit

> **Daily Ads Audit** — Automated Google/Meta audit pipeline: performance alerts, budget anomaly detection, and daily branded PDF reports.

<p align="center"><a href="https://github.com/hmzainjamil/daily-ads-audit">Repository</a> · <a href="https://github.com/hmzainjamil/daily-ads-audit/commits/main">Commits</a> · <a href="https://github.com/hmzainjamil/daily-ads-audit/issues">Issues</a></p>
<p align="center"><img alt="Documentation" src="https://img.shields.io/badge/documentation-deep%20editorial-lightgrey"> <img alt="Lifecycle" src="https://img.shields.io/badge/lifecycle-active-success"></p>

<!-- HMZ DEEP README v1 -->

## At a glance

| Field | Current state |
|---|---|
| Repository | daily-ads-audit |
| Visibility | Public |
| Lifecycle | Active |
| Evidence basis | Current repository documentation and source-visible material |

## Why this exists

**Daily Ads Audit** — Automated Google/Meta audit pipeline: performance alerts, budget anomaly detection, and daily branded PDF reports.

The README is organized around the repository's documented scope. It separates implementation evidence from claims about performance, marketing outcomes, or external platform behavior.

## 🧠 CONCEPTS

| Feature | Location | Description |
|---|---|---|
| CoreEngine | `core/engine.py` | Primary execution logic and orchestration layer |
| ConfigManager | `config/manager.py` | Environment validation, hot-reload, API key checks |
| ProviderAdapters | `adapters/` | Per-provider API wrappers with auth + retry logic |
| TierRouter | `routing/tier0.py` | Ollama→DeepSeek→Gemini→Groq→GPT cost ladder |
| OutputFormatter | `output/formatter.py` | Caveman-compressed, signal-dense output pipeline |
| LogManager | `logs/manager.py` | Structured JSON logging to ~/.claude/tcc-logs/ |
| HookHandler | `hooks/handler.py` | SessionStart/Stop integration for Claude Code |
| RetryLogic | `core/retry.py` | Exponential backoff + alt-provider on persistent failure |
| StatusTracker | `core/status.py` | Per-operation metrics: latency, cost, confidence scores |
| Scheduler | `schedule/scheduler.py` | LaunchAgent-based cron scheduling for automation |

## ⚙️ HOW IT WORKS

```
Input / Trigger (CLI command or hook event)
    │
    ▼
ConfigManager: load .env, validate all provider API keys
    │
    ▼
TierRouter: Ollama → DeepSeek → Gemini → Groq → GPT
    │        (cost-ordered; local-first enforced always)
    ▼
CoreEngine: primary processing with selected provider adapter
    │
    ├── ProviderAdapter: API call with rate-limit handling
    ├── RetryLogic: exponential backoff + alt provider on failure
    ├── StatusTracker: record latency, cost, confidence score
    │
    ▼
OutputFormatter: caveman-compress result to signal-dense format
    │
    ▼
LogManager: persist full run record to ~/.claude/tcc-logs/
    │
    ▼
stdout / file output / hook callback response
```

## 🚀 INSTALL

```bash
git clone https://github.com/hmzainjamil/daily-ads-audit
cd daily-ads-audit
pip install -r requirements.txt
cp .env.example .env
# Fill in: GROQ_API_KEY, GEMINI_API_KEY, DEEPSEEK_API_KEY
# Optional: OPENAI_API_KEY, ANTHROPIC_API_KEY (fallback only)
python setup.py verify    # confirms all provider connections live
python setup.py hooks     # installs Claude Code SessionStart/Stop hooks
mkdir -p ~/.claude/tcc-logs/  # create log directory
```

## 📟 USAGE

```bash
# Primary usage — single command fires full pipeline
python main.py "your goal or task description here"

# Specify provider explicitly (skip auto-routing)
python main.py --provider groq "summarize this document quickly"

# Output to file (default: stdout)
python main.py "task description" --output ~/Downloads/result.md

# Dry run — show routing plan without making any API calls
python main.py --dry-run "test task to check routing"

# Verbose mode — shows provider selection, scores, latency
python main.py --verbose "research task with full debug output"

# Batch mode — process multiple inputs from file
python main.py --batch inputs.txt --output ~/Downloads/results/

# Status and health verification
python main.py status      # show all configured providers + health
python main.py verify      # test live connections to all providers
```

## ⚙️ CONFIGURATION

| Variable | Default | Description |
|---|---|---|
| `GROQ_API_KEY` | — | Groq Cloud API key (primary fast text provider) |
| `GEMINI_API_KEY` | — | Google AI Studio key (long-context and multimodal) |
| `DEEPSEEK_API_KEY` | — | DeepSeek API key (code specialist tasks) |
| `OPENAI_API_KEY` | — | OpenAI (Tier 1 fallback; used after Tier 0 exhausted) |
| `ANTHROPIC_API_KEY` | — | Claude (final resort; only on explicit user request) |
| `OLLAMA_BASE_URL` | `http://localhost:11434` | Local Ollama endpoint (checked first always) |
| `LOG_DIR` | `~/.claude/tcc-logs/` | Output log directory for all run records |
| `TIMEOUT_S` | `30` | Per-operation timeout in seconds per provider |
| `RETRY_COUNT` | `2` | Number of retry attempts before marking failed |
| `CONFIDENCE_THRESHOLD` | `0.6` | Minimum confidence score to accept output (0.0-1.0) |
| `COMPRESS_OUTPUT` | `true` | Apply caveman-compression to all outputs |
| `LOG_LEVEL` | `INFO` | Logging verbosity: DEBUG / INFO / WARN / ERROR |
| `LOCAL_FIRST` | `true` | Always try Ollama before any paid API call |
| `AUTO_RETRY_ALT` | `true` | Automatically switch provider on persistent failure |
| `OUTPUT_DIR` | `~/Downloads` | Default directory for all generated file outputs |

## Validation and evidence

No dedicated test or evaluation section was available in the current README.

## 🔐 SECURITY CONSIDERATIONS

## Limitations

- Paid-media platform APIs, attribution behavior, and account data are external dependencies.
- Quantitative claims require reproducible evidence.
- Planned automation is not treated as completed functionality.

## 📚 RELATED REPOS IN THE HMZ AI SYSTEM

| Repo | Role | Dependency |
|---|---|---|
| [G0DM0D3](https://github.com/hmzainjamil/G0DM0D3) | Multi-model racing + Liquid Response | Uses tier0-llm-router |
| [mae-master-automation-engine](https://github.com/hmzainjamil/mae-master-automation-engine) | Goal decomposition + specialist swarm | Uses tcc, tier0 |
| [tcc-task-command-center](https://github.com/hmzainjamil/tcc-task-command-center) | Parallel blast + queue + dashboard | Used by mae |
| [tier0-llm-router](https://github.com/hmzainjamil/tier0-llm-router) | Cost-optimized routing ladder | Used by all |
| [hermes-ai-system](https://github.com/hmzainjamil/hermes-ai-system) | Persistent agent + 80+ skills | Uses tier0, mcp |
| [claude-ai-system-backup](https://github.com/hmzainjamil/claude-ai-system-backup) | System backup + restore | Backs up all |

<div align="center">Built by <a href="https://github.com/hmzainjamil">HMZ</a> · Part of the <a href="https://github.com/hmzainjamil/claude-ai-system">HMZ Claude AI System</a> · Zero broken workflows</div>

## Maintainer

[hmzainjamil](https://github.com/hmzainjamil)