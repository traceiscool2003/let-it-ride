extends RefCounted
## Reactive dialogue, inspired by how Hades picks its lines.
##
## Every Lobby character has a pool of conversations. When you talk to them,
## pick() returns the highest-priority conversation you haven't seen whose
## requirements are met. When nothing new qualifies, it returns a random
## repeatable ("rep") line. Specific requirements make the best lines:
## "died to Big Sal while riding at x8" beats "died".
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
		["MARLOW", "Rico! You picked up. So the rumors are true: the House doesn't let debtors die down there."],
		["MARLOW", "You bust, it drags you back up to the Lobby and adds interest to your Marker. Every run is a do-over."],
		["RICO", "So I can't die. Great. What's the catch?"],
		["MARLOW", "The catch is you never stop owing. Learn the floors, find Jules, and get out before the interest eats you."]]},
	{"id": "marlow_spikes", "who": "MARLOW", "pri": 60, "req": {"cause": "spikes"}, "lines": [
		["MARLOW", "Spikes again? They don't move, Rico. That's kind of their whole thing."]]},
	{"id": "marlow_guard", "who": "MARLOW", "pri": 60, "req": {"cause": "guard"}, "lines": [
		["MARLOW", "Those bouncers telegraph every punch. Parry right before it lands and they'll be eating carpet."]]},
	{"id": "marlow_bat", "who": "MARLOW", "pri": 60, "req": {"cause": "bat"}, "lines": [
		["MARLOW", "Bats. You lost to bats. I'm leaving that out of the report."]]},
	{"id": "marlow_sal", "who": "MARLOW", "pri": 65, "req": {"cause": "boss1"}, "lines": [
		["MARLOW", "Sal fights like he talks: big and slow. Wait for the charge, sidestep, then punish."],
		["MARLOW", "Parry the charge itself and he's stunned wide open. Double damage."]]},
	{"id": "marlow_roulette", "who": "MARLOW", "pri": 65, "req": {"cause": "boss2"}, "lines": [
		["MARLOW", "Madame Roulette's balls bounce. Hit them back at her. She hates that more than losing."]]},
	{"id": "marlow_house", "who": "MARLOW", "pri": 70, "req": {"cause": "boss3"}, "lines": [
		["MARLOW", "You made it all the way to the House. That's further than Jules ever got."],
		["MARLOW", "Don't you dare quit now."]]},
	{"id": "marlow_mags", "who": "MARLOW", "pri": 70, "req": {"cause": "mags"}, "lines": [
		["MARLOW", "Mags got you? You borrowed from a SHARK, Rico. In a SUIT. There were signs."]]},
	{"id": "marlow_greedy", "who": "MARLOW", "pri": 75, "req": {"min": {"last_mult": 8}}, "lines": [
		["MARLOW", "You were riding at times eight when you went down. Times eight."],
		["MARLOW", "Breathe. Bank once in a while. Jules never did, and look where he ended up."]]},
	{"id": "marlow_careful", "who": "MARLOW", "pri": 55, "req": {"min": {"last_cashed": 3, "deaths": 1}}, "lines": [
		["MARLOW", "Three cash-outs last run. Careful money. Jules never knew when to walk away. Glad one of you does."]]},
	{"id": "marlow_confess", "who": "MARLOW", "pri": 90, "req": {"min": {"runs": 9}}, "flags": ["marlow_confessed"], "lines": [
		["MARLOW", "There's something I should've told you before you went in."],
		["MARLOW", "I used to deal for the House. I'm the one who got Jules a seat at its table. I thought he'd win. He always won."],
		["RICO", "...You sent my brother down there."],
		["MARLOW", "And I'm talking you back out of it, one floor at a time. That's the only apology I've got that's worth anything."]]},
	{"id": "marlow_vault", "who": "MARLOW", "pri": 50, "req": {"min": {"vaults": 1}}, "lines": [
		["MARLOW", "You cracked a Vault Door! They only open if you get there fast. Speed pays down there. Remember that."]]},
	{"id": "marlow_daily", "who": "MARLOW", "pri": 50, "req": {"min": {"daily_played": 1}}, "lines": [
		["MARLOW", "Daily Deal, huh? Same floors for everyone today. Show the rest of the Pit how it's done."]]},
	{"id": "marlow_ending", "who": "MARLOW", "pri": 95, "req": {"flag": ["ending"]}, "lines": [
		["MARLOW", "Jules is out and the floors keep going down. And you're still picking up this phone."],
		["MARLOW", "...Yeah. I'd go back too. Let it ride, kid."]]},
	{"id": "marlow_true", "who": "MARLOW", "pri": 99, "req": {"flag": ["true_end"]}, "lines": [
		["MARLOW", "The House is quiet. First time in twenty years. You did that."],
		["MARLOW", "Eddie Duval finally cashed out. I owe you a drink. I owe you about a thousand drinks."]]},
	{"id": "marlow_rep1", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Chain your moves. The House pays out to style."]]},
	{"id": "marlow_rep2", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Static on the line... that's the House listening. Hi, House."]]},
	{"id": "marlow_rep3", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Smash the glass, grab the chips, bank before you get cute."]]},

	# ------------------------------------------------------------ VERA (the Dealer)
	{"id": "vera_intro", "who": "VERA", "pri": 100, "flags": ["met_vera"], "lines": [
		["VERA", "Fresh Marker, still wet. I'm Vera Vex. I deal charms now, not cards."],
		["VERA", "Charms bend the odds down there. Win them on slots, crack them out of vaults, take them off bosses, or buy them at my table on the floors."],
		["RICO", "And up here?"],
		["VERA", "Up here I sell licenses. Pay me from your wallet and I'll start slipping the good charms into the Pit."]]},
	{"id": "vera_bust", "who": "VERA", "pri": 70, "req": {"min": {"deaths": 1}}, "lines": [
		["VERA", "You came back. Everyone comes back. That's the problem with this place."]]},
	{"id": "vera_stack", "who": "VERA", "pri": 60, "req": {"min": {"charms_found": 5}}, "lines": [
		["VERA", "Five charms and still breathing. Here's the trick: pick a vice and feed it."],
		["VERA", "Greed charms multiply each other. Risk charms love a long ride. Stack the same vice and watch the numbers go stupid."]]},
	{"id": "vera_jackpot", "who": "VERA", "pri": 65, "req": {"min": {"jackpots": 1}}, "lines": [
		["VERA", "Triple sevens. The House hates that sound. Do it again."]]},
	{"id": "vera_sal", "who": "VERA", "pri": 55, "req": {"min": {"boss_tiers": 1}}, "lines": [
		["VERA", "Big Sal went down. He'll be back on his feet tomorrow. Down here nobody stays down. Not even the bad guys."]]},
	{"id": "vera_queen_hint", "who": "VERA", "pri": 80, "req": {"min": {"runs": 6}}, "flags": ["queen_quest"], "lines": [
		["VERA", "Ever wonder why I stopped dealing? My deck's one card short. The Queen of Spades."],
		["VERA", "She's my Marker. Lost her to the House a long time ago. If you see her down there... bring her home."]]},
	{"id": "vera_queen_found", "who": "VERA", "pri": 98, "req": {"flag": ["queen_found"]}, "flags": ["vera_free"], "lines": [
		["VERA", "...That's her. That's my Queen."],
		["VERA", "Twenty years I've owed the House this card, and you found it folded in a losing ticket. Of course you did."],
		["VERA", "You just paid my Marker, Rico. I'm free to walk out that door."],
		["VERA", "I'm staying. Somebody has to keep you lucky. Licenses are 25% off for you, forever."]]},
	{"id": "vera_ending", "who": "VERA", "pri": 90, "req": {"flag": ["ending"]}, "lines": [
		["VERA", "You got Jules out. Do you know how many runners I've watched try that?"],
		["VERA", "None of them knew when to cash out. You did. Mostly."]]},
	{"id": "vera_eddie", "who": "VERA", "pri": 85, "req": {"min": {"tickets": 14}}, "lines": [
		["VERA", "Eddie Duval. You've been reading his tickets, haven't you."],
		["VERA", "Best player I ever dealt to. Never walked away from a table. Not once."],
		["VERA", "Now he IS the table. That voice on the PA? That's what's left of Eddie."]]},
	{"id": "vera_rep1", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "Charms don't make you lucky. They make you less unlucky."]]},
	{"id": "vera_rep2", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "The House always wins. Eventually. Your job is to leave before eventually."]]},
	{"id": "vera_rep3", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "Everything's for sale, sugar. Advice included. Advice especially."]]},

	# ------------------------------------------------------------ MAGS (the Loan Shark)
	{"id": "mags_intro", "who": "MAGS", "pri": 100, "flags": ["met_mags"], "lines": [
		["MAGS", "Name's Mags. I hold the Markers at the door, and yours says the House owns your bones until you settle up."],
		["MAGS", "Short on chips? I lend. Two hundred now, three hundred back by the end of floor three."],
		["MAGS", "Pay me when you cash out. Miss the date and I come collecting. Personally. Through walls."],
		["RICO", "You're a shark. In a suit."],
		["MAGS", "And you're a runner with no money. We all have our problems."]]},
	{"id": "mags_repaid", "who": "MAGS", "pri": 70, "req": {"min": {"repaid": 1}}, "lines": [
		["MAGS", "You paid me back on time. Respect. You'd be amazed how few do."]]},
	{"id": "mags_default", "who": "MAGS", "pri": 75, "req": {"min": {"defaulted": 1}}, "lines": [
		["MAGS", "About that chase. Nothing personal. Interest isn't personal, kid. It's just math with teeth."]]},
	{"id": "mags_big_loss", "who": "MAGS", "pri": 72, "req": {"min": {"last_lost": 1000}}, "lines": [
		["MAGS", "Saw you drop a thousand at the door. If you'd banked that, you'd have... well. You know what you'd have."]]},
	{"id": "mags_rates", "who": "MAGS", "pri": 60, "req": {"min": {"runs": 8}}, "lines": [
		["MAGS", "Between you and me? The House charges interest on every bust. Compounding. Forever."],
		["MAGS", "Even I think that's ugly. And I'm a loan shark. Literally."]]},
	{"id": "mags_ending", "who": "MAGS", "pri": 85, "req": {"flag": ["ending"]}, "lines": [
		["MAGS", "You beat the House and it's still standing. That's interest for you, kid. It keeps things alive."]]},
	{"id": "mags_rep1", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "Borrow smart. Ride dumb. That's a joke. Don't do that."]]},
	{"id": "mags_rep2", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "My rates are fair. The House's rates are a crime. I would know."]]},
	{"id": "mags_rep3", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "A shark has to keep swimming. So do you."]]},

	# ------------------------------------------------------------ LUCKY (Lobby bar)
	{"id": "lucky_intro", "who": "LUCKY", "pri": 100, "lines": [
		["LUCKY", "Lucky's the name. Down on the floors I pour drinks. Up here I just listen."],
		["LUCKY", "Everybody busts eventually. Barkeeps hear all about it."]]},
	{"id": "lucky_tip", "who": "LUCKY", "pri": 50, "req": {"min": {"runs": 3}}, "lines": [
		["LUCKY", "Pro tip: a Shot of Courage costs less than the interest on a bust. Find my bar on the floors."]]},
	{"id": "lucky_cat", "who": "LUCKY", "pri": 55, "req": {"min": {"cat_pets": 3}}, "lines": [
		["LUCKY", "Keep petting Comp like that and he'll follow you down. ...He won't. He's a cat. But he likes you."]]},
	{"id": "lucky_rep1", "who": "LUCKY", "pri": 0, "rep": true, "lines": [["LUCKY", "On the house? Nothing's on the house. That's the House's whole thing."]]},
	{"id": "lucky_rep2", "who": "LUCKY", "pri": 0, "rep": true, "lines": [["LUCKY", "You've got the look of somebody about to let it ride."]]},

	# ------------------------------------------------------------ JULES (after the ending)
	{"id": "jules_home", "who": "JULES", "pri": 100, "req": {"flag": ["ending"]}, "lines": [
		["JULES", "Rico. I keep waking up in this Lobby. Old habits. The House still thinks I owe it."],
		["JULES", "Thanks for coming for me. Now let me come with you. Pick me on the title screen. I hit harder than you."]]},
	{"id": "jules_eddie", "who": "JULES", "pri": 80, "req": {"flag": ["ending"], "min": {"tickets": 10}}, "lines": [
		["JULES", "Those losing tickets are Eddie Duval's trail. I dealt to that voice every night for three years."],
		["JULES", "He doesn't want our money. He wants somebody to finally beat him so he can stop."]]},
	{"id": "jules_rep1", "who": "JULES", "pri": 0, "rep": true, "req": {"flag": ["ending"]}, "lines": [["JULES", "Bank it, Rico. I didn't. Look where it got me."]]},
	{"id": "jules_rep2", "who": "JULES", "pri": 0, "rep": true, "req": {"flag": ["ending"]}, "lines": [["JULES", "The House cheats. So we cheat better."]]},
]

