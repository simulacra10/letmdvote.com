#!/usr/bin/env bash
set -euo pipefail

# apply_original_style_hero_image.sh
# Run from the root of the Hugo project (the folder containing hugo.toml).
#
# This script:
# - Adds static/css/site.css with the original design styling
# - Updates the theme templates in themes/lmdv/layouts to match the original HTML structure
# - Changes the hero area to display a hero image (config-driven), while keeping the original style

THEME_DIR="themes/lmdv"
LAYOUTS_DIR="${THEME_DIR}/layouts"
PARTIALS_DIR="${LAYOUTS_DIR}/partials/sections"
STATIC_CSS_DIR="static/css"

if [[ ! -f "hugo.toml" ]]; then
  echo "ERROR: hugo.toml not found. Run this from the Hugo project root."
  exit 1
fi

if [[ ! -d "${THEME_DIR}" ]]; then
  echo "ERROR: ${THEME_DIR} not found. Expected the theme tree shown in tree.txt."
  exit 1
fi

mkdir -p "${LAYOUTS_DIR}/_default" "${PARTIALS_DIR}" "${STATIC_CSS_DIR}"

# 1) Write CSS (ported from the original inline <style> with minimal edits)
cat > "${STATIC_CSS_DIR}/site.css" <<'EOF'
:root{
  --bg: #0b1020;
  --panel: rgba(255,255,255,0.06);
  --panel-2: rgba(255,255,255,0.09);
  --text: rgba(255,255,255,0.92);
  --muted: rgba(255,255,255,0.72);
  --soft: rgba(255,255,255,0.14);
  --brand: #e95420;
  --brand2: #772953;
  --ok: #22c55e;

  --max: 1100px;
  --radius: 18px;
  --shadow: 0 10px 30px rgba(0,0,0,0.35);

  --h1: clamp(2.05rem, 4vw, 3rem);
  --h2: clamp(1.35rem, 2.2vw, 1.75rem);
  --h3: 1.05rem;
  --p: 1rem;
}

*{ box-sizing:border-box; }
html{ scroll-behavior:smooth; }
body{
  margin:0;
  font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple Color Emoji","Segoe UI Emoji";
  background: radial-gradient(1200px 600px at 20% -10%, rgba(233,84,32,0.20), transparent 55%),
              radial-gradient(900px 500px at 90% 0%, rgba(119,41,83,0.22), transparent 60%),
              linear-gradient(180deg, #070a14, var(--bg));
  color: var(--text);
  line-height: 1.5;
}

a{ color: inherit; text-decoration: none; }
a.underline{ text-decoration: underline; text-underline-offset: 3px; }

.wrap{ max-width: var(--max); margin: 0 auto; padding: 0 20px; }
.topbar{
  position: sticky; top: 0; z-index: 50;
  backdrop-filter: blur(14px);
  background: rgba(7,10,20,0.72);
  border-bottom: 1px solid rgba(255,255,255,0.08);
}
.topbar-inner{
  display:flex; align-items:center; justify-content:space-between;
  gap: 14px;
  padding: 14px 0;
}
.brand{
  display:flex; align-items:center; gap: 10px;
  min-width: 180px;
}
.mark{
  width: 34px; height: 34px; border-radius: 10px;
  background: linear-gradient(135deg, rgba(233,84,32,0.95), rgba(119,41,83,0.95));
  box-shadow: 0 8px 18px rgba(0,0,0,0.35);
}
.brand-title{
  display:flex; flex-direction:column; line-height:1.1;
}
.brand-title strong{ font-size: 0.98rem; letter-spacing: 0.2px; }
.brand-title span{ font-size: 0.82rem; color: var(--muted); }

nav{
  display:flex; align-items:center; gap: 16px;
}
nav a{
  color: var(--muted);
  font-size: 0.95rem;
  padding: 8px 10px;
  border-radius: 10px;
  border: 1px solid transparent;
}
nav a:hover{
  color: var(--text);
  border-color: rgba(255,255,255,0.10);
  background: rgba(255,255,255,0.04);
}

.cta-row{ display:flex; gap: 10px; align-items:center; }
.btn{
  display:inline-flex; align-items:center; justify-content:center;
  gap: 8px;
  padding: 10px 14px;
  border-radius: 12px;
  border: 1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.05);
  color: var(--text);
  font-weight: 600;
  cursor: pointer;
  transition: transform 120ms ease, background 120ms ease, border-color 120ms ease;
  white-space: nowrap;
}
.btn:hover{
  transform: translateY(-1px);
  background: rgba(255,255,255,0.08);
  border-color: rgba(255,255,255,0.20);
}
.btn.primary{
  border-color: rgba(233,84,32,0.55);
  background: linear-gradient(135deg, rgba(233,84,32,0.95), rgba(233,84,32,0.72));
}
.btn.primary:hover{
  background: linear-gradient(135deg, rgba(233,84,32,1), rgba(233,84,32,0.78));
}

