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
		["MARLOW", "Rico! You picked up. So the rumors are true: The House doesn't let debtors die. It just sends them home with a bigger bill."],
		["MARLOW", "You bust, you wake up here, and the interest on your Marker goes up. Every run is a do-over. Every do-over is a bill."],
		["RICO", "So I can't die. Great. What's the catch?"],
		["MARLOW", "The catch is you never stop owing. Climb the five casinos, get Jules, and get out before the interest gets out first."]]},
	{"id": "marlow_spikes", "who": "MARLOW", "pri": 60, "req": {"cause": "spikes"}, "lines": [
		["MARLOW", "Spikes again? They don't move, Rico. That's kind of their whole thing. It's the only thing they do."]]},
	{"id": "marlow_guard", "who": "MARLOW", "pri": 60, "req": {"cause": "guard"}, "lines": [
		["MARLOW", "Those bouncers telegraph every punch. Parry right before it lands and they'll be eating carpet. Dry carpet. Hard carpet."]]},
	{"id": "marlow_bat", "who": "MARLOW", "pri": 60, "req": {"cause": "bat"}, "lines": [
		["MARLOW", "Rats. You lost to rats. I'm leaving that out of the report. And the eulogy."]]},
	{"id": "marlow_sal", "who": "MARLOW", "pri": 65, "req": {"cause": "boss1"}, "lines": [
		["MARLOW", "That first boss fights like he deals: slow, then rude. Wait for the big wind-up, sidestep, then punish."],
		["MARLOW", "Parry the big move and he's stunned wide open. Double damage. That's the whole tip. The rest is vibes."]]},
	{"id": "marlow_roulette", "who": "MARLOW", "pri": 65, "req": {"cause": "boss2"}, "lines": [
		["MARLOW", "The second table's thrown balls bounce. Hit them back at the boss. They hate that more than losing. They hate it more than their mothers."]]},
	{"id": "marlow_house", "who": "MARLOW", "pri": 70, "req": {"cause": "boss3"}, "lines": [
		["MARLOW", "You made it all the way to the penthouse. That's further than Jules ever got. Further than me. Further than my self-respect."],
		["MARLOW", "Don't you dare quit now. I'll be so annoyed. I'll cry. Loudly."]]},
	{"id": "marlow_mags", "who": "MARLOW", "pri": 70, "req": {"cause": "mags"}, "lines": [
		["MARLOW", "Mags got you? You borrowed from a SHARK, Rico. In a SUIT. There were signs. There was literally a fin."]]},
	{"id": "marlow_greedy", "who": "MARLOW", "pri": 75, "req": {"min": {"last_mult": 8}}, "lines": [
		["MARLOW", "You were riding at times eight when you went down. Times eight. EIGHT."],
		["MARLOW", "Breathe. Bank once in a while. Jules never did, and look where it got him. A job. At a casino. As the help."]]},
	{"id": "marlow_careful", "who": "MARLOW", "pri": 55, "req": {"min": {"last_cashed": 3, "deaths": 1}}, "lines": [
		["MARLOW", "Three cash-outs last run. Careful money. Who are you and what did you do with my idiot?"]]},
	{"id": "marlow_confess", "who": "MARLOW", "pri": 90, "req": {"min": {"max_city": 3}}, "flags": ["marlow_confessed"], "lines": [
		["MARLOW", "About what I said in Biloxi. I used to deal for The House. I got Jules his seat at the table."],
		["MARLOW", "I thought he'd win. He always won. That's not an excuse. It's a prior bad bet."],
		["RICO", "...You put my brother at that table."],
		["MARLOW", "And I'm talking you back to him, one floor at a time. It's the only apology I've got. It's a bad one. It's also, considering, a pretty good one."]]},
	{"id": "marlow_vault", "who": "MARLOW", "pri": 50, "req": {"min": {"vaults": 1}}, "lines": [
		["MARLOW", "You cracked a safe! They only open if you get there fast. Speed pays at every casino. That's the only thing they have in common."]]},
	{"id": "marlow_daily", "who": "MARLOW", "pri": 50, "req": {"min": {"daily_played": 1}}, "lines": [
		["MARLOW", "Daily Deal, huh? Same floors for everyone today. Show the rest of the world how it's done. Or how not."]]},
	{"id": "marlow_ending", "who": "MARLOW", "pri": 95, "req": {"flag": ["ending"]}, "lines": [
		["MARLOW", "Jules is out, the Bellagiro is quiet, and you're still picking up this phone."],
		["MARLOW", "...Yeah. I'd go back too. Let it ride, kid."]]},
	{"id": "marlow_true", "who": "MARLOW", "pri": 99, "req": {"flag": ["true_end"]}, "lines": [
		["MARLOW", "The House is quiet. First time in twenty years. You did that."],
		["MARLOW", "Eddie Duval finally cashed out. I owe you a drink. I owe you about a thousand drinks. Okay, I owe you a bar."]]},
	{"id": "marlow_rep1", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Chain your moves. The House pays out to style. The House also pays out to charity. Never to you."]]},
	{"id": "marlow_rep2", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Static on the line... that's the House listening. Hi, House. We're not talking about you."]]},
	{"id": "marlow_rep3", "who": "MARLOW", "pri": 0, "rep": true, "lines": [["MARLOW", "Smash the glass, grab the chips, bank before you get cute. In that order. Do not rearrange."]]},

	# ------------------------------------------------------------ VERA (the Dealer)
	{"id": "vera_intro", "who": "VERA", "pri": 100, "flags": ["met_vera"], "lines": [
		["VERA", "Fresh Marker, still wet. I'm Vera Vex. I deal charms now, not cards. The cards got complicated."],
		["VERA", "Charms bend the odds on every floor. Win them on slots, crack them out of safes, take them off bosses, or buy them at my table."],
		["RICO", "And up here?"],
		["VERA", "Up here I sell licenses. Pay me from your wallet and I'll start slipping the good charms into the casinos. For a fee. Everything's a fee."]]},
	{"id": "vera_bust", "who": "VERA", "pri": 70, "req": {"min": {"deaths": 1}}, "lines": [
		["VERA", "You came back. Everyone comes back. That's the problem with this place. It's also the business model."]]},
	{"id": "vera_stack", "who": "VERA", "pri": 60, "req": {"min": {"charms_found": 5}}, "lines": [
		["VERA", "Five charms and still breathing. Here's the trick: pick a vice and feed it."],
		["VERA", "Greed charms multiply each other. Risk charms love a long ride. Stack the same vice and watch the numbers go stupid. Like you."]]},
	{"id": "vera_jackpot", "who": "VERA", "pri": 65, "req": {"min": {"jackpots": 1}}, "lines": [
		["VERA", "Triple sevens. The House hates that sound. Do it again. I want to hear it cry."]]},
	{"id": "vera_sal", "who": "VERA", "pri": 55, "req": {"min": {"boss_tiers": 1}}, "lines": [
		["VERA", "You took down your first table. He'll be back on his feet tomorrow. Nobody stays down here. Not even the bad guys. Especially not the bad guys."]]},
	{"id": "vera_queen_hint", "who": "VERA", "pri": 80, "req": {"min": {"runs": 6}}, "flags": ["queen_quest"], "lines": [
		["VERA", "Ever wonder why I stopped dealing? My deck's one card short. The Queen of Spades."],
		["VERA", "She's my Marker. Lost her to The House a long time ago. If you see her up there... bring her home. She's lovely. Bit pointy."]]},
	{"id": "vera_queen_found", "who": "VERA", "pri": 98, "req": {"flag": ["queen_found"]}, "flags": ["vera_free"], "lines": [
		["VERA", "...That's her. That's my Queen."],
		["VERA", "Twenty years I've owed The House this card, and you found it folded in a losing ticket. Of course you did."],
		["VERA", "You just paid my Marker, Rico. I'm free to walk out that door."],
		["VERA", "I'm staying. Somebody has to keep you lucky. Licenses are 25% off for you, forever. That's romance, for me."]]},
	{"id": "vera_ending", "who": "VERA", "pri": 90, "req": {"flag": ["ending"]}, "lines": [
		["VERA", "You got Jules out. Do you know how many runners I've watched try that?"],
		["VERA", "None of them knew when to cash out. You did. Mostly. Twice. In a row. It's a miracle. Don't push it."]]},
	{"id": "vera_eddie", "who": "VERA", "pri": 85, "req": {"min": {"tickets": 14}}, "lines": [
		["VERA", "Eddie Duval. You've been reading his tickets, haven't you."],
		["VERA", "Best player I ever dealt to. Never walked away from a table. Not once. Not even when it caught fire."],
		["VERA", "Now he IS the table. That voice on the PA? That's what's left of Eddie. It's mostly interest."]]},
	{"id": "vera_rep1", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "Charms don't make you lucky. They make you less unlucky. It's a very small difference. It's the whole business."]]},
	{"id": "vera_rep2", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "The House always wins. Eventually. Your job is to leave before eventually. Mine's to sell you a ticket."]]},
	{"id": "vera_rep3", "who": "VERA", "pri": 0, "rep": true, "lines": [["VERA", "Everything's for sale, sugar. Advice included. Advice especially. Advice is the high-margin item."]]},

	# ------------------------------------------------------------ MAGS (the Loan Shark)
	{"id": "mags_intro", "who": "MAGS", "pri": 100, "flags": ["met_mags"], "lines": [
		["MAGS", "Name's Mags. I hold the Markers at the door, and yours says The House owns your bones until you settle up."],
		["MAGS", "Short on chips? I lend. Two hundred now, three hundred back by the end of floor three. It's a friendship with numbers."],
		["MAGS", "Pay me when you cash out. Miss the date and I come collecting. Personally. Through walls."],
		["RICO", "You're a shark. In a suit."],
		["MAGS", "And you're a runner with no money. We all have our problems. Mine are on your wrist."]]},
	{"id": "mags_repaid", "who": "MAGS", "pri": 70, "req": {"min": {"repaid": 1}}, "lines": [
		["MAGS", "You paid me back on time. Respect. You'd be amazed how few do. Most of them are in the aquarium."]]},
	{"id": "mags_default", "who": "MAGS", "pri": 75, "req": {"min": {"defaulted": 1}}, "lines": [
		["MAGS", "About that chase. Nothing personal. Interest isn't personal, kid. It's just math with teeth. And, tonight, a little fin."]]},
	{"id": "mags_big_loss", "who": "MAGS", "pri": 72, "req": {"min": {"last_lost": 1000}}, "lines": [
		["MAGS", "Saw you drop a thousand at the door. If you'd banked that, you'd have... well. You'd have me. Nodding. Slowly."]]},
	{"id": "mags_rates", "who": "MAGS", "pri": 60, "req": {"min": {"runs": 8}}, "lines": [
		["MAGS", "Between you and me? The House charges interest on every bust. Compounding. Forever."],
		["MAGS", "Even I think that's ugly. And I'm a loan shark. Literally. It says so on the jacket."]]},
	{"id": "mags_ending", "who": "MAGS", "pri": 85, "req": {"flag": ["ending"]}, "lines": [
		["MAGS", "You beat The House and it's still standing. That's interest for you, kid. It keeps things alive. Like a bad marriage."]]},
	{"id": "mags_rep1", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "Borrow smart. Ride dumb. That's a joke. Don't do that. That's also a joke. Pay up."]]},
	{"id": "mags_rep2", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "My rates are fair. The House's rates are a crime. I would know. I'm a connoisseur."]]},
	{"id": "mags_rep3", "who": "MAGS", "pri": 0, "rep": true, "lines": [["MAGS", "A shark has to keep swimming. So do you. It's a threat. It's also a life tip."]]},

	# ------------------------------------------------------------ LUCKY (Lobby bar)
	{"id": "lucky_intro", "who": "LUCKY", "pri": 100, "lines": [
		["LUCKY", "Lucky's the name. On the floors I pour drinks. Up here I just listen."],
		["LUCKY", "Everybody busts eventually. Barkeeps hear all about it. It's the worst part of the job and the only part."]]},
	{"id": "lucky_tip", "who": "LUCKY", "pri": 50, "req": {"min": {"runs": 3}}, "lines": [
		["LUCKY", "Pro tip: a Shot of Courage costs less than the interest on a bust. Find my bar on the floors. I have a lot of bars. I have trust issues."]]},
	{"id": "lucky_cat", "who": "LUCKY", "pri": 55, "req": {"min": {"cat_pets": 3}}, "lines": [
		["LUCKY", "Keep petting Comp like that and he'll follow you up. ...He won't. He's a cat. But he likes you. It's creepy."]]},
	{"id": "lucky_rep1", "who": "LUCKY", "pri": 0, "rep": true, "lines": [["LUCKY", "On the house? Nothing's on the house. That's the House's whole thing. It's in the name."]]},
	{"id": "lucky_rep2", "who": "LUCKY", "pri": 0, "rep": true, "lines": [["LUCKY", "You've got the look of somebody about to let it ride. Tell me when. I'll film it."]]},

	# ------------------------------------------------------------ JULES (after the ending)
	{"id": "jules_home", "who": "JULES", "pri": 100, "req": {"flag": ["ending"]}, "lines": [
		["JULES", "Rico. I keep waking up in the apartment. Old habits. The House still thinks I owe it. Which, to be fair, I do."],
		["JULES", "Thanks for coming for me. Now let me come with you. Pick me on the title screen. I hit harder than you. I also steal."]]},
	{"id": "jules_eddie", "who": "JULES", "pri": 80, "req": {"flag": ["ending"], "min": {"tickets": 10}}, "lines": [
		["JULES", "Those losing tickets are Eddie Duval's trail. I dealt to that voice every night for three years."],
		["JULES", "He doesn't want our money. He wants somebody to finally beat him so he can stop. It's the saddest ten-second pitch I've ever heard."]]},
	{"id": "jules_rep1", "who": "JULES", "pri": 0, "rep": true, "req": {"flag": ["ending"]}, "lines": [["JULES", "Bank it, Rico. I didn't. Look where it got me. A very comfortable cell with a view."]]},
	{"id": "jules_rep2", "who": "JULES", "pri": 0, "rep": true, "req": {"flag": ["ending"]}, "lines": [["JULES", "The House cheats. So we cheat better. That's called family values."]]},
]

