extends RefCounted
## Reactive dialogue, inspired by how Hades picks its lines.
##
## Every Lobby character has a pool of conversations. When you talk to them,
## pick() returns the highest-priority conversation you haven't seen whose
## requirements are met. When nothing new qualifies, it returns a random
## repeatable ("rep") line. Specific requirements make the best lines:
## "died to a boss while riding at x8" beats "died".
##
## Requirement keys (all optional, all must pass):
##   min:    {stat: n}  stat >= n        max:    {stat: n}  stat <= n
##   flag:   [names]    all flags set    noflag: [names]    no flag set
##   cause:  "spikes"   how the last run ended (see main._cause_of)
##   seen:   [ids]      these conversations have been seen
## Stats come from main._dialog_ctx(). Conversations can set flags.
##
## BARKS are one-liners the House says over the PA during play.
## TICKETS are the Losing Tickets lore collectibles, revealed in order.

const LINES := [
	# ------------------------------------------------------------ MARLOW (payphone)
	{"id": "marlow_intro", "who": "MARLOW", "pri": 100, "flags": ["met_marlow"], "lines": [
		["MARLOW", "Rico! You picked up! So the rumors are true: The House doesn't let debtors die, it just mails them home with a bigger bill, like a very rude pizza."],
		["MARLOW", "You bust, you wake up in your apartment, and the interest on your Marker goes up. Every do-over costs money, which makes it the worst video game ever, and I say that as your babysitter."],
		["RICO", "So I can't die. Great. What's the catch?"],
		["MARLOW", "The catch is you never stop owing. Climb the five casinos, get Jules back from The House, and get out before the interest finishes its own climb."]]},
	{"id": "marlow_spikes", "who": "MARLOW", "pri": 60, "req": {"cause": "spikes"}, "lines": [
		["MARLOW", "You died to spikes again? Rico, they don't move, they don't sneak, and they have exactly one job, and you keep helping them do it."]]},
	{"id": "marlow_guard", "who": "MARLOW", "pri": 60, "req": {"cause": "guard"}, "lines": [
		["MARLOW", "Those bouncers telegraph every punch, so parry right before it lands and they'll be eating carpet, which, I'll be honest, is where most of this casino's customers end up anyway."]]},
	{"id": "marlow_bat", "who": "MARLOW", "pri": 60, "req": {"cause": "bat"}, "lines": [
		["MARLOW", "You lost to rats, Rico. I'm leaving that out of the report, and the eulogy, and honestly the rest of your life story."]]},
	{"id": "marlow_sal", "who": "MARLOW", "pri": 65, "req": {"cause": "boss1"}, "lines": [
		["MARLOW", "That first boss fights like he deals, slow and then suddenly rude, so wait for the big wind-up, sidestep it, and punish him while he's still being dramatic."],
		["MARLOW", "And parry the big move if you can, because it stuns him wide open for double damage, which is the whole tip, and the rest of my advice is mostly sighing."]]},
	{"id": "marlow_roulette", "who": "MARLOW", "pri": 65, "req": {"cause": "boss2"}, "lines": [
		["MARLOW", "The second boss throws balls at you, and the balls bounce, so hit them right back at her, because nothing hurts a gambler more than getting her own bad luck returned."]]},
	{"id": "marlow_house", "who": "MARLOW", "pri": 70, "req": {"cause": "boss3"}, "lines": [
		["MARLOW", "You made it all the way to the penthouse, which is further than Jules ever got, further than me, and a lot further than my self-respect."],
		["MARLOW", "So don't you dare quit now, because I'll be so annoyed, and then I'll cry, loudly, on a payphone, in public."]]},
	{"id": "marlow_mags", "who": "MARLOW", "pri": 70, "req": {"cause": "mags"}, "lines": [
		["MARLOW", "Mags got you? You borrowed money from a shark in a suit, Rico, and there were warning signs, one of which was literally a fin."]]},
	{"id": "marlow_greedy", "who": "MARLOW", "pri": 75, "req": {"min": {"last_mult": 8}}, "lines": [
		["MARLOW", "You were riding at times eight when you busted, which is the exact kind of number I would have put on a tombstone if you could stay dead."],
		["MARLOW", "Just bank once in a while, okay? Jules never did, and look where it got him: a job at the casino, as the help, with a name tag."]]},
	{"id": "marlow_careful", "who": "MARLOW", "pri": 55, "req": {"min": {"last_cashed": 3, "deaths": 1}}, "lines": [
		["MARLOW", "Three cash-outs last run? That's careful money, Rico, so who are you, and what did you do with my idiot?"]]},
	{"id": "marlow_confess", "who": "MARLOW", "pri": 90, "req": {"min": {"max_city": 3}}, "flags": ["marlow_confessed"], "lines": [
		["MARLOW", "About what I said in Biloxi: I used to deal for The House, and I'm the one who got Jules his seat at that table."],
		["MARLOW", "I honestly thought he'd win, because he always won, and I know that's not an excuse, it's just a really bad bet that I'm still paying off."],
		["RICO", "...You put my brother at that table."],
		["MARLOW", "I did, and now I'm talking you back to him, one casino at a time, which is the only apology I've got, and it's a bad one, but it's also a pretty decent one, considering."]]},
	{"id": "marlow_vault", "who": "MARLOW", "pri": 50, "req": {"min": {"vaults": 1}}, "lines": [
		["MARLOW", "You cracked a safe! They only open if you get there fast, so speed pays at every casino, which is honestly the only thing those casinos have in common."]]},
	{"id": "marlow_daily", "who": "MARLOW", "pri": 50, "req": {"min": {"daily_played": 1}}, "lines": [
		["MARLOW", "Daily Deal, huh? Everyone in the world gets the same floors today, so go show them how it's done, or at least how to die in a really creative way."]]},
	{"id": "marlow_ending", "who": "MARLOW", "pri": 95, "req": {"flag": ["ending"]}, "lines": [
		["MARLOW", "Jules is out, the Bellagiro is quiet, and you're still picking up this phone, which I'm choosing to find sweet instead of worrying."],
		["MARLOW", "...Yeah, no, I'd go back too, honestly. Let it ride, kid."]]},
	{"id": "marlow_true", "who": "MARLOW", "pri": 99, "req": {"flag": ["true_end"]}, "lines": [
		["MARLOW", "The House is quiet for the first time in twenty years, and that was you, and I still can't believe I helped."],
		["MARLOW", "Eddie Duval finally cashed out, so I owe you a drink, actually about a thousand drinks, okay, fine, I owe you a bar."]]},
	{"id": "marlow_rep1", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Chain your moves, because The House pays out to style, and it also pays out to charity, but never, ever to you."]]},
	{"id": "marlow_rep2", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "That static on the line is The House listening, so, hi, House, we were totally not talking about you."]]},
	{"id": "marlow_rep3", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Smash the glass, grab the chips, and bank before you get cute, in that order, and please do not rearrange it like you did last time."]]},

	# ------------------------------------------------------------ VERA (the Dealer)
	{"id": "vera_intro", "who": "VERA", "pri": 100, "flags": ["met_vera"], "lines": [
		["VERA", "Fresh Marker, still wet, I see. I'm Vera Vex, and I deal charms now instead of cards, because the cards got complicated and one of them left."],
		["VERA", "Charms bend the odds on every floor, and you can win them on slots, crack them out of safes, take them off bosses, or just buy them at my table like a civilized person."],
		["RICO", "And up here?"],
		["VERA", "Up here I sell licenses, so pay me from your wallet and I'll start slipping the good charms into the casinos for you, for a fee, because everything in here is a fee."]]},
	{"id": "vera_bust", "who": "VERA", "pri": 70, "req": {"min": {"deaths": 1}}, "lines": [
		["VERA", "You came back, and honestly everyone comes back, which is the problem with this place and also, unfortunately, the entire business model."]]},
	{"id": "vera_stack", "who": "VERA", "pri": 60, "req": {"min": {"charms_found": 5}}, "lines": [
		["VERA", "Five charms and you're still breathing, so here's the trick: pick one vice and feed it like a stray."],
		["VERA", "Greed charms multiply each other and risk charms love a long ride, so stack the same vice and watch the numbers go stupid, which, frankly, suits you."]]},
	{"id": "vera_jackpot", "who": "VERA", "pri": 65, "req": {"min": {"jackpots": 1}}, "lines": [
		["VERA", "Triple sevens! The House hates that sound, so do it again, because I want to hear it cry."]]},
	{"id": "vera_sal", "who": "VERA", "pri": 55, "req": {"min": {"boss_tiers": 1}}, "lines": [
		["VERA", "You beat your first boss, and he'll be back on his feet by tomorrow, because nobody stays beaten in this place, least of all the bad guys, and especially not you."]]},
	{"id": "vera_queen_hint", "who": "VERA", "pri": 80, "req": {"min": {"runs": 6}}, "flags": ["queen_quest"], "lines": [
		["VERA", "Ever wonder why I stopped dealing? My deck is one card short, the Queen of Spades."],
		["VERA", "She's my Marker, and I lost her to The House a long time ago, so if you see her up there, bring her home, because she's lovely, if a little pointy."]]},
	{"id": "vera_queen_found", "who": "VERA", "pri": 98, "req": {"flag": ["queen_found"]}, "flags": ["vera_free"], "lines": [
		["VERA", "...That's her. That's my Queen."],
		["VERA", "Twenty years I've owed The House this card, and you found it folded inside a losing ticket, because of course you did."],
		["VERA", "You just paid off my Marker, Rico, which means I'm free to walk out that door."],
		["VERA", "I'm staying, though, because somebody has to keep you lucky, and licenses are 25% off for you forever, which, from me, is basically a love letter."]]},
	{"id": "vera_ending", "who": "VERA", "pri": 90, "req": {"flag": ["ending"]}, "lines": [
		["VERA", "You got Jules out, and do you know how many runners I've watched try that and fail?"],
		["VERA", "None of them knew when to cash out, but you did, mostly, twice, in a row, and I'd call that a miracle if I didn't know how you play."]]},
	{"id": "vera_eddie", "who": "VERA", "pri": 85, "req": {"min": {"tickets": 14}}, "lines": [
		["VERA", "Eddie Duval. You've been reading his tickets, haven't you?"],
		["VERA", "He was the best player I ever dealt to, and he never walked away from a table, not once, not even when it was on fire."],
		["VERA", "Now he IS the table, and that voice on the PA is what's left of Eddie, which, to be fair, is mostly interest."]]},
	{"id": "vera_rep1", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "Charms don't make you lucky, they just make you less unlucky, which is a very small difference and also my entire business."]]},
	{"id": "vera_rep2", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "The House always wins eventually, so your job is to leave before eventually, and mine is to sell you the ticket out."]]},
	{"id": "vera_rep3", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "Everything's for sale, sugar, and that includes advice, especially advice, because advice is the high-margin item."]]},

	# ------------------------------------------------------------ MAGS (the Loan Shark)
	{"id": "mags_intro", "who": "MAGS", "pri": 100, "flags": ["met_mags"], "lines": [
		["MAGS", "Hi, sweetheart, I'm Mags, and I hold the Markers at the door, and yours says The House owns your bones until you settle up, which I think is adorable."],
		["MAGS", "Short on chips? I lend! Two hundred now, three hundred back by the end of floor three, and honestly that's less a loan than a friendship with numbers."],
		["MAGS", "You pay me when you cash out, and if you miss the date, I come collecting, personally, through walls, with a little bow on it."],
		["RICO", "You're a shark. In a suit."],
		["MAGS", "And you're a runner with no money, and we all have our problems, but mine is wrapped around your wrist, and I love it so much."]]},
	{"id": "mags_repaid", "who": "MAGS", "pri": 70, "req": {"min": {"repaid": 1}}, "lines": [
		["MAGS", "You paid me back on time, sweetie, and I'm so proud, because you'd be amazed how few people do, and how many of them are in my aquarium."]]},
	{"id": "mags_default", "who": "MAGS", "pri": 75, "req": {"min": {"defaulted": 1}}, "lines": [
		["MAGS", "About that missed payment, honey, it's nothing personal, because interest isn't personal, it's just math with teeth, and tonight I brought the teeth."]]},
	{"id": "mags_big_loss", "who": "MAGS", "pri": 72, "req": {"min": {"last_lost": 1000}}, "lines": [
		["MAGS", "I saw you drop a thousand chips at the door, darling, and if you'd banked those instead, you'd have had a little money, and I'd have had a very different smile."]]},
	{"id": "mags_rates", "who": "MAGS", "pri": 60, "req": {"min": {"runs": 8}}, "lines": [
		["MAGS", "Just between us, The House charges interest on every single bust, compounding, forever, and I mean that with love."],
		["MAGS", "Even I think that's a little ugly, and I'm a loan shark, literally, it says so right on the jacket."]]},
	{"id": "mags_ending", "who": "MAGS", "pri": 85, "req": {"flag": ["ending"]}, "lines": [
		["MAGS", "You beat The House and it's still standing, and that's interest for you, kid, it keeps everything alive, like a bad marriage."]]},
	{"id": "mags_rep1", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "My advice is to borrow smart and ride dumb, and I'm kidding, please don't do that, and I'm also kidding about kidding, so pay up."]]},
	{"id": "mags_rep2", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "My rates are totally fair, sweetheart, it's The House's rates that are a crime, and I would know, because I'm a connoisseur."]]},
	{"id": "mags_rep3", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "A shark has to keep swimming, dear, and so do you, and yes, that was a threat, but it's also very good life advice."]]},

	# ------------------------------------------------------------ LUCKY (Lobby bar)
	{"id": "lucky_intro", "who": "LUCKY", "pri": 100, "lines": [
		["LUCKY", "Lucky's the name. On the floors I pour drinks, and up here I mostly take bets, mainly on how soon you'll be back, so thanks in advance for the business."],
		["LUCKY", "Everybody busts eventually, and bartenders hear all about it, and I've got a whole pool going on your next death, and honestly the odds are excellent."]]},
	{"id": "lucky_tip", "who": "LUCKY", "pri": 50, "req": {"min": {"runs": 3}}, "lines": [
		["LUCKY", "Pro tip: a Shot of Courage costs less than the interest on a bust, so find my bar on the floors, and yes, I have a lot of bars, and no, I won't explain how."]]},
	{"id": "lucky_cat", "who": "LUCKY", "pri": 55, "req": {"min": {"cat_pets": 3}}, "lines": [
		["LUCKY", "Keep petting Comp like that and he'll follow you up the floors, except he won't, because he's a cat, but he does like you, which is creepy, and I've got money on it ending badly."]]},
	{"id": "lucky_rep1", "who": "LUCKY", "pri": 0, "rep": true, "lines": [["LUCKY", "On the house? Nothing's on the house, pal, that's The House's whole thing, it's right there in the name."]]},
	{"id": "lucky_rep2", "who": "LUCKY", "pri": 0, "rep": true, "lines": [["LUCKY", "You've got the look of somebody about to let it ride, so tell me when, and I'll film it for the pool."]]},

	# ------------------------------------------------------------ JULES (after the ending)
	{"id": "jules_home", "who": "JULES", "pri": 100, "req": {"flag": ["ending"]}, "lines": [
		["JULES", "Rico, I keep waking up in the apartment out of habit, and The House still thinks I owe it money, which, to be fair, I do."],
		["JULES", "Thanks for coming for me, and now let me come with you, so pick me on the title screen, because I hit harder than you, and I also steal."]]},
	{"id": "jules_eddie", "who": "JULES", "pri": 80, "req": {"flag": ["ending"], "min": {"tickets": 10}}, "lines": [
		["JULES", "Those losing tickets are Eddie Duval's trail, and I dealt to that voice every night for three years."],
		["JULES", "He doesn't want our money, he wants somebody to finally beat him so he can stop, which is the saddest ten-second pitch I've ever heard."]]},
	{"id": "jules_rep1", "who": "JULES", "pri": 0, "rep": true, "req": {"flag": ["ending"]}, "lines": [["JULES", "Bank it, Rico, because I didn't, and look where it got me: a very comfortable cell with a view."]]},
	{"id": "jules_rep2", "who": "JULES", "pri": 0, "rep": true, "req": {"flag": ["ending"]}, "lines": [["JULES", "The House cheats, so we cheat better, and in our family that's what we call values."]]},
]

