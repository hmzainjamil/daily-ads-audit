# Security and data handling

## Scope

This note records risks visible in the repository source. It is not a security audit or compliance assessment.

## Client data in source

The tracked Python script contains named client profiles and Google Ads/GA4 account identifiers. It also contains phone numbers, a tracking identifier, and account-specific assumptions in recommendation text. Treat these details as sensitive operational data. The maintainer should remove them from the public source and assess whether they require rotation or other remediation. Removing current values does not erase earlier Git history, forks, or cached copies.

## API credentials and external data transfer

Set `WINDSOR_API_KEY` through a protected environment variable. Do not commit a real key. The script sends that key, account identifiers, selected fields, and date ranges to the configured Windsor.ai endpoint. Windsor.ai access, processing, retention, and contractual terms are outside this repository and must be reviewed by the data owner.

## Reports

Generated XLSX, PDF, and HTML reports include account and campaign metrics, campaign names, and recommendations. The default output is under the user's Downloads directory. Protect, share, retain, and delete these files according to the applicable client agreement and data policy. No automatic deletion or access control is implemented.

## HTML output

The report builder inserts data values such as campaign names and generated issue text into HTML templates. Source does not visibly escape these values before interpolation. Review and fix output escaping before opening reports containing untrusted account or campaign text in a browser.

## Wake-check side effects

`ads-audit-wake-check.sh` creates a sentinel and log under `~/.claude/logs` and may launch the installed script in the background after 17:00. It assumes the path `/Users/mc/.claude/bin/daily-ads-audit.py`. Do not install it as an automatic job without confirming schedule, path, network calls, data scope, and log protections.

## Evidence limits

No tests, dependency lock, security checks, retention policy, access-control design, or compliance evidence are included in the tracked tree. Avoid live customer data until the source configuration and data-handling controls have been reviewed by the responsible owner.
