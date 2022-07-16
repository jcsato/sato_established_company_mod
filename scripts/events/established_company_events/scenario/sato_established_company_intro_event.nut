sato_established_company_intro_event <- inherit("scripts/events/event", {
	m = {},
	function create()
	{
		local introText1 = "[img]gfx/ui/events/event_23.png[/img]The bar patron looks at you hazily through drunken eyes.%SPEECH_ON%Eh? Wassat? The %companyname%? Never 'erd of ya. Ya some kind of minstrels? Heh. Hehehe. Minstrels. You know, I once knew a lad...%SPEECH_OFF%You stop listening and grimace as the man\'s breath washes over you. Brushing past him, you motion to %bro% and walk out of the bar. This won\'t do. The company has had it\'s fair share of successes and failures both - a respectable showing, really - but you have loftier goals than being mistaken for a group of lute-luggers by the drunk. It\'s time to change your approach. You\'re not sure how, just yet, but you\'ll see the %companyname% reach fame and fortune if it\'s the last thing you do!";
		local introText2 = "[img]gfx/ui/events/event_15.png[/img]You try your best to ignore the scritch-scratch of the scribe\'s quill, but despite your efforts it really does begin to grate on your ears.%SPEECH_ON%Let\'s see now...the %rivalcompany1% were successful in their valiant defense of the lord\'s flank. Truly, their sacrifice was not in vain, for their bulwark shielded the pikemen long enough to...%SPEECH_OFF%The man mutters to himself, recounting the recent moments of note in %battlename%.%SPEECH_ON%The %rivalcompany2% had their pay docked and were driven out of the keep by his lordship for their shameful retreat, and for their failure to properly endure the enemy bombardment as they-%SPEECH_OFF%You cut the man off and ask what he intends to write of the %companyname%. The man looks up at you with mottled eyes, trying to mask his confusion with a kindly smile.%SPEECH_ON%Er, the %companyname%, you say? Yes, well, they fought...admirably...%SPEECH_OFF%Admirably? As you remember it, if not for the company the whole center line would have collapsed. You spit in disgust and stomp out. You don\'t intend to let the scribes - or anyone else, for that matter - shortchange the company\'s accomplishments for long. You quickly find %bro% and tell him to get the others ready to move out. You have fame to seize!";
		local introText3 = "[img]gfx/ui/events/event_31.png[/img]The noble has apparently discovered something fascinating about his fingernails and won\'t stop staring at them.%SPEECH_ON%The %companyname%, you say? Aye, I\'ve heard you, mercenary, here and there. I\'m sure your band\'s history is quite illustrious and respectable once one gets to know it.%SPEECH_OFF%You thank him for the empty compliment and ask if he\'s prepared to negotiate, despite knowing his answer before he gives it.%SPEECH_ON%Yes, well, you see, I make it a point to only work with sellswords of...renown. It\'s a matter of appearances, you see, I can\'t be seen hiring just anybody. I\'m afraid you\'ll need to be a little better known, a little, hmm, more widely traveled, more experienced, before I can take you on. Impressive though I\'m sure your history is.%SPEECH_OFF%You grit your teeth while he drawls on about the burdens of nobility, his gaze never once leaving his fingers to turn towards you. This cannot stand. You\'ve brought the company this far. You won\'t let the %companyname% go unknown and dwindle in obscurity while blood still flows in you. Once freed, you find %bro% and immediately begin drawing up new plans for the men.";

		m.ID = "event.sato_established_company_scenario_intro";
		m.IsSpecial = true;
		m.Screens.push({
			ID = "A",
			Text = "{ " + introText1 + " | " + introText2 + " | " + introText3 + " }",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To glory!",
					function getResult( _event ) { return 0; }
				}
			],
			function start( _event )
			{
				Banner = "ui/banners/" + World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		m.Title = "Established Company";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = World.getPlayerRoster().getAll();

		_vars.push([ "bro", brothers[brothers.len() - 1].getName() ]);
		_vars.push([ "rivalcompany1", Const.Strings.MercenaryCompanyNames[Math.rand(0, Const.Strings.MercenaryCompanyNames.len() - 1)] ]);
		_vars.push([ "rivalcompany2", Const.Strings.MercenaryCompanyNames[Math.rand(0, Const.Strings.MercenaryCompanyNames.len() - 1)] ]);
		_vars.push([ "battlename", World.Statistics.getFlags().get("SatoEstablishedCompanyBattleName") ]);
	}

	function onClear()
	{
	}

});
