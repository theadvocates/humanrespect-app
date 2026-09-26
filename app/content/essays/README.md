# The written arguments

One file per experience, named for its id in `app/utils/experiences.js`.

## Why these exist

Every experience on this site is a multi-screen component that mounts one
screen at a time. Screen 0 is the Opening — a title, a line of setup, and a
button. That is the entire server-rendered output.

So a crawler arriving at `/pillar/your-time-is-your-life` reads 54 words. The
other 800 exist only after a human clicks Continue five times. Fifteen pages
of real philosophical argument were, as far as any search engine was
concerned, blank. That is the actual reason the site does not rank for its
own subject.

The second reason is the one people said out loud: seven minutes of clicking
through screens is a lot to ask of someone who has not yet decided the
argument is worth their time, and the honest answer to "this is too long" is
not always to make it shorter. Sometimes it is to offer a different shape.

So each experience page now carries the same argument twice: as the
interactive module, and — below it, always rendered — as an essay you can
read in three minutes. Same URL, so there is no thin page competing with a
rich one for the same subject, and every existing link points at the richer
version.

## Shape

```js
export default {
  standfirst: 'One or two sentences under the title.',
  sections: [
    { heading: 'A sentence-case heading', body: ['A paragraph.', 'Another.'] }
  ]
}
```

`body` entries are paragraphs. A string wrapped in `**` is rendered as a
pull-quote rather than a paragraph — used sparingly, for the one line in an
essay that the whole essay is built around.

## Writing them

These are read by people who disagree, arriving from a link someone sent
them. That sets the register:

- Second person, present tense, plain words. No exclamation marks.
- Concede what the sources concede — a transition takes time; the principle
  promises conditions, not outcomes — and nothing else. Never the objection's
  premise, and never the principle itself. A concession is a sentence, not a
  paragraph, and no essay ends on one.
- Never assert that the reader already agrees. Show the reasoning and let
  them arrive.
- The pull-quote is the claim, not a summary of the claim.
- No calls to action. The page has those already.

Reading time is derived, not stored: `readingMinutes` in
`app/utils/reading.js` counts the body words at ~220 words per minute,
rounded to the nearest minute and floored at two. Do not add a `minutes`
field — `test/essays.test.js` fails on one, because every hand-written
estimate drifted from what was actually written. The time is shown before
the essay for the same reason the experiences show theirs: an unlabeled time
cost is what makes a short read feel expensive.
