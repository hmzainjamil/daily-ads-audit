# Daily Ads Audit

A Python script that requests Google Ads and GA4 data through Windsor.ai, applies fixed heuristic checks, and writes XLSX, PDF, and HTML reports. It does not change campaigns or create a connected Google/Meta platform integration.

| Status | Evidence |
|---|---|
| Source reviewed | 2026-10-02; one Python script and one shell wake-check |
| Data connector | Windsor.ai HTTP endpoint, configured in source |
| Tests and evaluation | No test suite or reproducible evaluation included |
| Dependencies | Imported libraries listed below; no pinned dependency manifest |
| License | No license file or declared license identified |

## Scope

The script iterates over client profiles defined inside `daily-ads-audit.py`. It requests Google Ads and GA4 data for a rolling date window, calculates account and campaign summaries, applies hard-coded thresholds and recommendations, then writes reports beneath `~/Downloads/<client>/<date>/<time>/`. The data and recommendations have not been independently validated.

The included profiles contain client and account identifiers, industry-specific assumptions, and other operational details. This public repository should not be used with live customer data until the maintainer reviews and removes or replaces those values. See [SECURITY.md](SECURITY.md).

The script only reads ad/analytics data and generates files in the inspected code. Recommendations such as pausing campaigns are text; the script does not call a campaign mutation API.

## Current files

- `daily-ads-audit.py`: data pull, calculations, heuristic issue detection, and XLSX/PDF/HTML generation.
- `ads-audit-wake-check.sh`: after 17:00 local time, checks a date sentinel and backgrounds a machine-specific installed script path; it writes a log and sentinel beneath `~/.claude/logs`.

## Setup and run

No install guide, dependency lock, configuration file, or client-profile schema is included. Source imports `requests`, `openpyxl`, and `reportlab`; install versions in an isolated environment only after maintainer review. Set `WINDSOR_API_KEY` in the environment. The code currently has three profiles embedded in source, so do not run it against production or third-party accounts before reviewing and replacing them.

After installing those dependencies and preparing an approved configuration, the source entry point is:

```sh
python3 daily-ads-audit.py
```

This command has not been executed in this review. It makes network requests and writes reports under Downloads for every configured profile. The shell wake-check is not a portable scheduler setup; its installed path and log locations are machine-specific.

## Data and report behavior

Requests go to the Windsor.ai connector endpoint with account IDs, requested fields, and date ranges in query parameters. The script writes campaign names, measurements, summaries, and recommendations to spreadsheet, PDF, and HTML files. Treat the output as confidential customer data. No retention, access-control, deletion, or sharing policy is defined here.

The analysis uses fixed thresholds in source, including CTR, CPA, CPC, ROAS, bounce-rate, and session-duration checks, plus profile-specific assumptions. These are code defaults, not validated industry benchmarks or professional advice. Verify formulas, attribution windows, conversion definitions, and thresholds against each account before relying on the output.

## Documentation

- [Security and data handling](SECURITY.md)

## Limitations

- No automated schedule installation, alert delivery, dashboard hosting, or ad changes are implemented in the tracked files.
- The wake-check assumes an existing script at `/Users/mc/.claude/bin/daily-ads-audit.py`; it is not wired to a fresh checkout.
- The current script uses hard-coded account profiles and includes sensitive operational identifiers.
- There is no test suite, pinned dependency manifest, release process, or support policy in the tracked tree.

## Maintainer

[hmzainjamil](https://github.com/hmzainjamil)
