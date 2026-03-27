#!/bin/bash
# Scan all Vue component content for AI writing tells
# Run from humanrespect-app/ root

echo "🔍 Scanning for AI writing patterns..."
echo ""

# Helper function
scan() {
  local label="$1"
  local pattern="$2"
  local results=$(grep -rni "$pattern" src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "import \|export \|const \|function \|class=" | grep -v "script setup\|style scoped")
  local count=$(echo "$results" | grep -c . 2>/dev/null)
  if [ "$count" -gt 0 ] && [ -n "$results" ]; then
    echo "=== $label ($count) ==="
    echo "$results"
    echo ""
  fi
}

echo "── EM DASHES ──"
# Search for the actual em dash character
grep -rn '—' src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "import \|export \|const \|function " | grep -v "script setup\|style scoped\|arrow" | head -40
echo ""

echo "── 'NOT X, IT'S Y' CONSTRUCTIONS ──"
grep -rni "isn.t.*it.s\|is not.*it is\|not about.*it.s about\|not a.*it.s a" src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "import \|export \|const \|function " | grep -v "script setup\|style scoped" | head -20
echo ""

echo "── 'NOT X — Y' WITH DASHES ──"
grep -rn 'not.*—\|Not.*—' src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "import \|export \|const \|function " | grep -v "script setup\|style scoped" | head -20
echo ""

scan "GENUINELY" "genuinely"
scan "PROFOUND" "profound"
scan "POWERFUL" "powerful"
scan "REMARKABLE" "remarkably\|remarkable"
scan "STRAIGHTFORWARD" "straightforward"
scan "FUNDAMENTALLY" "fundamentally"
scan "IT'S WORTH / WORTH NOTING" "it.s worth\|worth noting\|worth sitting"
scan "HERE'S THE THING / HERE'S WHAT" "here.s the thing\|here.s what"
scan "THE REALITY IS / IN REALITY" "the reality is\|the truth is\|in reality"
scan "SIMPLY / SIMPLY PUT" "simply put\|put simply\|simply asks\|the philosophy simply\|simply about"
scan "TRANSFORMS / TRANSFORMATIVE" "transforms\|transformative"
scan "LANDSCAPE" "landscape"
scan "NAVIGATE" "navigate"
scan "LEVERAGE" "leverage"
scan "RESONATE / RESONATES" "resonate"
scan "DELVE / DELVING" "delve\|delving"
scan "FOSTER / FOSTERING" "foster"
scan "CRUCIAL" "crucial"
scan "PIVOTAL" "pivotal"
scan "GAME-CHANGER / GAME CHANGER" "game.changer"
scan "AT ITS CORE" "at its core"
scan "AT THE END OF THE DAY" "at the end of the day"
scan "IN OTHER WORDS" "in other words"
scan "MAKE NO MISTAKE" "make no mistake"
scan "IT BEARS MENTIONING" "it bears\|bears mentioning"
scan "LET'S BE CLEAR / TO BE CLEAR" "let.s be clear\|to be clear"

echo ""
echo "── OVERUSED SENTENCE STARTERS ──"
echo "(Sentences starting with 'This is' or 'That's')"
grep -rn '^\s*<p[^>]*>This is \|>This is ' src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "script\|style" | head -15
echo ""
grep -rn "That.s " src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "script\|style" | head -15
echo ""

echo "── REPETITIVE PATTERNS ──"
echo "(Multiple 'Not because...Because' constructions)"
grep -rn "Not because" src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "script\|style" | head -10
echo ""

echo "── COLON-HEAVY CONSTRUCTIONS ──"
echo "(Sentences with colons used for dramatic effect)"
grep -rn ':[^/<"=]' src/components/ src/pages/ 2>/dev/null | grep -v "node_modules\|\.js:" | grep -v "script\|style\|http\|class=\|src=\|href=" | grep -v "import\|export\|const\|function\|margin\|padding\|font\|color\|background\|border\|display\|width\|height" | head -20
echo ""

echo "Done. Review each section above and note items to fix."
