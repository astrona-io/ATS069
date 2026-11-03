#!/usr/bin/env bash
# Reference solution, applied only by astrona test.
set -euo pipefail
cd /opt/portal
sed -i "/console.debug/d" packages/backend/src/health.ts
yarn format
python3 - <<'PY'
import json
data = json.load(open("package.json"))
data["scripts"]["check"] = "yarn tsc && yarn lint && yarn format:check && yarn test"
json.dump(data, open("package.json", "w"), indent=2)
open("package.json", "a").write("\n")
PY
cat > .githooks/pre-commit <<'HOOK'
#!/usr/bin/env bash
set -e
cd "$(git rev-parse --show-toplevel)"
yarn check
HOOK
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
