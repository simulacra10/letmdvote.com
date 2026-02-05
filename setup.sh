#!/usr/bin/env bash
set -euo pipefail

# scaffold_hugo_homepage.sh
# Run from the root of your Hugo project.
# This script creates the layout directory structure and fills in templates.
# It intentionally overwrites the scaffolded files to ensure correctness.

echo "Scaffolding Hugo homepage layout (hero image version)..."

mkdir -p layouts/_default layouts/partials/sections

cat > layouts/_default/baseof.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{ .Site.Title }}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
  {{ block "main" . }}{{ end }}
</body>
</html>
EOF

cat > layouts/index.html <<'EOF'
{{ define "main" }}
  {{ partial "sections/hero.html" . }}
  {{ partial "sections/features.html" . }}
  {{ partial "sections/about.html" . }}
  {{ partial "sections/case.html" . }}
  {{ partial "sections/how.html" . }}
  {{ partial "sections/involved.html" . }}
  {{ partial "sections/faq.html" . }}
  {{ partial "sections/principle.html" . }}
  {{ partial "sections/footer.html" . }}
{{ end }}
EOF

cat > layouts/partials/sections/hero.html <<'EOF'
<header id="top">
  <nav>
    <div>
      <strong>{{ .Site.Params.siteName }}</strong>
      <span>{{ .Site.Params.siteTagline }}</span>
    </div>

    <ul>
      {{ range $label := .Site.Params.home.nav }}
        <li><a href="#{{ anchorize $label }}">{{ $label }}</a></li>
      {{ end }}
    </ul>

    <div>
      <a href="#join-updates">Join updates</a>
      <a href="#volunteer">Volunteer</a>
    </div>
  </nav>

  <section class="hero">
    <img
      src="{{ .Site.Params.home.heroImage.src }}"
      alt="{{ .Site.Params.home.heroImage.alt }}"
      loading="eager"
    >

    {{ if .Site.Params.home.heroImage.overlay }}
      <div class="hero-overlay">
        <h1>{{ .Site.Params.home.heroImage.overlayText }}</h1>

        <div class="hero-actions">
          {{ range .Site.Params.home.heroButtons }}
            <a href="{{ .href }}">{{ .label }}</a>
          {{ end }}
        </div>

        <p class="hero-badges">
          {{ range .Site.Params.home.heroBadges }}
            <span>{{ . }}</span>
          {{ end }}
        </p>
      </div>
    {{ end }}
  </section>
</header>
EOF

cat > layouts/partials/sections/features.html <<'EOF'
<section>
  {{ range .Site.Params.home.highlights }}
    <div>
      <h3>{{ .title }}</h3>
      <p>{{ .text }}</p>
    </div>
  {{ end }}
</section>
EOF

cat > layouts/partials/sections/about.html <<'EOF'
<section id="{{ anchorize .Site.Params.home.aboutTitle }}">
  <h2>{{ .Site.Params.home.aboutTitle }}</h2>
  <p>{{ .Site.Params.home.aboutP1 }}</p>
  <p>{{ .Site.Params.home.aboutP2 }}</p>

  <ul>
    {{ range .Site.Params.home.aboutPills }}
      <li>{{ . }}</li>
    {{ end }}
  </ul>
</section>
EOF

cat > layouts/partials/sections/case.html <<'EOF'
<section id="{{ anchorize .Site.Params.home.caseTitle }}">
  <h2>{{ .Site.Params.home.caseTitle }}</h2>
  <p>{{ .Site.Params.home.caseIntro }}</p>

  {{ range .Site.Params.home.casePoints }}
    <div>
      <h3>{{ .title }}</h3>
      <p>{{ .text }}</p>
    </div>
  {{ end }}
</section>
EOF

cat > layouts/partials/sections/how.html <<'EOF'
<section id="how-it-works">
  <h2>{{ .Site.Params.home.howTitle }}</h2>
  <p>{{ .Site.Params.home.howIntro }}</p>

  {{ range .Site.Params.home.howBlocks }}
    <div>
      <h3>{{ .title }}</h3>
      {{ range (split .text "\n\n") }}
        <p>{{ . }}</p>
      {{ end }}
    </div>
  {{ end }}
</section>
EOF

cat > layouts/partials/sections/involved.html <<'EOF'
<section id="get-involved">
  <h2>{{ .Site.Params.home.involvedTitle }}</h2>
  <p>{{ .Site.Params.home.involvedIntro }}</p>

  <div id="join-updates">
    <h3>{{ .Site.Params.home.joinTitle }}</h3>
    <p>{{ .Site.Params.home.joinText }}</p>

    {{ $action := .Site.Params.home.joinFormAction }}
    {{ if $action }}
      <form action="{{ $action }}" method="post">
        <label>
          Email address
          <input type="email" name="email" required>
        </label>
        <button type="submit">Sign up</button>
      </form>
    {{ else }}
      <p><em>Signup form not configured yet.</em></p>
    {{ end }}

    <p>{{ .Site.Params.home.joinPrivacyNote }}</p>
  </div>

  <div id="volunteer">
    <h3>{{ .Site.Params.home.volunteerTitle }}</h3>
    <p>{{ .Site.Params.home.volunteerText }}</p>
    <p>Email: <a href="mailto:{{ .Site.Params.contactEmail }}">{{ .Site.Params.contactEmail }}</a></p>

    <p>
      <a href="{{ .Site.Params.home.volunteerPrimaryHref }}">{{ .Site.Params.home.volunteerPrimaryLabel }}</a>
      <a href="{{ .Site.Params.home.volunteerSecondaryHref }}">{{ .Site.Params.home.volunteerSecondaryLabel }}</a>
    </p>
  </div>

  <div id="local-governments">
    <h3>{{ .Site.Params.home.govTitle }}</h3>
    <p>{{ .Site.Params.home.govText }}</p>
    <p><a href="{{ .Site.Params.home.govCtaHref }}">{{ .Site.Params.home.govCtaLabel }}</a></p>
  </div>
</section>
EOF

cat > layouts/partials/sections/faq.html <<'EOF'
<section id="faq">
  <h2>{{ .Site.Params.home.faqTitle }}</h2>

  {{ range .Site.Params.home.faq }}
    <details>
      <summary>{{ .q }}</summary>
      <p>{{ .a }}</p>
    </details>
  {{ end }}
</section>
EOF

cat > layouts/partials/sections/principle.html <<'EOF'
<section id="principle">
  <h2>{{ .Site.Params.home.principleTitle }}</h2>
  <p>{{ .Site.Params.home.principleText }}</p>
</section>
EOF

cat > layouts/partials/sections/footer.html <<'EOF'
<footer>
  <div>
    <strong>{{ .Site.Params.siteName }}</strong>
    <span>{{ .Site.Params.siteTagline }}</span>
  </div>

  <p>Contact: <a href="mailto:{{ .Site.Params.contactEmail }}">{{ .Site.Params.contactEmail }}</a></p>
  <p>{{ .Site.Params.footerCopyright }}</p>
</footer>
EOF

cat <<'EOF'

Done.

Config reminder: add this to config.toml under [params.home]:

  [params.home.heroImage]
    src = "/images/hero.jpg"
    alt = "Maryland State House dome at sunset"
    overlay = true
    overlayText = "Let Marylanders propose and vote on questions that matter."

And place your hero image at: static/images/hero.jpg

EOF