.hero{
  padding: 54px 0 26px;
}
.hero-grid{
  display:grid;
  grid-template-columns: 1.25fr 0.75fr;
  gap: 22px;
  align-items: start;
}
.kicker{
  display:inline-flex; align-items:center; gap: 10px;
  padding: 8px 12px;
  border-radius: 999px;
  border: 1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.05);
  color: var(--muted);
  font-size: 0.92rem;
}
.dot{
  width: 8px; height: 8px; border-radius: 999px;
  background: var(--ok);
  box-shadow: 0 0 0 6px rgba(34,197,94,0.10);
}
h1{
  margin: 14px 0 12px;
  font-size: var(--h1);
  line-height: 1.08;
  letter-spacing: -0.02em;
}
.lead{
  font-size: 1.05rem;
  color: var(--muted);
  max-width: 60ch;
}
.hero-actions{
  margin-top: 18px;
  display:flex;
  flex-wrap: wrap;
  gap: 10px;
  align-items:center;
}

.panel{
  border-radius: var(--radius);
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.10);
  box-shadow: var(--shadow);
}
.panel.pad{ padding: 18px; }

.stats{
  display:grid;
  gap: 10px;
}
.stat{
  border-radius: 14px;
  padding: 14px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.10);
}
.stat strong{ display:block; font-size: 0.98rem; }
.stat span{ display:block; color: var(--muted); font-size: 0.92rem; margin-top: 4px; }

.section{
  padding: 34px 0;
}
.section h2{
  margin: 0 0 12px;
  font-size: var(--h2);
  letter-spacing: -0.01em;
}
.section p{ margin: 0 0 12px; color: var(--muted); font-size: var(--p); }

.cards{
  display:grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
  margin-top: 14px;
}
.card{
  border-radius: var(--radius);
  padding: 16px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.10);
}
.card h3{
  margin: 0 0 8px;
  font-size: var(--h3);
  letter-spacing: -0.01em;
}
.card p{ margin: 0; color: var(--muted); }

.two-col{
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px;
  align-items: start;
  margin-top: 14px;
}

details{
  border-radius: 14px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.10);
  padding: 12px 14px;
}
details + details{ margin-top: 10px; }
summary{
  cursor: pointer;
  font-weight: 700;
  color: var(--text);
  list-style: none;
}
summary::-webkit-details-marker{ display:none; }
details p{ margin: 10px 0 0; }

footer{
  padding: 30px 0 44px;
  border-top: 1px solid rgba(255,255,255,0.08);
  color: var(--muted);
}
.footer-grid{
  display:grid;
  grid-template-columns: 1fr auto;
  gap: 14px;
  align-items: start;
}
.tiny{ font-size: 0.92rem; color: var(--muted); }

.pill{
  display:inline-flex;
  align-items:center;
  gap: 8px;
  padding: 6px 10px;
  border-radius: 999px;
  border: 1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.04);
  color: var(--muted);
  font-size: 0.92rem;
}