## The House over the PA. Keys are events fired from main._bark().
const BARKS := {
	"lobby": ["Welcome to the apartment. The House appreciates your continued mismanagement.", "No one dies owing the House. That would be bad for business. And for the carpet."],
	"wake": ["Welcome back, valued guest. Your tab has been adjusted. Upward.", "Back so soon? The House never forgets a debtor. Or their birthday.", "Interest applied. Smile, it's compounding."],
	"wake_spikes": ["Attention guests: Rico was defeated by a spike. The spike's drinks are on the house."],
	"wake_guard": ["Security reminds guests that punching is a privilege, not a right. It's also a fee."],
	"wake_bat": ["The rats thank you for your generous contribution. Your femur was delicious."],
	"wake_boss1": ["The first table sends its regards. And an invoice. And a card."],
	"wake_boss2": ["Another table won. By us. The House is pleased. The House is a little giggly."],
	"wake_boss3": ["So close. The House admires ambition. The House also keeps it. In a drawer."],
	"wake_mags": ["Our partners in lending thank you for your patience. And your future."],
	"wake_big": ["That Pot was beautiful. It's mine now. Thank you. Please come again. Please come poorer."],
	"start": ["Doors are open. Mind the spikes. Or don't. The House has a bet on 'don't.'", "Another guest begins the climb. How wonderful for me."],
	"ride": ["Let it ride? Oh, I LIKE you. You're my favorite income stream.", "Bold. The House adores bold. Bold has margins."],
	"ride8": ["Attention guests: we have a high roller on the floor! Please applaud and then pick his pockets!"],
	"cashout": ["Playing it safe. How... responsible. Ugh. Disgusting.", "Walking away? The House will remember this. The House has a spreadsheet."],
	"jackpot": ["Who rigged that machine? WHO RIGGED THAT MACHINE? Was it Gerald? It was Gerald."],
	"low_hp": ["One life left. The House recommends praying. The House recommends a will.", "Feeling lucky? You shouldn't. The House checked."],
	"boss": ["Ladies and gentlemen... the main event. Please clap. Please bet."],
	"vault_open": ["Somebody check the safe. WHY IS THE SAFE OPEN. WHO WANTS A DEMOTION."],
	"vault_miss": ["The safe has sealed. Punctuality is a virtue, guest. So is not losing."],
	"loan_due": ["Attention guests: a loan is past due. Please keep hands, feet and dignity inside the casino."],
	"spill": ["Butterfingers!", "Chips on the floor! Finders keepers. And losers weepers."],
	"bet_won": ["A side bet paid out. The House is fine. Totally fine. The House needs to lie down."],
	"bet_lost": ["Side bet lost. Tragic. Delicious. Both at once."],
	"cat": ["Please do not pet the cat. The cat is a House employee. He's on a performance review.", "The cat likes you. The cat is wrong. The cat has a bad track record with people."],
	"daily": ["Today's Daily Deal: the same cards for everyone. Fairness! How quaint. How off-brand."],
	"stakes": ["Raising the stakes? The House salutes your poor judgment. And your life insurance."],
	"ticket": ["Littering is a violation of House policy. Reading it is worse. Remembering it is murder."],
	"charm": ["A charm? Cute. The House has charms too. They're called interest rates."],
}

