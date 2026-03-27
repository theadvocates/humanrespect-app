#!/bin/bash
# Fix AI writing tells across all content
# macOS compatible (uses sed -i '')
# Run from humanrespect-app/ root

set -e

echo "✏️  Fixing AI writing patterns..."

# ══════════════════════════════════════
# PRIORITY 1: "Not X, it's Y" constructions
# ══════════════════════════════════════

# #1 pillarD/Opening.vue
sed -i '' "s|asks isn't <em>what</em> you value — it's how you propose to advance it|asks how you propose to advance what you value|" src/components/experiences/pillarD/Opening.vue 2>/dev/null && echo "  ✅ #1" || echo "  ⚠ #1 not found"

# #2 pillarC/TheConnection.vue
sed -i '' "s|This is why property isn't about materialism. It's about respecting the time|Property matters because it represents the time|" src/components/experiences/pillarC/TheConnection.vue 2>/dev/null && echo "  ✅ #2" || echo "  ⚠ #2 not found"

# #3 pillarC/TheftAsLifeTheft.vue
sed -i '' "s|It's not about the thing. It's about the implicit claim that someone else has a right to the hours of your life you invested in earning it.|The violation runs deeper than the object. Someone is claiming a right to the hours of your life you invested in earning it.|" src/components/experiences/pillarC/TheftAsLifeTheft.vue 2>/dev/null && echo "  ✅ #3" || echo "  ⚠ #3 not found"

# #4 pillarC/Opening.vue
sed -i '' "s|Your property isn't stuff. It's the physical form of hours|Your property represents hours|" src/components/experiences/pillarC/Opening.vue 2>/dev/null && echo "  ✅ #4" || echo "  ⚠ #4 not found"

# #5 pillarB/TheReframe.vue headline
sed -i '' "s|Property isn't about stuff. It's about time.|Property is time made physical.|" src/components/experiences/pillarB/TheReframe.vue 2>/dev/null && echo "  ✅ #5" || echo "  ⚠ #5 not found"

# #6 pillarB/TheReframe.vue body
sed -i '' "s|It's not about materialism or greed. It's about the recognition that your|Your|" src/components/experiences/pillarB/TheReframe.vue 2>/dev/null && echo "  ✅ #6" || echo "  ⚠ #6 not found"

# #7 pillarB/TheRecognition.vue
sed -i '' "s|The question isn't whether society needs coordination. It's whether|Society needs coordination. The question is whether|" src/components/experiences/pillarB/TheRecognition.vue 2>/dev/null && echo "  ✅ #7" || echo "  ⚠ #7 not found"

# #8 pillarE/Opening.vue
sed -i '' "s|Voluntary cooperation isn't just morally superior to coercion. It's more|Voluntary cooperation outperforms coercion. It's more|" src/components/experiences/pillarE/Opening.vue 2>/dev/null && echo "  ✅ #8" || echo "  ⚠ #8 not found"

# #9 exp01/CommonGround.vue
sed -i '' "s|This isn't a sentimental idea. It's observation.|This is observation, not sentiment.|" src/components/experiences/exp01/CommonGround.vue 2>/dev/null && echo "  ✅ #9" || echo "  ⚠ #9 not found"

# #10 exp01/Invitation.vue
sed -i '' "s|This isn't a question that gets answered in five minutes. It's a question that changes|This question doesn't get answered in five minutes. It changes|" src/components/experiences/exp01/Invitation.vue 2>/dev/null && echo "  ✅ #10" || echo "  ⚠ #10 not found"

# #11 practice04/TheCommitment.vue
sed -i '' "s|isn't something you adopt in a moment. It's something you discover gradually|is not adopted in a moment. You discover it gradually|" src/components/experiences/practice04/TheCommitment.vue 2>/dev/null && echo "  ✅ #11" || echo "  ⚠ #11 not found"

# #12 practice03/TheFramework.vue
sed -i '' "s|The goal isn't to win. It's to plant|The goal is to plant|" src/components/experiences/practice03/TheFramework.vue 2>/dev/null && echo "  ✅ #12" || echo "  ⚠ #12 not found"

# #13a pillarD/YourValues.vue (progressive)
sed -i '' "s|The next question isn't about <em>whether</em> these values are right — it's about <em>how</em> to advance them.|The question ahead is <em>how</em> to advance them.|g" src/components/experiences/pillarD/YourValues.vue 2>/dev/null && echo "  ✅ #13" || echo "  ⚠ #13 not found"

# #14 practice01/YourFootprint.vue
sed -i '' "s|That's not a political position — it's a measurement.|That's a measurement, not a political position.|" src/components/experiences/practice01/YourFootprint.vue 2>/dev/null && echo "  ✅ #14" || echo "  ⚠ #14 not found"

echo ""
echo "── Priority 2: 'This is' sentence starters ──"

# #16 pillarC/TheftAsLifeTheft.vue
sed -i '' "s|This is why even small acts of theft feel violating|Even small acts of theft feel violating|" src/components/experiences/pillarC/TheftAsLifeTheft.vue 2>/dev/null && echo "  ✅ #16" || echo "  ⚠ #16 not found"

