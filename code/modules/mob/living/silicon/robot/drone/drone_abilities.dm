// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Drone"

	var/tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in TAGGERLOCATIONS

	if(!tag || TAGGERLOCATIONS[tag])
		mail_destination = 0
		return

	to_chat(src, "<span class='notice'>You configure your internal beacon, tagging yourself for delivery to '[tag]'.</span>")
	mail_destination = TAGGERLOCATIONS.Find(tag)

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		to_chat(src, "<span class='notice'>\The [D] acknowledges your signal.</span>")
		D.flush_count = D.flush_every_ticks

	return

/mob/living/silicon/robot/drone/verb/hide()
	set name = "Hide"
	set desc = "Allows you to hide beneath tables or certain items. Toggled on or off."
	set category = "Drone"

	if(layer != TURF_LAYER+0.2)
		layer = TURF_LAYER+0.2
		to_chat(src, text("<span class='notice'>You are now hiding.</span>"))
	else
		layer = MOB_LAYER
		to_chat(src, text("<span class='notice'>You have stopped hiding.</span>"))

/mob/living/silicon/robot/drone/verb/light()
	set name = "Light On/Off"
	set desc = "Activate a low power omnidirectional LED. Toggled on or off."
	set category = "Drone"

	if(lamp_intensity)
		lamp_intensity = lamp_max // setting this to lamp_max will make control_headlamp shutoff the lamp
	control_headlamp()

//Actual picking-up event.
/mob/living/silicon/robot/drone/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == I_HELP)
		get_scooped(M)

	..()