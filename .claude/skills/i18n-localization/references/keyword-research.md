# Keyword Research Methodology for i18n Localization

Detailed methodology for finding the keywords that local users actually search for, rather than relying on AI translation.

## Why This Matters

AI-translated keywords are often grammatically correct but not what locals type into search engines. Examples:
- English "royalty-free" → Korean AI translation "로열티 프리" → but Koreans actually search "저작권 프리" or "저작권 무료"
- English "background music" → Korean AI translation "배경음악" → but Koreans also heavily search the slang "브금" (BGM abbreviation)
- English "pricing plan" → Korean AI translation "가격 플랜" → but Koreans search "요금제"

## Step-by-Step Process

### Step 1: Identify Core English Keywords

List the product's core SEO terms in English. For an AI music generator, these might be:
- AI music generator
- AI background music generator
- free AI music
- royalty-free music
- create music
- commercial use
- content creator
- pricing / subscription / credits

### Step 2: Initial AI Translation

Translate each core keyword into the target language using AI. This gives a starting point, NOT the final answer.

### Step 3: Google Search Validation

Search for each translated keyword on Google with these settings:
- **IP**: Switch to target country (VPN or proxy)
- **Browser language**: Set to target language
- **Google search language**: Set to target language
- **Google region**: Set to target country

Examine the top-ranking results:
- What exact terms do they use in their titles, meta descriptions, and H1 tags?
- Are there alternative expressions you didn't consider?
- Are there local slang terms or abbreviations?

Record every variant you find.

### Step 4: Search Volume Verification

Take the discovered keywords to **Google Ads Keyword Planner**:
1. Enter all keyword variants into the forecast/search volume tool
2. Sort by search volume (highest to lowest)
3. Identify which expression has the most searches

If the keyword is too new for Keyword Planner data, skip to Step 5.

### Step 5: Google Trends Cross-Validation

Validate keyword variants on **Google Trends**:
1. Compare 2-3 variants of the same concept
2. Set the region to the target country
3. Check which variant trends higher
4. Note seasonal patterns if relevant

### Step 6: Competitor Analysis

Visit the localized versions of competing products:
- How do Suno AI, Udio, AIVA, Soundful express these concepts?
- What terms do they use in their Korean/Japanese/etc. versions?
- Check their meta tags, landing pages, and pricing pages

### Step 7: Local Slang & Abbreviation Discovery

Search for informal/slang terms on:
- Local social media (Korean: Naver, Tistory blogs; Japanese: note.com; Chinese: Zhihu, Bilibili)
- YouTube comments in the target language
- Reddit-like forums in the target country

Examples of discoveries:
- Korean "브금" (BGM) — universally used slang for background music
- Korean "만들기" suffix — users always append this when searching for tools ("AI 음악 만들기")
- Japanese "フリー素材" — common term for royalty-free assets

## Output Format

Create a keyword mapping table:

| English | AI Translation | Researched Local Term | Notes |
|---------|---------------|----------------------|-------|
| AI Music Generator | [AI translation] | [researched term] | [search volume/trend data] |
| AI Background Music Generator | [AI translation] | [researched term + slang variant] | [note local slang] |
| Free | [AI translation] | [researched term] | |
| Royalty-free | [AI translation] | [researched term] | [note if locals prefer different concept] |
| Create Music | [AI translation] | [researched term] | [note verb patterns] |
| Commercial Use | [AI translation] | [researched term] | |
| Pricing / Plan | [AI translation] | [researched term] | |
| Content Creator | [AI translation] | [researched term] | [note local equivalents like "유튜버"] |

## Tips

- **Run multiple search rounds** — first round discovers alternatives, second round validates with more specific queries
- **Check both formal and informal expressions** — meta tags may need formal terms while FAQ can use informal ones
- **Document everything** — the mapping table becomes the glossary for consistent translation
- **New/niche keywords** may not have Keyword Planner data — rely on Google Trends and competitor analysis instead
- **Language-specific patterns** — some languages have systematic search patterns (e.g., Korean users append "만들기" to tool searches, Japanese users append "ツール" or "無料")