# #17 pillarB/TheHierarchy.vue
sed -i '' "s|This is why coercion — the theft of time — is the deepest violation. No payment|Coercion is the deepest violation because no payment|" src/components/experiences/pillarB/TheHierarchy.vue 2>/dev/null && echo "  ✅ #17" || echo "  ⚠ #17 not found"

# #18 exp01/ThePrinciple.vue
sed -i '' "s|This is what the thought experiment was pointing toward. A statement|The thought experiment points toward a statement|" src/components/experiences/exp01/ThePrinciple.vue 2>/dev/null && echo "  ✅ #18" || echo "  ⚠ #18 not found"

# #19 pillarA/TheCascade.vue
sed -i '' "s|This is why societies with high levels of violence are invariably poor|Societies with high levels of violence are invariably poor|" src/components/experiences/pillarA/TheCascade.vue 2>/dev/null && echo "  ✅ #19" || echo "  ⚠ #19 not found"

# #20 pillarA/TheMemory.vue
sed -i '' "s|This is why bodily safety isn't just one nice thing among many. It is the|Bodily safety is the|" src/components/experiences/pillarA/TheMemory.vue 2>/dev/null && echo "  ✅ #20" || echo "  ⚠ #20 not found"

# #21 exp03/TheGrounding.vue headline
sed -i '' 's|This is what the Philosophy of Human Respect is actually saying.|What the Philosophy of Human Respect is actually saying.|' src/components/experiences/exp03/TheGrounding.vue 2>/dev/null && echo "  ✅ #21" || echo "  ⚠ #21 not found"

# #21b Also fix in FlourishingPrinciple.vue if it exists
sed -i '' 's|This is what the Philosophy of Human Respect is actually saying.|What the Philosophy of Human Respect is actually saying.|' src/components/experiences/exp03/FlourishingPrinciple.vue 2>/dev/null || true

# #22 exp03/TheGrounding.vue body
sed -i '' "s|This is a statement about cause and effect|A statement about cause and effect|" src/components/experiences/exp03/TheGrounding.vue 2>/dev/null && echo "  ✅ #22" || echo "  ⚠ #22 not found"

echo ""
echo "── Priority 3: Flagged words ──"

# #23 "genuinely hard" → "hard. Really hard."
sed -i '' "s|This is genuinely hard.|This is hard. Really hard.|" src/components/experiences/pillarD/TheQuestion.vue 2>/dev/null && echo "  ✅ #23" || echo "  ⚠ #23 not found"

# #25 "implications are profound" → "implications run deep"
sed -i '' "s|the implications are profound|the implications run deep|" src/components/experiences/exp01/WhyTheGap.vue 2>/dev/null && echo "  ✅ #25" || echo "  ⚠ #25 not found"

# #26 "temptation to use force is powerful" → "is real"
sed -i '' "s|the temptation to use force is powerful|the temptation to use force is real|" src/components/experiences/pillarD/TheQuestion.vue 2>/dev/null && echo "  ✅ #26" || echo "  ⚠ #26 not found"

# #28 "looks fundamentally different" → "looks different"
sed -i '' "s|looks fundamentally different|looks different|" src/components/experiences/pillarB/TheQuestion.vue 2>/dev/null && echo "  ✅ #28" || echo "  ⚠ #28 not found"

# #30 "transforms a conflict machine" → "turns a conflict machine"
sed -i '' "s|transforms a conflict machine|turns a conflict machine|" src/components/experiences/pillarD/TheReframe.vue 2>/dev/null && echo "  ✅ #30" || echo "  ⚠ #30 not found"

echo ""
echo "── Priority 4: 'In other words' ──"

# #31-32
sed -i '' "s|In other words: you want|You want|g" src/components/experiences/pillarD/TheMirror.vue 2>/dev/null && echo "  ✅ #31-32" || echo "  ⚠ #31-32 not found"

echo ""
echo "── Priority 5: Worst em dash offenders ──"

# #33 pillarD/TheQuestion.vue - comma instead of dash
sed -i '' "s|as much as the goal — and a world|as much as the goal, and a world|" src/components/experiences/pillarD/TheQuestion.vue 2>/dev/null && echo "  ✅ #33" || echo "  ⚠ #33 not found"

# #34 pillarD/TheQuestion.vue - simplify double-dash sentence
sed -i '' "s|even for the causes you care about most.|especially for the causes you care about most.|" src/components/experiences/pillarD/TheQuestion.vue 2>/dev/null && echo "  ✅ #34" || echo "  ⚠ #34 not found"

# #35 pillarA/TheCascade.vue - replace isn't...it's
sed -i '' "s|The relationship isn't coincidental — it's causal.|The relationship is causal.|" src/components/experiences/pillarA/TheCascade.vue 2>/dev/null && echo "  ✅ #35" || echo "  ⚠ #35 not found"

echo ""
echo "✅ All fixes applied!"
echo ""
echo "IMPORTANT: Test the build before pushing:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'copy: remove AI writing tells' && git push"
