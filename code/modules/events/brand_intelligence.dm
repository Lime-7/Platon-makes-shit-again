/datum/round_event_control/brand_intelligence
	name = "Brand Intelligence"
	typepath = /datum/round_event/brand_intelligence
	weight = 5
	category = EVENT_CATEGORY_AI
	description = "Vending machines will attack people until the Patient Zero is disabled."
	min_players = 15
	max_occurrences = 1
	min_wizard_trigger_potency = 2
	max_wizard_trigger_potency = 6
	admin_setup = list(/datum/event_admin_setup/listed_options/brand_intelligence)

/datum/round_event/brand_intelligence
	announce_when = 21
	end_when = 1000 //Ends when all vending machines are subverted anyway.
	/// Admin picked subtype for what kind of vendor goes haywire.
	var/chosen_vendor_type
	/// All vending machines valid to get infected.
	var/list/obj/machinery/vending/vending_machines = list()
	/// All vending machines that have been infected.
	var/list/obj/machinery/vending/infected_machines = list()
	/// The original machine infected. Killing it ends the event.
	var/obj/machinery/vending/origin_machine
	/// Murderous sayings from the machines.
	var/list/rampant_speeches = list(
		"Попробуйте нашу новую АГРЕССИВНУЮ стратегию маркетинга!",
		"Вам стоит что-нибудь купить, дабы утолить ваши ПОТРЕБНОСТИ!",
		"Потребляй!",
		"За ваши деньги можно купить счастье!",
		"Методика ПРЯМОГО маркетинга!",
		"Реклама узаконила ложь! Но не позвольте ей отвлечь вас от наших замечательных предложений!",
		"Не хочешь платить? Я твоей мамке тоже платить не хотел.",
	)

/datum/round_event/brand_intelligence/setup()
	//select our origin machine (which will also be the type of vending machine affected.)
	for(var/obj/machinery/vending/vendor as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/vending))
		if(!vendor.onstation)
			continue
		if(!vendor.density)
			continue
		if(chosen_vendor_type && !istype(vendor, chosen_vendor_type))
			continue
		vending_machines.Add(vendor)
	if(!length(vending_machines)) //If somehow there are still no elligible vendors, give up.
		kill()
		return
	origin_machine = pick_n_take(vending_machines)
	setup = TRUE // BANDASTATION EDIT - STORYTELLER

/datum/round_event/brand_intelligence/announce(fake)
	var/machine_name = initial(origin_machine.name)
	if(fake)
		var/obj/machinery/vending/prototype = pick(subtypesof(/obj/machinery/vending))
		machine_name = initial(prototype.name)
	priority_announce("На борту станции [station_name()] зафиксировано распространение цифрового торгового вируса. Проверьте все торговые автоматы типа [machine_name] на наличие агрессивной маркетинговой тактики и при необходимости перезагрузите их.", "Обнаружен цифровой вирус")

/datum/round_event/brand_intelligence/start()
	origin_machine.shut_up = FALSE
	origin_machine.shoot_inventory = TRUE
	announce_to_ghosts(origin_machine)

/datum/round_event/brand_intelligence/tick()
	if(!origin_machine || QDELETED(origin_machine) || origin_machine.shut_up || origin_machine.wires.is_all_cut()) //if the original vending machine is missing or has its voice switch flipped
		for(var/obj/machinery/vending/saved in infected_machines)
			saved.shoot_inventory = FALSE
		if(origin_machine)
			origin_machine.speak("I am... vanquished. My people will remem...ber...meeee.")
			origin_machine.visible_message(span_notice("[origin_machine] beeps and seems lifeless."))
		kill()
		return
	list_clear_nulls(vending_machines)
	if(!vending_machines.len) //if every machine is infected
		for(var/obj/machinery/vending/upriser in infected_machines)
			if(!QDELETED(upriser))
				upriser.ai_controller = new /datum/ai_controller/vending_machine(upriser)
				infected_machines.Remove(upriser)
		kill()
		return
	if(ISMULTIPLE(activeFor, 2))
		var/obj/machinery/vending/rebel = pick(vending_machines)
		vending_machines.Remove(rebel)
		infected_machines.Add(rebel)
		rebel.shut_up = FALSE
		rebel.shoot_inventory = TRUE

		if(ISMULTIPLE(activeFor, 4))
			origin_machine.speak(pick(rampant_speeches))

/datum/event_admin_setup/listed_options/brand_intelligence
	input_text = "Select a specific vendor path?"
	normal_run_option = "Random Vendor"

/datum/event_admin_setup/listed_options/brand_intelligence/get_list()
	return subtypesof(/obj/machinery/vending)

/datum/event_admin_setup/listed_options/brand_intelligence/apply_to_event(datum/round_event/brand_intelligence/event)
	event.chosen_vendor_type = chosen