/* HERO IMAGE ADDITIONS (new) */
.hero-media{
  overflow: hidden;
}
.hero-media img{
  width: 100%;
  height: 420px;
  display: block;
  object-fit: cover;
  border-radius: var(--radius);
}
.hero-media .caption{
  margin-top: 12px;
}

/* Mobile */
@media (max-width: 900px){
  .hero-grid{ grid-template-columns: 1fr; }
  .cards{ grid-template-columns: 1fr; }
  .two-col{ grid-template-columns: 1fr; }
  nav{ display:none; }
  .brand{ min-width: 0; }
  .hero-media img{ height: 320px; }
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce){
  html{ scroll-behavior:auto; }
  .btn{ transition:none; }
}
EOF

# 2) baseof.html: include CSS and a few meta tags (lean, theme-friendly)
cat > "${LAYOUTS_DIR}/_default/baseof.html" <<'EOF'
<!doctype html>
<html lang="{{ .Site.Language.Lang | default "en" }}">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <title>{{ .Site.Title }}</title>

  {{ with .Site.Params.description }}
    <meta name="description" content="{{ . }}" />
  {{ end }}

  <link rel="stylesheet" href="/css/site.css" />
</head>
<body>
  {{ block "main" . }}{{ end }}
</body>
</html>
EOF

# 3) index.html: assemble the single-page sections
cat > "${LAYOUTS_DIR}/index.html" <<'EOF'
{{ define "main" }}
  {{ partial "sections/hero.html" . }}
  {{ partial "sections/about.html" . }}
  {{ partial "sections/case.html" . }}
  {{ partial "sections/how.html" . }}
  {{ partial "sections/involved.html" . }}
  {{ partial "sections/faq.html" . }}
  {{ partial "sections/principle.html" . }}
  {{ partial "sections/footer.html" . }}
{{ end }}
EOF

# Helpers: access config safely with defaults
# Note: We keep section ids as the original design used: about, why, how, help, faq.
# This avoids anchor mismatch and matches the original site’s nav behavior.

# 4) hero.html: topbar + hero with hero image (config-driven)
cat > "${PARTIALS_DIR}/hero.html" <<'EOF'
<header class="topbar" role="banner">
  <div class="wrap">
    <div class="topbar-inner">
      <a class="brand" href="#top" aria-label="{{ .Site.Params.siteName | default .Site.Title }} home">
        <div class="mark" aria-hidden="true"></div>
        <div class="brand-title">
          <strong>{{ .Site.Params.siteName | default .Site.Title }}</strong>
          <span>{{ .Site.Params.siteTagline | default "" }}</span>
        </div>
      </a>

      <nav aria-label="Primary">
        <a href="#about">About</a>
        <a href="#why">Our case</a>
        <a href="#how">How it works</a>
        <a href="#help">Get involved</a>
        <a href="#faq">FAQ</a>
      </nav>

      <div class="cta-row">
        <a class="btn" href="#help">Join updates</a>
        <a class="btn primary" href="#help">Volunteer</a>
      </div>
    </div>
  </div>
</header>

<main id="top">
  <section class="hero">
    <div class="wrap">
      <div class="hero-grid">
        <div class="panel pad hero-media">
          <div class="kicker">
            <span class="dot" aria-hidden="true"></span>
            <span>{{ .Site.Params.home.eyebrow | default "Building a lawful path for Maryland citizens to place measures on the ballot" }}</span>
          </div>

          {{ $src := "/images/hero.jpg" }}
          {{ $alt := "Hero image" }}

          {{ with .Site.Params.home.heroImage }}
            {{ with .src }}{{ $src = . }}{{ end }}
            {{ with .alt }}{{ $alt = . }}{{ end }}
          {{ end }}

          <img src="{{ $src }}" alt="{{ $alt }}" loading="eager" />

          <div class="caption">
            <div class="hero-actions">
              {{ range .Site.Params.home.heroButtons }}
                {{ $cls := "btn" }}
                {{ if eq .style "primary" }}{{ $cls = "btn primary" }}{{ end }}
                <a class="{{ $cls }}" href="{{ .href }}">{{ .label }}</a>
              {{ end }}
            </div>

            <p class="tiny" style="margin-top:12px;">
              {{ if .Site.Params.home.heroImage.overlayText }}
                {{ .Site.Params.home.heroImage.overlayText }}
              {{ else }}
                {{ delimit (.Site.Params.home.heroBadges | default (slice "Nonpartisan." "Pro-process." "Pro-voter.")) " " }}
              {{ end }}
            </p>
          </div>
        </div>

        <aside class="panel pad" aria-label="Quick highlights">
          <div class="stats">
            {{ range .Site.Params.home.highlights }}
              <div class="stat">
                <strong>{{ .title }}</strong>
                <span>{{ .text }}</span>
              </div>
            {{ end }}
          </div>
        </aside>
      </div>
    </div>
  </section>