## The House over the PA. Keys are events fired from main._bark().
const BARKS := {
	"lobby": ["Welcome to the apartment. The House appreciates your continued mismanagement of it.", "No one dies owing the House, as that would be bad for business, and also for the carpet."],
	"wake": ["Welcome back, valued guest. Your tab has been adjusted upward, as a thank-you for your loyalty.", "Back so soon? The House never forgets a debtor, or their birthday, and we have a card.", "Interest has been applied to your account. Please smile, it's compounding."],
	"wake_spikes": ["Attention, guests: Rico was defeated by a spike. As a valued member, the spike has earned a complimentary drink."],
	"wake_guard": ["Security reminds guests that punching is a privilege, not a right, and as of today it is also a fee."],
	"wake_bat": ["The rats thank Rico for his generous contribution to their dinner. They found his femur especially delicious."],
	"wake_boss1": ["The first boss sends his regards, along with an invoice, a card, and a small, passive-aggressive muffin."],
	"wake_boss2": ["Another table has won, by which the House means us. The House is pleased, and slightly giggly."],
	"wake_boss3": ["So close, valued guest. The House admires ambition, and the House keeps it in a drawer, with the other ambitions."],
	"wake_mags": ["Our partners in lending thank you for your patience, and for your future earnings, which they have already spent."],
	"wake_big": ["That Pot was beautiful, and it's ours now. Thank you for your service, please come again, and preferably poorer."],
	"start": ["Doors are open, so mind the spikes, or don't, since the House has money on 'don't.'", "Another guest begins the climb. How wonderful for our quarterly numbers."],
	"ride": ["Let it ride? Oh, the House LIKES you. You're our favorite income stream.", "Bold. The House adores bold, because bold has margins."],
	"ride8": ["Attention, guests: we have a high roller on the floor. Please applaud him warmly, and then politely lift his wallet."],
	"cashout": ["Playing it safe? How responsible of you, and how deeply disappointing for us.", "Walking away? The House will remember this. The House keeps a spreadsheet, and you're a column."],
	"jackpot": ["Who rigged that machine? WHO RIGGED THAT MACHINE? Was it Gerald? It was Gerald."],
	"low_hp": ["One life left. The House recommends prayer, and, as a courtesy, a will.", "Feeling lucky? You shouldn't be. The House checked, and the results were very funny."],
	"boss": ["Ladies and gentlemen, the main event! Please clap, and then please place a bet against our guest."],
	"vault_open": ["Somebody check the safe. WHY IS THE SAFE OPEN? Whoever left it open is eligible for a demotion."],
	"vault_miss": ["The safe has now sealed. Punctuality is a virtue, guest, and so is not losing, and you've failed both."],
	"loan_due": ["Attention, guests: a loan is past due. Please keep your hands, feet, and dignity inside the casino at all times."],
	"spill": ["Butterfingers! The House will be keeping those.", "Chips on the floor! Finders keepers, and losers weepers, per our terms and conditions."],
	"bet_won": ["A side bet has paid out. The House is fine. The House is totally fine. The House needs to lie down."],
	"bet_lost": ["Your side bet has lost. Tragic for you, delicious for us, and both are on the receipt."],
	"cat": ["Please do not pet the cat. The cat is a House employee, and is currently on a performance review.", "The cat likes you, and the cat is wrong, as the cat has a poor track record with people."],
	"daily": ["Today's Daily Deal features the same cards for everyone. Fairness! How quaint, and how off-brand for us."],
	"stakes": ["Raising the stakes? The House salutes your poor judgment, and also your life insurance, which we are now beneficiary of."],
	"ticket": ["Littering is a violation of House policy, and reading what you found is worse, and remembering it is a felony."],
	"charm": ["A charm? How cute. The House has charms too, and we call them interest rates."],
}