const TICKETS := [
	"Bet it all on red. It was black. It's always black. It's the one color I'm good at. -D.",
	"Day 3. The rats aren't the worst part. The worst part is the elevator music. The rats agree.",
	"If you find this: bank on floor 2. Nobody banks on floor 2. That's why it works. Don't tell the House I said that.",
	"Lost my watch, my car, and my brother's watch. Note to self: stop. Note to self: you won't.",
	"The slot by the stairs paid out twice in a row. I named it Gerald. Gerald is my only friend. Gerald tried to bite me.",
	"The first boss used to work the door downstairs. Then one night he let it ride. And he's a boss now. Moral: never let it ride.",
	"Dealers never blink. I watched for an hour. They never blink. I blinked. They noted it.",
	"My Marker says I owe the House 'one evening.' It has been eleven years. The evening is going great.",
	"Eddie Duval was here. Eddie Duval never cashes out. -E.D.",
	"Jules, if you're reading this: your brother's coming. Hang on. And please stop betting your shoes. -M.",
	"The old dealers whisper that the House used to be a man. They also whisper that he's single.",
	"QUEEN OF SPADES. A playing card folded inside this ticket. The back is signed: 'V. Vex, Marker #1.'",
	"Eddie bet the deed to his own club against the House. He won. Then he bet it again. The sequel was worse.",
	"Every time Eddie won, he let it ride. Every time. The tables got bigger. Eddie got quieter. Eddie also got shorter.",
	"Nobody saw Eddie lose. One night the lights flickered and the PA started talking in his voice. The jokes got worse.",
	"The House doesn't want your money. It wants you to keep playing. That's what feeds it. Also, it likes your money.",
	"Mags says interest is what keeps the House alive. I think she's scared of it too. She sleeps with the light on. Under the water.",
	"If the House ever loses big enough, I think Eddie finally gets to leave. Or explode. I'm okay with either. -V.",
	"Saw a runner bank everything on floor 1 and walk out the front door. The House screamed for an hour. We all clapped.",
	"Know when to walk away. Know when to let it ride. Eddie only ever learned one. Bet you can't guess. -D.",
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