## The House over the PA. Keys are events fired from main._bark().
const BARKS := {
	"lobby": ["Welcome to the Lobby of The Pit. Your Marker is our pleasure.", "No one dies owing the House. That would be bad for business."],
	"wake": ["Welcome back, valued guest. Your tab has been adjusted.", "Back so soon? The House never forgets a debtor.", "Interest applied. Smile, it's compounding."],
	"wake_spikes": ["Attention guests: Rico was defeated by a spike. The spike's drinks are on the house."],
	"wake_guard": ["Security reminds guests that punching is a privilege, not a right."],
	"wake_bat": ["The bats thank you for your generous contribution."],
	"wake_boss1": ["Big Sal sends his regards. And an invoice."],
	"wake_boss2": ["Madame Roulette spun. You lost. Round and round we go."],
	"wake_boss3": ["So close. The House admires ambition. The House also keeps it."],
	"wake_mags": ["Our partners in lending thank you for your patience."],
	"wake_big": ["That Pot was beautiful. It's mine now. Thank you."],
	"start": ["Doors are open. Mind the spikes. Or don't.", "Another guest descends. How wonderful for me."],
	"ride": ["Let it ride? Oh, I LIKE you.", "Bold. The House adores bold."],
	"ride8": ["Attention guests: we have a high roller on the floor!"],
	"cashout": ["Playing it safe. How... responsible. Ugh.", "Walking away? The House will remember this."],
	"jackpot": ["Who rigged that machine? WHO RIGGED THAT MACHINE?"],
	"low_hp": ["One life left. The House recommends praying.", "Feeling lucky? You shouldn't."],
	"boss": ["Ladies and gentlemen... the main event."],
	"vault_open": ["Somebody check the vault. WHY IS THE VAULT OPEN."],
	"vault_miss": ["The vault has sealed. Punctuality is a virtue, guest."],
	"loan_due": ["Attention guests: a loan is past due. Please keep hands and feet inside the Pit."],
	"spill": ["Butterfingers!", "Chips on the floor! Finders keepers."],
	"bet_won": ["A side bet paid out. The House is fine. Totally fine."],
	"bet_lost": ["Side bet lost. Tragic. Delicious."],
	"cat": ["Please do not pet the cat. The cat is a House employee.", "The cat likes you. The cat is wrong."],
	"daily": ["Today's Daily Deal: the same cards for everyone. Fairness! How quaint."],
	"stakes": ["Raising the stakes? The House salutes your poor judgment."],
	"ticket": ["Littering is a violation of House policy. Reading it is worse."],
	"charm": ["A charm? Cute. The House has charms too. They're called interest rates."],
}

