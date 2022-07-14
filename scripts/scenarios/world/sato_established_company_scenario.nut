sato_established_company_scenario <- inherit("scripts/scenarios/world/starting_scenario", {
	m = {
		MoodEffects = null
	},
	function create()
	{
		m.ID = "scenario.sato_established_company";
		m.Name = "Established Company";
		m.Description = "[p=c][img]gfx/ui/events/event_64.png[/img][/p][p]You\'ve led your mercenary company for some time now, and have established a reputation yourself - sometimes for good, sometimes for ill. You won\'t stop until you hear the company\'s name sung by the bards, written by the scribes, and spoken with reverence all around the world!\n\n[color=#bcad8c]A quick start into the world, without any particular advantages or disadvantages.[/color][/p]";
		m.Difficulty = 1;
		m.Order = 15;
	}

	function onSpawnAssets()
	{
		local roster = World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(Const.Strings.CharacterNames[Math.rand(0, Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		generateBattleName();
		generateChampionName();

		m.MoodEffects = [
			{ positive = false, magnitude = 0.5, reason = "Lost his trusty weapon in a retreat" },
			{ positive = false, magnitude = 0.5, reason = "Was mocked for not being able to whistle" },
			{ positive = true, magnitude = 0.5, reason = "Felt better about himself due to his singing talent" },
			{ positive = true, magnitude = 1.0, reason = "Bedded a duke\'s wife and lived" },
			{ positive = false, magnitude = 1.0, reason = "His sweetheart left him for another man" },
			{ positive = true, magnitude = 1.0, reason = "Found new love" },
			{ positive = true, magnitude = 0.5, reason = "Had the best meal of his life" },
			{ positive = false, magnitude = 0.5, reason = "Hasn\'t slept well in weeks" },
			{ positive = true, magnitude = 0.5, reason = "Gained confidence in his abilities" },
			{ positive = true, magnitude = 0.5, reason = "Learned about saving for retirement" },
			{ positive = false, magnitude = 0.5, reason = "Realized he has no savings" },
			{ positive = true, magnitude = 0.5, reason = "Learned how to operate a loom" },
			{ positive = false, magnitude = 0.5, reason = "Forgot how to spell his name" },
			{ positive = true, magnitude = 1.0, reason = "Learned a new combat technique" },
			{ positive = false, magnitude = 1.0, reason = "His father died" },
			{ positive = true, magnitude = 1.0, reason = "His cousin died" },
			{ positive = true, magnitude = 0.5, reason = "Learned to play an instrument" },
			{ positive = true, magnitude = 1.0, reason = "Led the company to victory against " + World.Statistics.getFlags().get("SatoEstablishedCompanyChampionName") },
			{ positive = false, magnitude = 1.0, reason = "Lost many comrades in " + World.Statistics.getFlags().get("SatoEstablishedCompanyBattleName") },
			{ positive = true, magnitude = 0.5, reason = "Proved himself in battle" }
		];

		local bros = roster.getAll();
		bros[0].setStartValuesEx(getLowbornBackgrounds());
		if (Math.rand(1, 100) <= 20) {
			local levelUpTo = bros[0].getLevel() + Math.rand(1, 2);
			bros[0].m.PerkPoints = levelUpTo - 1;
			bros[0].m.LevelUps = levelUpTo - 1;
			bros[0].m.Level = levelUpTo;
		}
		getRandomMoodEffects(bros[0], false);
		bros[0].setPlaceInFormation(3);

		bros[1].setStartValuesEx(getMundaneBackgrounds());
		if (Math.rand(1, 100) <= 20) {
			local levelUpTo = bros[1].getLevel() + Math.rand(1, 2);
			bros[1].m.PerkPoints = levelUpTo - 1;
			bros[1].m.LevelUps = levelUpTo - 1;
			bros[1].m.Level = levelUpTo;
		}
		getRandomMoodEffects(bros[1], false);
		bros[1].setPlaceInFormation(4);

		local isBroInjured = Math.rand(1, 100) <= 50;
		bros[2].setStartValuesEx(getCombatBackgrounds(!isBroInjured));
		if (isBroInjured) {
			local injury = new("scripts/skills/" + Const.Injury.Permanent[Math.rand(0, Const.Injury.Permanent.len() - 1)].Script);
			bros[2].getSkills().add(injury);

			bros[2].getBackground().m.RawDescription += "\n\nThe man was struck down in " + (Math.rand(0, 1) < 1 ? World.Statistics.getFlags().get("SatoEstablishedCompanyBattleName") : "the fight against " + World.Statistics.getFlags().get("SatoEstablishedCompanyChampionName")) + ". The medics were able to save his life, but the injuries from the fight remain with him.";
		}
		if (Math.rand(1, 100) <= 20 + (isBroInjured ? 13 : 0)) {
			local levelUpTo = bros[2].getLevel() + 1;
			bros[2].m.PerkPoints = levelUpTo - 1;
			bros[2].m.LevelUps = levelUpTo - 1;
			bros[2].m.Level = levelUpTo;
		}
		getRandomMoodEffects(bros[2], isBroInjured);
		bros[2].setPlaceInFormation(5);

		local foodBudget = Math.rand(100, 140) - (World.Assets.getEconomicDifficulty() * 20);
		local foodItems = getFoodItems(foodBudget);
		foreach (foodItem in foodItems) {
			World.Assets.getStash().add(foodItem);
		}

		local businessReputation = Math.floor(Math.rand(100, 300) * 0.1) * 10;
		World.Assets.m.BusinessReputation = businessReputation;

		local moralReputation = Math.rand(30, 70);
		World.Assets.m.MoralReputation = moralReputation;

		local moneyModifer = Math.rand(300, 500) - (World.Assets.getEconomicDifficulty() * 200);
		foreach (bro in bros) {
			local broHasInjury = bro.getSkills().hasSkillOfType(Const.SkillType.Injury);
			local broMoneyModifier = Math.min(500, bro.getBackground().m.HiringCost) * Math.max(1, (bro.getLevel() - (1 * (broHasInjury ? 1 : 0))));

			moneyModifer -= broMoneyModifier;
		}
		World.Assets.m.Money = Math.floor((World.Assets.m.Money + moneyModifer) * 0.1) * 10;
		if (World.Assets.m.Money < 100)
			World.Assets.Money = Math.floor(Math.rand(100, 300) * 0.1) * 10;

		local toolResources = 110 - (World.Assets.getEconomicDifficulty() * 30);

		World.Assets.m.ArmorParts = Math.rand(0, toolResources);
		toolResources -= World.Assets.m.ArmorParts;
		World.Assets.m.Medicine = Math.rand(0, toolResources);
		toolResources -= World.Assets.m.Medicine;
		World.Assets.m.Ammo = toolResources;

		m.MoodEffects = null;
	}

	function getLowbornBackgrounds() {
		local LOWBORN_BACKGROUNDS = [
			"beggar_background",
			"butcher_background",
			"cripple_background",
			"daytaler_background",
			"farmhand_background",
			"fisherman_background",
			"gravedigger_background",
			"graverobber_background",
			"houndmaster_background",
			"lumberjack_background",
			"miller_background",
			"miner_background",
			"peddler_background",
			"poacher_background",
			"ratcatcher_background",
			"refugee_background",
			"shepherd_background",
			"tailor_background",
			"thief_background",
			"vagabond_background"
		];

		if (Const.DLC.Desert) {
			LOWBORN_BACKGROUNDS.extend([
				"beggar_southern_background",
				"butcher_southern_background",
				"cripple_southern_background",
				"daytaler_southern_background",
				"fisherman_southern_background",
				"manhunter_background",
				"peddler_southern_background",
				"shepherd_southern_background",
				"tailor_southern_background",
				"thief_southern_background"
			]);
		}

		return LOWBORN_BACKGROUNDS;
	}

	function getMundaneBackgrounds() {
		local MUNDANE_BACKGROUNDS = [
			"anatomist_background",
			"apprentice_background",
			"bowyer_background",
			"cultist_background",
			"eunuch_background",
			"flagellant_background",
			"gambler_background",
			"historian_background",
			"juggler_background",
			"mason_background",
			"messenger_background",
			"minstrel_background",
			"monk_background",
			// "pimp_background",  // THEY DON'T HAVE BACKGROUND STORIES GENERATED FOR THEM NOOOO
			"servant_background"
		];

		if (Const.DLC.Desert) {
			MUNDANE_BACKGROUNDS.extend([
				"eunuch_southern_background",
				"gambler_southern_background",
				"historian_southern_background",
				"juggler_southern_background",
				"servant_southern_background"
			]);
		}

		return MUNDANE_BACKGROUNDS;
	}

	function getCombatBackgrounds(lowOnly = true) {
		local COMBAT_BACKGROUNDS = [
			"bastard_background",
			"brawler_background",
			"caravan_hand_background",
			"deserter_background",
			"disowned_noble_background",
			"killer_on_the_run_background",
			"wildman_background",
			"witchhunter_background"
		];

		if (!lowOnly) {
			COMBAT_BACKGROUNDS = [
				"adventurous_noble_background",
				"militia_background",
				"hedge_knight_background",
				"hunter_background",
				"paladin_background",
				"raider_background",
				"retired_soldier_background",
				"sellsword_background",
				"squire_background",
				"swordmaster_background"
			];
		}

		if (Const.DLC.Unhold && !lowOnly) {
			COMBAT_BACKGROUNDS.extend([
				"beast_hunter_background"
			]);
		};

		if (Const.DLC.Wildmen && !lowOnly) {
			COMBAT_BACKGROUNDS.extend([
				"barbarian_background"
			]);
		};

		if (Const.DLC.Desert && !lowOnly) {
			COMBAT_BACKGROUNDS.extend([
				"assassin_southern_background"
				"gladiator_background",
				"nomad_background",
				"nomad_ranged_background"
			]);
		};

		return COMBAT_BACKGROUNDS;
	}

	function generateBattleName() {
		local regionIndex = Math.rand(0, Const.Strings.TerrainRegionNames.len() - 1);
		while (Const.Strings.TerrainRegionNames[regionIndex].len() <= 0) {
			regionIndex = Math.rand(0, Const.Strings.TerrainRegionNames.len() - 1);
		}
		local regionList = Const.Strings.TerrainRegionNames[regionIndex]
		local regionName = removeFromBeginningOfText("The ", removeFromBeginningOfText("the ", regionList[Math.rand(0, regionList.len() - 1)]));

		local battleName = "The Battle of the " + regionName;

		World.Statistics.getFlags().set("SatoEstablishedCompanyBattleName", battleName);
	}

	function generateChampionName() {
		local championName = "";
		local championType = Math.rand(1, 4);

		if (championType == 1)
			championName = Const.World.Common.generateName(Const.Strings.BanditLeaderNames);
		else if (championType == 2)
			championName = Const.World.Common.generateName(Const.Strings.BarbarianNames) + " " + Const.Strings.BarbarianTitles[Math.rand(0, Const.Strings.BarbarianTitles.len() - 1)];
		else if (championType == 3)
			championName = Const.Strings.SouthernNames[Math.rand(0, Const.Strings.SouthernNames.len() - 1)] + " " + Const.Strings.NomadChampionTitles[Math.rand(0, Const.Strings.NomadChampionTitles.len() - 1)];
		else if (championType == 4)
			championName = Const.World.Common.generateName(Const.Strings.KnightNames) + " " + Const.Strings.FallenHeroTitles[Math.rand(0, Const.Strings.FallenHeroTitles.len() - 1)];

		World.Statistics.getFlags().set("SatoEstablishedCompanyChampionName", championName);
	}

	function getRandomMoodEffects(bro, hasInjury = false) {
		local extraMoodEffects = [];

		if (Math.rand(1, 100) <= 33) {
			if (bro.getBackground().getID() == "background.cultist") {
				if (Math.rand(1, 100) <= 50) {
					extraMoodEffects.extend([
						{ positive = true, magnitude = 1.0, reason = "Was given a vision of greatness from Davkul" }
					]);
				} else {
					extraMoodEffects.extend([
						{ positive = false, magnitude = 1.0, reason = "Had a terrifying vision from Davkul" }
					]);
				}
			} else if (bro.getBackground().getEthnicity() == 1) {
				if (Math.rand(1, 100) <= 50) {
					extraMoodEffects.extend([
						{ positive = true, magnitude = 1.0, reason = "Was given a vision of greatness from the Gilder" }
					]);
				} else {
					extraMoodEffects.extend([
						{ positive = false, magnitude = 1.0, reason = "Had a terrifying vision from the Gilder" }
					]);
				}
			} else {
				if (Math.rand(1, 100) <= 50) {
					extraMoodEffects.extend([
						{ positive = true, magnitude = 1.0, reason = "Was given a vision of greatness from the Old Gods" }
					]);
				} else {
					extraMoodEffects.extend([
						{ positive = false, magnitude = 1.0, reason = "Had a terrifying vision from the Old Gods" }
					]);
				}
			}
		}

		if (hasInjury) {
			extraMoodEffects.extend([
				{ positive = true, magnitude = 0.5, reason = "Learned to live with his injuries" },
				{ positive = false, magnitude = 1.0, reason = "Was forever changed by an injury" },
			]);
		}

		local numEffects = Math.rand(2, 3);
		for ( local i = 0; i < numEffects && m.MoodEffects.len() > 0; i = ++i ) {
			local useExtraEffect = extraMoodEffects.len() > 0 && Math.rand(1, 100) <= 33;
			local moodEffect = useExtraEffect ? extraMoodEffects.remove(Math.rand(0, extraMoodEffects.len() - 1)) : m.MoodEffects.remove(Math.rand(0, m.MoodEffects.len() - 1));

			if (!useExtraEffect) {
				local currentMoodState = bro.getMoodState();

				if (currentMoodState < Const.MoodState.Concerned) {
					while (!moodEffect.positive) {
						m.MoodEffects.push(moodEffect);
						moodEffect = m.MoodEffects.remove(Math.rand(0, m.MoodEffects.len() - 1));
					}
				}

				if (currentMoodState > Const.MoodState.InGoodSpirit) {
					while (moodEffect.positive) {
						m.MoodEffects.push(moodEffect);
						moodEffect = m.MoodEffects.remove(Math.rand(0, m.MoodEffects.len() - 1));
					}
				}
			}

			moodEffect.positive ? bro.improveMood(moodEffect.magnitude, moodEffect.reason) : bro.worsenMood(moodEffect.magnitude, moodEffect.reason);
		}
	}

	function getRelationsListFor(_relationsType, _positive) {
		if (_relationsType == 1) {
			if (_positive) {
				return [
					"Helped them fight off bandits",
					"Found missing villagers",
					"Killed the beasts slaughtering their livestock",
					"Protected caravans on their trade routes",
					"Returned an artifact to them",
					"Slew a witch terrorizing them",
					"Delivered cargo for the trade master",
					"Helped some kids who were stuck on a roof",
					"Impressed the locals with your showmanship",
					"Sold them a miracle cure",
					"Negotiated with the tax collector on their behalf",
					"Trained their militia"
				];
			} else {
				return [
					"Raided their granaries",
					"Killed some of their villagers",
					"Caused trouble in the tavern",
					"Raided their caravans",
					"Stole an artifact from them",
					"They think you\'re in league with witches",
					"One of your men put out a villager\'s eye",
					"A basket weaving contest went horribly wrong",
					"Annoyed some of the locals",
					"Tried to grift them with snake oil",
					"Exposed their militia as incompetent"
				];
			}
		}

		if (_relationsType == 2) {
			if (_positive) {
				return [
					"Helped bring them victory in " + World.Statistics.getFlags().get("SatoEstablishedCompanyBattleName"),
					"Ended the scourge of " + World.Statistics.getFlags().get("SatoEstablishedCompanyChampionName"),
					"Protected one of their lords from assassins on the road",
					"Slew marauding greenskins in their territory",
					"Protected one of their emissaries to the south",
					"Reunited a duke with his wayward son",
					"Saved their soldiers being overwhelmed by bandits"
				];
			} else {
				return [
					"One of your men bed a duke\'s wife",
					"There are rumors you raided their supply caravans",
					"Failed to protect one of their emissaries",
					"Embarrassed a noble in front of his peers",
					"Stopped a plot to assassinate a troublesome bastard",
					"Embarrassed their soldiers in training"
				];
			}
		}

		if (_relationsType == 3) {
			if (_positive) {
				return [
					"Impressed the vizier with your performance in the arena",
					"Protected merchants from snakes outside the city",
					"Slew nomads defying their rule",
					"Put down a slave insurrection",
					"Helped a vizier find the woman of his dreams",
					"Some of your men renounced the Old Gods"
				];
			} else {
				return [
					"Disappointed the vizier with your poor arena performance",
					"One of your men bedded a woman promised to a high-ranking official",
					"Your men injured a famous gladiatior",
					"Your men profaned the Gilder",
					"Freed a group of Indebted from manhunters"
				];
			}
		}
	}

	function getFoodItems(crowns) {
		local FOOD_ITEMS = [
			"bread_item",
			"cured_rations_item",
			"cured_venison_item",
			"dried_fish_item",
			"dried_fruits_item",
			"goat_cheese_item",
			"ground_grains_item",
			"mead_item",
			"pickled_mushrooms_item",
			"roots_and_berries_item",
			"smoked_ham_item",
			"wine_item"
		];

		if (Const.DLC.Desert) {
			FOOD_ITEMS.extend([
				"dates_item",
				"dried_lamb_item",
				"rice_item"
			]);
		}

		local foodItemsToAdd = [];

		while (crowns >= 50) {
			local foodItem = new("scripts/items/supplies/" + FOOD_ITEMS[Math.rand(0, FOOD_ITEMS.len() - 1)]);
			foodItem.randomizeAmount();
			foodItem.randomizeBestBefore();
			foodItemsToAdd.push(foodItem);
			crowns -= foodItem.getValue();
		}

		return foodItemsToAdd;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 2)
				break;
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = World.getNavigator().createSettings();
		navSettings.ActionPointCosts = Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = Math.rand(Math.max(2, randomVillageTile.SquareCoords.X - 4), Math.min(Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = Math.rand(Math.max(2, randomVillageTile.SquareCoords.Y - 4), Math.min(Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!World.isValidTileSquare(x, y))
				continue;
			else
			{
				local tile = World.getTileSquare(x, y);

				if (tile.Type == Const.World.TerrainType.Ocean || tile.Type == Const.World.TerrainType.Shore || tile.IsOccupied)
					continue;
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
					continue;
				else
				{
					local path = World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		local settlements = World.FactionManager.getFactionsOfType(Const.FactionType.Settlement);
		foreach (settlement in settlements) {
			local numModifiers = Math.rand(0, 2);
			local positiveVillageRelations = getRelationsListFor(1, true);
			local negativeVillageRelations = getRelationsListFor(1, false);

			for ( local i = 0; i < numModifiers; i = ++i ) {
				local isModifierPositive = Math.rand(1, 100) > 40;
				local modifierMagnitude = Math.rand(2, 10) * (isModifierPositive ? 1 : -1);
				local modifierReason = isModifierPositive ? positiveVillageRelations.remove(Math.rand(0, positiveVillageRelations.len() - 1)) : negativeVillageRelations.remove(Math.rand(0, negativeVillageRelations.len() - 1))
				settlement.addPlayerRelation(modifierMagnitude, modifierReason);
			}
		}

		local owningFaction = randomVillage.getOwner();
		local nobles = World.FactionManager.getFactionsOfType(Const.FactionType.NobleHouse);
		local hostileNoble = null;
		while (hostileNoble == null) {
			local hostileNobleIndex = Math.rand(0, nobles.len() - 1);
			if (owningFaction.getID() != nobles[hostileNobleIndex].getID()) {
				hostileNoble = nobles.remove(hostileNobleIndex);
				hostileNoble.setPlayerRelation(50.0);
				local severeRelationsReasons = [
					"You betrayed them in " + World.Statistics.getFlags().get("SatoEstablishedCompanyBattleName"),
					"You slew one of their lords in battle",
					"You helped a rival conquer one of their villages",
					"You kidnapped a noble family for ransom"
				];
				hostileNoble.addPlayerRelation(Math.rand(-45.0, -40.0), severeRelationsReasons[Math.rand(0, severeRelationsReasons.len() - 1)]);
			}
		}
		foreach (noble in nobles) {
			noble.setPlayerRelation(50.0);
			local numModifiers = Math.rand(1, 2);
			local positiveNobleRelations = getRelationsListFor(2, true);
			local negativeNobleRelations = getRelationsListFor(2, false);

			for ( local i = 0; i < numModifiers; i = ++i ) {
				local isModifierPositive = Math.rand(1, 100) > 30;
				local modifierMagnitude = Math.rand(8, 14) * (isModifierPositive ? 1 : -1);
				local modifierReason = isModifierPositive ? positiveNobleRelations.remove(Math.rand(0, positiveNobleRelations.len() - 1)) : negativeNobleRelations.remove(Math.rand(0, negativeNobleRelations.len() - 1))
				noble.addPlayerRelation(modifierMagnitude, modifierReason);
			}
		}

		local cityStates = World.FactionManager.getFactionsOfType(Const.FactionType.OrientalCityState);
		local unfriendlyCityState = null;
		while (unfriendlyCityState == null) {
			local unfriendlyCityStateIndex = Math.rand(0, cityStates.len() - 1);
			if (owningFaction.getID() != cityStates[unfriendlyCityStateIndex]) {
				unfriendlyCityState = cityStates.remove(unfriendlyCityStateIndex);
				unfriendlyCityState.setPlayerRelation(50.0);
				local severeRelationsReasons = [
					"You accidentally slighted the vizier in public",
					"You despoiled one of their holy sites",
					"You helped a vizier\'s harem escape into the desert"
				];
				unfriendlyCityState.addPlayerRelation(Math.rand(-35.0, -25.0), severeRelationsReasons[Math.rand(0, severeRelationsReasons.len() - 1)]);
			}
		}
		foreach (cityState in cityStates) {
			cityState.setPlayerRelation(50.0);
			local numModifiers = Math.rand(1, 2);
			local positiveSouthernRelations = getRelationsListFor(3, true);
			local negativeSouthernRelations = getRelationsListFor(3, false);

			for ( local i = 0; i < numModifiers; i = ++i ) {
				local isModifierPositive = Math.rand(1, 100) > 30;
				local modifierMagnitude = Math.rand(5, 10) * (isModifierPositive ? 1 : -1);
				local modifierReason = isModifierPositive ? positiveSouthernRelations.remove(Math.rand(0, positiveSouthernRelations.len() - 1)) : negativeSouthernRelations.remove(Math.rand(0, negativeSouthernRelations.len() - 1))
				cityState.addPlayerRelation(modifierMagnitude, modifierReason);
			}
		}

		World.State.m.Player = World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		World.getCamera().setPos(World.State.m.Player.getPos());
		Time.scheduleEvent(TimeUnit.Real, 1000, function ( _tag )
		{
			Music.setTrackList(Const.Music.IntroTracks, Const.Music.CrossFadeTime);
			World.Events.fire("event.sato_established_company_scenario_intro");
		}, null);
	}

	function onInit() {
		if (!(World.Statistics.getFlags().get("SatoEstablishedCompanyEventsAdded")))
		{
			local mundaneEvents = IO.enumerateFiles("scripts/events/established_company_events");
			foreach ( i, event in mundaneEvents ) {
				local instantiatedEvent = new(event);
				World.Events.m.Events.push(instantiatedEvent);
			};
		}
		World.Statistics.getFlags().set("SatoEstablishedCompanyEventsAdded", true);
	}
});