const TICKETS := [
	"Bet it all on red. It came up black, because it's always black, and it's honestly the only color I'm good at. -D.",
	"Day 3 and the rats aren't the worst part, since the worst part is the elevator music, and the rats agree with me.",
	"If you find this, bank on floor 2, because nobody banks on floor 2, which is exactly why it works, so please don't tell The House I said so.",
	"I lost my watch, my car, and my brother's watch, so note to self: stop, and also note to self: you won't.",
	"The slot by the stairs paid out twice in a row, so I named it Gerald, and Gerald is now my only friend, even though he tried to bite me.",
	"The first boss used to work the door at the Atlantic Shitty casino, until one night he let it ride, and now he's a boss, so the moral is never let it ride.",
	"Dealers never blink, I watched one for an hour, and then I blinked, and they made a note.",
	"My Marker says I owe The House 'one evening,' and it's been eleven years, but the evening is going great.",
	"Eddie Duval was here, and Eddie Duval never cashes out. -E.D.",
	"Jules, if you're reading this, your brother's coming, so hang on, and please stop betting your shoes. -M.",
	"The old dealers whisper that The House used to be a man, and they also whisper that he's single.",
	"QUEEN OF SPADES. A playing card was folded inside this ticket, and the back is signed: 'V. Vex, Marker #1.'",
	"Eddie bet the deed to his own club against The House and won, and then he bet it again, and the sequel was worse.",
	"Every time Eddie won, he let it ride, and the tables got bigger while Eddie got quieter, and eventually also shorter.",
	"Nobody saw Eddie lose, but one night the lights flickered and the PA started talking in his voice, and the jokes got worse.",
	"The House doesn't want your money, it wants you to keep playing, because that's what feeds it, but it also really likes your money.",
	"Mags says interest is what keeps The House alive, but I think she's scared of it too, because she sleeps with the light on, and she sleeps underwater.",
	"If The House ever loses big enough, I think Eddie finally gets to leave, or explode, and honestly I'm okay with either. -V.",
	"I saw a runner bank everything on floor 1 and walk straight out the front door, and The House screamed for an hour while we all clapped.",
	"Know when to walk away, and know when to let it ride, because Eddie only ever learned one of them, and I bet you can guess which. -D.",
]
## Ticket index that holds Vera's Queen of Spades (0-based).
const QUEEN_TICKET := 11


