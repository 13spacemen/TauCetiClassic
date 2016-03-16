//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/show_distribution_map()
	set category = "Debug"
	set name = "Show Distribution Map"
	set desc = "Print the asteroid ore distribution map to the world."

	if(!holder)	return

	if(master_controller && master_controller.asteroid_ore_map)
		master_controller.asteroid_ore_map.print_distribution_map()

/client/proc/remake_distribution_map()
	set category = "Debug"
	set name = "Remake Distribution Map"
	set desc = "Rebuild the asteroid ore distribution map."

	if(!holder)	return

	if(master_controller && master_controller.asteroid_ore_map)
		master_controller.asteroid_ore_map = new /datum/ore_distribution()
		master_controller.asteroid_ore_map.populate_distribution_map()

/client/proc/restart_controller_old(controller in list("Supply Shuttle"))
	set category = "Debug"
	set name = "Restart Controller (Old)"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	usr = null
	src = null
	switch(controller)
		if("Supply Shuttle")
			supply_shuttle.process()
			feedback_add_details("admin_verb","RSupply")
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	return


/client/proc/debug_controller(controller in list("Master","Ticker","Air","Jobs","Sun","Radio","Supply Shuttle","Emergency Shuttle","Configuration","pAI", "Cameras", "Transfer Controller"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)
			feedback_add_details("admin_verb","DMC")
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Jobs")
			debug_variables(job_master)
			feedback_add_details("admin_verb","DJobs")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")
		if("Supply Shuttle")
			debug_variables(supply_shuttle)
			feedback_add_details("admin_verb","DSupply")
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
			feedback_add_details("admin_verb","DEmergency")
		if("pAI")
			debug_variables(paiController)
			feedback_add_details("admin_verb","DpAI")
		if("Transfer Controller")
			debug_variables(transfer_controller)
			feedback_add_details("admin_verb","DAutovoter")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