EOF

# 5) about.html
cat > "${PARTIALS_DIR}/about.html" <<'EOF'
<section id="about" class="section">
  <div class="wrap">
    <h2>{{ .Site.Params.home.aboutTitle | default "About" }}</h2>
    <div class="panel pad">
      <p>{{ .Site.Params.home.aboutP1 }}</p>
      <p>{{ .Site.Params.home.aboutP2 }}</p>

      <div style="margin-top:12px; display:flex; flex-wrap:wrap; gap:10px;">
        {{ range .Site.Params.home.aboutPills }}
          <span class="pill">{{ . }}</span>
        {{ end }}
      </div>
    </div>
  </div>
</section>
EOF

# 6) case.html
cat > "${PARTIALS_DIR}/case.html" <<'EOF'
<section id="why" class="section">
  <div class="wrap">
    <h2>{{ .Site.Params.home.caseTitle | default "Our case in a nutshell" }}</h2>
    <p>{{ .Site.Params.home.caseIntro }}</p>

    <div class="cards" role="list">
      {{ range .Site.Params.home.casePoints }}
        <div class="card" role="listitem">
          <h3>{{ .title }}</h3>
          <p>{{ .text }}</p>
        </div>
      {{ end }}
    </div>
  </div>
</section>
EOF

# 7) how.html
cat > "${PARTIALS_DIR}/how.html" <<'EOF'
<section id="how" class="section">
  <div class="wrap">
    <h2>{{ .Site.Params.home.howTitle | default "How a citizen initiative process works" }}</h2>
    <p>{{ .Site.Params.home.howIntro }}</p>

    <div class="two-col">
      {{ range .Site.Params.home.howBlocks }}
        <div class="panel pad">
          <h3 style="margin:0 0 8px;">{{ .title }}</h3>
          {{ range (split .text "\n\n") }}
            <p>{{ . }}</p>
          {{ end }}
        </div>
      {{ end }}
    </div>
  </div>
</section>
EOF

