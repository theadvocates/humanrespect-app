// Tells search engines that support IndexNow (Bing, Yandex, Seznam, Naver)
// that the site's pages have changed, so they fetch them now instead of on
// their own schedule. Google does not take part.
//
// Run after a production deploy. It reads the live sitemap, so whatever the
// sitemap lists is what gets submitted; there is no second list to keep in
// step. The key file in public/ proves to the engines that this site sent it.
//
//   node scripts/indexnow.mjs

import { readdirSync } from 'node:fs'

const SITE = 'https://humanrespect.app'
const keyFile = readdirSync(new URL('../public/', import.meta.url)).find((f) => /^[a-f0-9]{32}\.txt$/.test(f))
if (!keyFile) throw new Error('No IndexNow key file in public/')
const key = keyFile.slice(0, -4)

const sitemap = await (await fetch(`${SITE}/sitemap.xml`)).text()
const urlList = [...sitemap.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1])
if (!urlList.length) throw new Error('The live sitemap lists no pages')

const res = await fetch('https://api.indexnow.org/indexnow', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json; charset=utf-8' },
  body: JSON.stringify({ host: new URL(SITE).host, key, keyLocation: `${SITE}/${keyFile}`, urlList })
})
// 200 and 202 both mean accepted; 202 means the key is still being checked.
console.log(`IndexNow: submitted ${urlList.length} pages, response ${res.status}`)
if (res.status !== 200 && res.status !== 202) {
  console.log(await res.text())
  process.exit(1)
}
