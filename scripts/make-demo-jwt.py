#!/usr/bin/env python3
import argparse, base64, json, time

def b64(obj):
    raw = json.dumps(obj, separators=(",", ":")).encode()
    return base64.urlsafe_b64encode(raw).rstrip(b"=").decode()

parser = argparse.ArgumentParser()
parser.add_argument("--actor", choices=["zorgkantoor", "zorgaanbieder"], default="zorgkantoor")
args = parser.parse_args()

now = int(time.time())
header = {"alg": "none", "typ": "JWT"}
base = {
    "iss": "auth.nid",
    "sub": "demo-user",
    "iat": now,
    "nbf": now - 10,
    "exp": now + 3600,
    "scopes": [
        "registers/wlzbemiddelingsregister",
        "registers/wlzindicatieregister/indicaties/indicatie:read"
    ]
}
if args.actor == "zorgkantoor":
    base.update({"instantie_type": "Zorgkantoor", "uzovi": "5500"})
else:
    base.update({"instantie_type": "Zorgaanbieder", "agb": "12345678"})
print(f"{b64(header)}.{b64(base)}.")
