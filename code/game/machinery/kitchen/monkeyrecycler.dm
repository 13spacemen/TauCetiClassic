/obj/machinery/monkey_recycler
	name = "Monkey Recycler"
	desc = "A machine used for recycling dead monkeys into monkey cubes."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 50
	var/grinded = 0


/obj/machinery/monkey_recycler/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
	if (src.stat != CONSCIOUS) //NOPOWER etc
		return
	if (istype(O, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		var/grabbed = G.affecting
		if(ismonkey(grabbed))
			var/mob/living/carbon/monkey/target = grabbed
			if(target.stat == CONSCIOUS)
				user << "\red The monkey is struggling far too much to put it in the recycler."
			else
				user.drop_item()
				qdel(target)
				user << "\blue You stuff the monkey in the machine."
				playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
				var/offset = prob(50) ? -2 : 2
				animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
				use_power(500)
				src.grinded++
				sleep(50)
				pixel_x = initial(pixel_x)
				user << "\blue The machine now has [grinded] monkeys worth of material stored."
		else
			user << "\red The machine only accepts monkeys!"
	return

/obj/machinery/monkey_recycler/attack_hand(var/mob/user as mob)
	if (src.stat != CONSCIOUS) //NOPOWER etc
		return
	if(grinded >=5)
		user << "\blue The machine hisses loudly as it condenses the grinded monkey meat. After a moment, it dispenses a brand new monkey cube."
		playsound(src.loc, 'sound/machines/hiss.ogg', 50, 1)
		grinded -= 5
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src.loc)
		user << "\blue The machine's display flashes that it has [grinded] monkeys worth of material left."
	else
		user << "\red The machine needs at least 5 monkeys worth of material to produce a monkey cube. It only has [grinded]."
	return
