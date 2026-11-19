# What players loved (research for LET IT RIDE)

Method: web searches in November 2026 plus design knowledge. Sources were mostly fan analysis and blogs, not developer postmortems, so treat the claims as informal. Where a search returned nothing (Hollow Knight, Celeste, Spelunky 2, Ori, Blasphemous, Gungeon, Isaac, Slay the Spire, Rogue Legacy 2), the point is marked **(general design knowledge)** and was not verified by a source.

## Findings with sources

1. **Feedback is the product (Balatro).** Fan analysis says "strip the animations and sounds and you have a calculator", and that showing which cards triggered which bonus turns opaque math into learnable systems. ([blakecrosley.com guide](https://blakecrosley.com/guides/design/balatro), [turnbasedlovers](https://turnbasedlovers.com/news/9-reasons-why-balatro-is-so-fun))
2. **Multiplicative synergy is sticky, additive is forgettable (Balatro).** Jokers interact; one analysis says a run that buys low-synergy jokers early stalls later. ([saschb2b lessons](https://saschb2b.github.io/game-mechanics/games/balatro/lessons), [gamesradar](https://gamesradar.com/games/roguelike/after-an-unbeatable-year-for-balatro-we-asked-a-professional-poker-player-to-break-down-what-makes-the-indie-roguelike-so-good))
3. **Borrow a known rule set (Balatro).** Poker is already understood, so onboarding is cheap; failed runs teach lessons for the next. ([devindiegame](https://devindiegame.pages.dev/articles/why-balatro-succeeded.html))
4. **Stacking makes you the build-maker (Risk of Rain 2).** Items rarely give a build; they give a stack and wait to see what you do. One guide: "most items get stronger with every copy". ([ludo.guide synergies](https://www.ludo.guide/guide/risk-of-rain-2/tips-secrets/item-synergies), [thegamer](https://www.thegamer.com/risk-rain-2-best-items-stack/))
5. **Every death advances something (Hades).** Story and meta progression reward failure; critics warn heavy meta can blur earned skill. ([feedme.design](https://www.feedme.design/why-we-cant-stop-playing-these-roguelites), [Hades essay](https://bottomfeeder.substack.com/p/some-scattered-thoughts-about-hades))
6. **Meta-progression that makes you better, not just stronger (Dead Cells).** Unlock options and variety rather than raw numbers. ([choost.site](https://choost-site.pages.dev/blog/best-roguelites-build-variety))
7. **Moment-to-moment play must be good before systems matter.** ([urflow roguelites primer](https://urflow.bearblog.dev/roguelites-a-primer/))
8. **(general design knowledge)** Hollow Knight: tight, responsive movement; a connected map you earn and a map you buy; secrets behind breakable walls; boss fights with learnable patterns and a rematch. Celeste: assist options that never judge the player. Spelunky 2: community-shared secrets and daily seeds. Isaac / Gungeon: item descriptions with personality and surprising synergies. Slay the Spire: readable intent. Rogue Legacy 2: a hub that grows between runs.

## The ideas we kept (and the features built from them)

| # | Idea | In LET IT RIDE |
|---|---|---|
| 1 | Feedback / juice | Hitstop, damage numbers, spark bursts, slow-mo kills (done) |
| 2 | Multiplicative synergy | Charm stacking, Snowball, Raise multiplier |
| 3 | Known rule set | Every boss is a real table game |
| 4 | Stacking | Duplicate charms stack (`charms.add_stack`) |
| 5 | Death advances story | Lobby NPCs react to death, clothes, money (voice pools) |
| 6 | Options over numbers | Vendors, weapons, clothes unlock abilities |
| 7 | Secrets | Breakable walls, secret tables, secret bosses |
| 8 | Hunter's journal | **44a** Bestiary (F4) |
| 9 | Synergy discovery moments | **44b** Combo toasts |
| 10 | Item descriptions with personality | **44c** Flavor lines |
| 11 | Fast restart / daily seed / assist | Already present: R restart, Daily Deal, Assist options |
