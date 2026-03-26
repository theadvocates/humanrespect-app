#!/bin/bash
# Verification audit: check that all intended changes are in the codebase
# Run from humanrespect-app/ root
# This doesn't change anything — it just reports what's present vs missing

echo "🔍 Verifying all changes..."
echo ""

PASS=0
FAIL=0

check() {
  local label="$1"
  local pattern="$2"
  local search_path="$3"
  local should_exist="$4" # "yes" = pattern should be found, "no" = should NOT be found

  if [ "$should_exist" = "yes" ]; then
    if grep -rq "$pattern" $search_path 2>/dev/null; then
      echo "  ✅ $label"
      PASS=$((PASS + 1))
    else
      echo "  ❌ $label — NOT FOUND"
      FAIL=$((FAIL + 1))
    fi
  else
    if grep -rq "$pattern" $search_path 2>/dev/null; then
      echo "  ❌ $label — STILL PRESENT (should be removed)"
      FAIL=$((FAIL + 1))
    else
      echo "  ✅ $label (removed)"
      PASS=$((PASS + 1))
    fi
  fi
}

echo "═══ COPY EDITS ═══"
echo ""

echo "Fix #1/#12: Philanthropy updated to 2024"
check "Has 592.5 billion or 592.50" "\$592" src/components/experiences/pillarE/ yes
check "No more 557 billion" "557 billion" src/components/experiences/pillarE/ no

echo ""
echo "Fix #2: Flourishing Principle in Exp01"
check "Exp01 ThePrinciple uses 'reliably increases'" "reliably increases" src/components/experiences/exp01/ThePrinciple.vue yes
check "Old NAP wording removed from Exp01" "always decrease as persons" src/components/experiences/exp01/ no

echo ""
echo "Fix #4: Effect framed as philosophy's claim"
check "TheDeeperQuestion exists" "The philosophy holds that" src/components/experiences/exp01/TheDeeperQuestion.vue yes

echo ""
echo "Fix #5: Social contract steelman includes Rawls"
check "Rawls mentioned in objection data" "Rawls" src/components/experiences/exp02/objectionData.js yes

echo ""
echo "Fix #6: Mutual aid nuance"
check "Depression mentioned" "Depression" src/components/experiences/exp02/objectionData.js yes
check "Imperfect acknowledged" "imperfect" src/components/experiences/exp02/objectionData.js yes

echo ""
echo "Fix #7: Slavery replaced with Jim Crow"
check "Jim Crow present" "Jim Crow" src/components/experiences/exp02/objectionData.js yes
check "Japanese internment present" "Japanese internment" src/components/experiences/exp02/objectionData.js yes
check "Slavery comparison removed" "Slavery was democratically" src/components/experiences/exp02/objectionData.js no

echo ""
echo "Fix #8: Values/method reworked in Pillar D"
check "Acknowledges real value disagreements" "genuinely disagree on values" src/components/experiences/pillarD/TheQuestion.vue yes
check "Old absolute claim removed" "not really about values" src/components/experiences/pillarD/TheQuestion.vue no

echo ""
echo "Fix #9: Condescending preemption removed"
check "No 'you may have seen where this was headed'" "you may have seen where this was headed" src/components/experiences/exp01/ no

echo ""
echo "Fix #10: Accusatory closing question softened"
check "No 'what's stopping you from helping her'" "what.*stopping you from helping" src/components/experiences/exp02/objectionData.js no

echo ""
echo "Fix #11: Reduced 'this isn't political' repetitions"
check "Exp03 TheGrounding uses 'cause and effect'" "statement about cause and effect" src/components/experiences/exp03/TheGrounding.vue yes
check "No 'This isn't a political ideology' in Exp01" "not a political ideology" src/components/experiences/exp01/ no

echo ""
echo "Fix #15: Stranger on the street"
check "No 'stranger on the bus'" "stranger on the bus" src/ no
check "Has 'stranger you passed on the street'" "stranger you passed on the street" src/ yes

echo ""
echo "Fix #16: Rephrased 'this isn't X, it's Y' in Exp03"
check "Exp03 uses 'Other moral frameworks'" "Other moral frameworks" src/components/experiences/exp03/TheGrounding.vue yes

echo ""
echo "Fix #17: Pillar B calculator note"
check "40-hour work week note" "40-hour work week" src/components/experiences/pillarB/ yes

echo ""
echo "═══ UX IMPROVEMENTS ═══"
echo ""

