#!/usr/bin/env bash
set -euo pipefail

# fix_about_blank.sh
# Run from the root of the Hugo project (folder containing hugo.toml).
#
# Fixes blank About section by adding defaults in the template when config params are missing.
# Keeps config-driven behavior: if hugo.toml has values they will display.

THEME_DIR="themes/lmdv"
ABOUT_HTML="${THEME_DIR}/layouts/partials/sections/about.html"

if [[ ! -f "hugo.toml" ]]; then
  echo "ERROR: hugo.toml not found. Run this from the Hugo project root."
  exit 1
fi

if [[ ! -f "${ABOUT_HTML}" ]]; then
  echo "ERROR: ${ABOUT_HTML} not found."
  exit 1
fi

cat > "${ABOUT_HTML}" <<'EOF'
<section id="about" class="section">
  <div class="wrap">
    <h2>{{ .Site.Params.home.aboutTitle | default "About" }}</h2>

    <div class="panel pad">
      {{ $p1 := .Site.Params.home.aboutP1 | default "Maryland’s laws and constitution set many important rules for public life, but citizens have limited ability to place statutory or constitutional questions directly before voters through a citizen-initiated ballot process." }}
      {{ $p2 := .Site.Params.home.aboutP2 | default "Let MD Vote advocates for a statewide mechanism that allows citizens to propose eligible measures for voter consideration, through a clear, orderly procedure with strong safeguards and transparent administration." }}

      <p>{{ $p1 }}</p>
      <p>{{ $p2 }}</p>

      {{ $pills := .Site.Params.home.aboutPills | default (slice "Civic participation" "Accountability" "Transparency" "Peaceful, lawful change") }}
      <div style="margin-top:12px; display:flex; flex-wrap:wrap; gap:10px;">
        {{ range $pills }}
          <span class="pill">{{ . }}</span>
        {{ end }}
      </div>
    </div>
  </div>
</section>
EOF

echo "Done. About section now renders with defaults if config values are missing."
echo "Run: hugo server -D"