static func check(req: Dictionary, ctx: Dictionary, seen: Dictionary, flags: Dictionary) -> bool:
	for k in (req.get("min", {}) as Dictionary):
		if float(ctx.get(k, 0)) < float(req["min"][k]):
			return false
	for k in (req.get("max", {}) as Dictionary):
		if float(ctx.get(k, 0)) > float(req["max"][k]):
			return false
	for fl in req.get("flag", []):
		if not flags.has(fl):
			return false
	for fl in req.get("noflag", []):
		if flags.has(fl):
			return false
	if req.has("cause") and String(ctx.get("last_cause", "")) != String(req["cause"]):
		return false
	for id in req.get("seen", []):
		if not seen.has(id):
			return false
	return true


## The best new conversation for `who`, or a random repeatable one.
## Returns {} if this character has nothing to say yet.
static func pick(who: String, ctx: Dictionary, seen: Dictionary, flags: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	var best: Dictionary = {}
	var reps: Array = []
	for e in LINES:
		if e["who"] != who or not check(e.get("req", {}), ctx, seen, flags):
			continue
		if e.get("rep", false):
			reps.append(e)
		elif not seen.has(e["id"]) and (best.is_empty() or int(e["pri"]) > int(best["pri"])):
			best = e
	if not best.is_empty():
		return best
	if reps.is_empty():
		return {}
	return reps[rng.randi_range(0, reps.size() - 1)]


## True if `who` has an unseen conversation ready (shows "!" over them).
static func has_new(who: String, ctx: Dictionary, seen: Dictionary, flags: Dictionary) -> bool:
	for e in LINES:
		if e["who"] == who and not e.get("rep", false) and not seen.has(e["id"]) and check(e.get("req", {}), ctx, seen, flags):
			return true
	return false