echo "Exp02: YourVerdict screen"
check "YourVerdict.vue exists" "Your assessment" src/components/experiences/exp02/YourVerdict.vue yes
check "Experience02 imports YourVerdict" "YourVerdict" src/pages/Experience02.vue yes
check "Exp02 has 8 total screens" 'total="8"' src/components/experiences/exp02/ yes

echo ""
echo "Practice01: Interactive footprint"
check "YourFootprint.vue exists" "footprint-visual" src/components/experiences/practice01/YourFootprint.vue yes
check "Practice01 page imports YourFootprint" "YourFootprint" src/pages/Practice01.vue yes
check "Categorized checklist" "Your money" src/components/experiences/practice01/TheMapping.vue yes

echo ""
echo "Milestone page"
check "MilestonePage.vue exists" "Foundation complete" src/pages/MilestonePage.vue yes
check "Milestone route in router" "milestone" src/router/index.js yes
check "Milestone in route meta" "milestone" src/router/meta.js yes
check "Exp03 TheBridge links to milestone" "milestone" src/components/experiences/exp03/TheBridge.vue yes

echo ""
echo "═══ STYLING / POLISH ═══"
echo ""

echo "Dark mode"
check "Typography has dark mode weight 500" "font-weight: 500" src/styles/typography.css yes
check "Dark mode text color #F0EBE3" "F0EBE3" src/styles/typography.css yes

echo ""
echo "Mobile"
check "mobile.css exists" "tap-highlight" src/styles/mobile.css yes
check "animations.css exists" "stagger" src/styles/animations.css yes
check "mobile.css imported in main.js" "mobile.css" src/main.js yes

echo ""
echo "Performance"
check "display=swap on Google Fonts" "display=swap" index.html yes
check "_redirects file exists" "index.html" public/_redirects yes
check "robots.txt exists" "User-agent" public/robots.txt yes

echo ""
echo "═══ NAVIGATION ═══"
echo ""

echo "SiteNav"
check "SiteNav.vue exists" "site-nav" src/components/shared/SiteNav.vue yes
check "App.vue imports SiteNav" "SiteNav" src/App.vue yes

echo ""
echo "JourneyNav"
check "JourneyNav.vue has recommended prop" "recommended" src/components/shared/JourneyNav.vue yes
check "PathCard has completed + recommended props" "recommended.*Boolean" src/components/shared/PathCard.vue yes

echo ""
echo "═══ NEWSLETTER ═══"
echo ""
check "NewsletterSignup has Buttondown integration" "buttondown" src/components/shared/NewsletterSignup.vue yes
check "Exp01 does NOT have newsletter (removed)" "NewsletterSignup" src/components/experiences/exp01/Invitation.vue no
check "Exp03 has newsletter" "NewsletterSignup" src/components/experiences/exp03/TheBridge.vue yes

echo ""
echo "═══ META / OG ═══"
echo ""
check "OG image meta tag" "og-default.png" index.html yes
check "Twitter card meta" "summary_large_image" index.html yes
check "Route meta file exists" "routeMeta" src/router/meta.js yes
check "Router uses afterEach for meta" "afterEach" src/router/index.js yes
check "og-default.png in public" "" public/og-default.png yes

echo ""
echo "═══ ABOUT / PRIVACY ═══"
echo ""
check "AboutPage.vue exists" "Why this exists" src/pages/AboutPage.vue yes
check "About has Morning Star proof section" "Morning Star" src/pages/AboutPage.vue yes
check "PrivacyPage.vue exists" "How we handle your data" src/pages/PrivacyPage.vue yes
check "Privacy mentions Cloudflare Web Analytics" "Cloudflare" src/pages/PrivacyPage.vue yes

echo ""
echo "═══ FAVICON ═══"
echo ""
if [ -f "public/favicon.ico" ]; then
  echo "  ✅ favicon.ico in public/"
  PASS=$((PASS + 1))
else
  echo "  ❌ favicon.ico NOT in public/"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "═══════════════════════"
echo "Results: $PASS passed, $FAIL failed"
echo "═══════════════════════"

if [ $FAIL -gt 0 ]; then
  echo ""
  echo "Run this to find files that need manual fixes:"
  echo "  grep -rn 'stranger on the bus' src/"
  echo "  grep -rn 'always decrease as persons' src/"
  echo "  grep -rn 'not a political ideology' src/"
  echo "  grep -rn '557 billion' src/"
fi