# 8) involved.html
cat > "${PARTIALS_DIR}/involved.html" <<'EOF'
<section id="help" class="section">
  <div class="wrap">
    <h2>{{ .Site.Params.home.involvedTitle | default "Get involved" }}</h2>
    <p>{{ .Site.Params.home.involvedIntro }}</p>

    <div class="two-col">
      <div class="panel pad">
        <h3 style="margin:0 0 8px;">{{ .Site.Params.home.joinTitle | default "Join updates" }}</h3>
        <p>{{ .Site.Params.home.joinText }}</p>

        {{ $action := .Site.Params.home.joinFormAction }}
        {{ if $action }}
          <form method="post" action="{{ $action }}" aria-label="Email signup form">
            <label for="email" class="tiny">Email address</label><br />
            <div style="display:flex; gap:10px; margin-top:8px; flex-wrap:wrap;">
              <input id="email" name="email" type="email" required
                     placeholder="you@example.com"
                     style="flex:1; min-width:240px; padding:12px 12px; border-radius:12px; border:1px solid rgba(255,255,255,0.14); background:rgba(0,0,0,0.25); color:var(--text);" />
              <button class="btn primary" type="submit">Sign up</button>
            </div>
            <p class="tiny" style="margin-top:10px;">{{ .Site.Params.home.joinPrivacyNote }}</p>
          </form>
        {{ else }}
          <p class="tiny" style="margin-top:10px;">Signup form not configured yet.</p>
          <p class="tiny" style="margin-top:10px;">{{ .Site.Params.home.joinPrivacyNote }}</p>
        {{ end }}
      </div>

      <div class="panel pad">
        <h3 style="margin:0 0 8px;">{{ .Site.Params.home.volunteerTitle | default "Volunteer" }}</h3>
        <p>{{ .Site.Params.home.volunteerText }}</p>

        {{ $email := .Site.Params.contactEmail | default "info@letmdvote.com" }}
        <p class="tiny">Email: <a class="underline" href="mailto:{{ $email }}">{{ $email }}</a></p>

        <div style="margin-top:12px; display:flex; flex-wrap:wrap; gap:10px;">
          <a class="btn" href="{{ .Site.Params.home.volunteerPrimaryHref }}">{{ .Site.Params.home.volunteerPrimaryLabel }}</a>
          <a class="btn" href="{{ .Site.Params.home.volunteerSecondaryHref }}">{{ .Site.Params.home.volunteerSecondaryLabel }}</a>
        </div>
      </div>
    </div>

    <div class="panel pad" style="margin-top:14px;">
      <h3 style="margin:0 0 8px;">{{ .Site.Params.home.govTitle | default "Local governments" }}</h3>
      <p>{{ .Site.Params.home.govText }}</p>
      <a class="btn" href="{{ .Site.Params.home.govCtaHref }}">{{ .Site.Params.home.govCtaLabel }}</a>
    </div>
  </div>
</section>
EOF

# 9) faq.html
cat > "${PARTIALS_DIR}/faq.html" <<'EOF'
<section id="faq" class="section">
  <div class="wrap">
    <h2>{{ .Site.Params.home.faqTitle | default "FAQ" }}</h2>

    <div class="panel pad">
      {{ range .Site.Params.home.faq }}
        <details>
          <summary>{{ .q }}</summary>
          <p>{{ .a }}</p>
        </details>
      {{ end }}
    </div>
  </div>
</section>
EOF

# 10) principle.html
cat > "${PARTIALS_DIR}/principle.html" <<'EOF'
<section class="section">
  <div class="wrap">
    <div class="panel pad">
      <h2 style="margin-top:0;">{{ .Site.Params.home.principleTitle | default "A simple principle" }}</h2>
      <p style="margin-bottom:0;">{{ .Site.Params.home.principleText }}</p>
    </div>
  </div>
</section>
</main>
EOF

# 11) footer.html (use Hugo now.Year instead of JS)
cat > "${PARTIALS_DIR}/footer.html" <<'EOF'
<footer role="contentinfo">
  <div class="wrap">
    <div class="footer-grid">
      <div>
        <strong style="color:var(--text);">{{ .Site.Params.siteName | default .Site.Title }}</strong><br />
        <span class="tiny">{{ .Site.Params.siteTagline | default "" }}</span><br /><br />
        {{ $email := .Site.Params.contactEmail | default "info@letmdvote.com" }}
        <span class="tiny">Contact: <a class="underline" href="mailto:{{ $email }}">{{ $email }}</a></span>
      </div>
      <div style="text-align:right;">
        <span class="tiny">© {{ now.Year }} {{ .Site.Params.siteName | default .Site.Title }}</span><br />
        <span class="tiny">Built for mobile, tablet, and desktop.</span>
      </div>
    </div>
  </div>
</footer>
EOF

echo ""
echo "Done."
echo ""
echo "Next steps:"
echo "1) Put a hero image at: static/images/hero.jpg (or set params.home.heroImage.src in hugo.toml)."
echo "2) Ensure your hugo.toml includes the params we used (siteName, siteTagline, contactEmail, and params.home blocks)."
echo ""
echo "Run: hugo server -D"