const TICKETS := [
	"Bet it all on red. It was black. It's always black down here. -D.",
	"Day 3. The bats aren't the worst part. The worst part is the elevator music.",
	"If you find this: bank on floor 2. Nobody banks on floor 2. That's why it works.",
	"Lost my watch, my car, and my brother's watch. Note to self: stop.",
	"The slot by the stairs paid out twice in a row. I named it Gerald. Gerald is my only friend.",
	"Big Sal used to work the door upstairs. Then one night he let it ride.",
	"Madame Roulette never blinks. I watched for an hour. She never blinks.",
	"My Marker says I owe the House 'one evening.' It has been eleven years.",
	"Eddie Duval was here. Eddie Duval never cashes out. -E.D.",
	"Jules, if you're reading this: your brother's coming. Hang on. -M.",
	"The old dealers whisper that the House used to be a man.",
	"QUEEN OF SPADES. A playing card folded inside this ticket. The back is signed: 'V. Vex, Marker #1.'",
	"Eddie bet the deed to his own club against the House. He won. Then he bet it again.",
	"Every time Eddie won, he let it ride. Every time. The tables got bigger. Eddie got quieter.",
	"Nobody saw Eddie lose. One night the lights flickered and the PA started talking in his voice.",
	"The House doesn't want your money. It wants you to keep playing. That's what feeds it.",
	"Mags says interest is what keeps the House alive. I think she's scared of it too.",
	"If the House ever loses big enough, I think Eddie finally gets to leave.",
	"Saw a runner bank everything on floor 1 and walk out the front door. The House screamed for an hour.",
	"Know when to walk away. Know when to let it ride. Eddie only ever learned one. -D.",
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
