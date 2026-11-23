"""Test retry vs give-up rules for HTTP errors, using httpbin.org."""

import time

import requests
import truststore

truststore.inject_into_ssl()

RETRY_CODES = {429, 500, 502, 503, 504}   # temporary problems: try again
MAX_RETRIES = 3


def fetch(url: str, timeout: float = 5):
    """GET url; retry on 429/5xx/timeout with growing waits, give up on 4xx."""
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            r = requests.get(url, timeout=timeout)
        except requests.Timeout:
            print(f"  attempt {attempt}: timeout - no answer in {timeout}s -> retry")
        else:
            if r.status_code < 400:
                print(f"  attempt {attempt}: {r.status_code} OK")
                return r
            if r.status_code in RETRY_CODES:
                print(f"  attempt {attempt}: {r.status_code} -> retry")
            else:
                print(f"  attempt {attempt}: {r.status_code} -> give up (fix the request)")
                return None

        if attempt < MAX_RETRIES:
            wait = 2 ** (attempt - 1)        # 1s, 2s, 4s ... (exponential backoff)
            print(f"  waiting {wait}s before next try")
            time.sleep(wait)

    print("  still failing after", MAX_RETRIES, "tries -> give up")
    return None


TESTS = [
    ("200 OK",                  "https://httpbin.org/status/200", 5),
    ("429 too many requests",   "https://httpbin.org/status/429", 5),
    ("500 server problem",      "https://httpbin.org/status/500", 5),
    ("503 server problem",      "https://httpbin.org/status/503", 5),
    ("timeout",                 "https://httpbin.org/delay/5",    2),  # server waits 5s, we wait 2s
    ("400 fix your request",    "https://httpbin.org/status/400", 5),
    ("401 wrong/missing key",   "https://httpbin.org/status/401", 5),
    ("403 not allowed",         "https://httpbin.org/status/403", 5),
    ("404 not found",           "https://httpbin.org/status/404", 5),
]

for name, url, timeout in TESTS:
    print(f"\n=== {name} ===")
    fetch(url, timeout=timeout)