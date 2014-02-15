#define DOG_STAT_WAIT 1
#define DOG_STAT_FOLLOW 2
#define DOG_STAT_COME 3
//#define DOG_STAT_FREE 4

#define DOG_STAT_FAKE_DEAD 5
#define DOG_STAT_SIT 6
#define DOG_STAT_LIE 7

#define DOG_STAT_FIGHT 10
#define DOG_STAT_FAS 11

/*
 *TODO:
 * ����������: ����������� �������, ������������ �� ���������
 *
 * ������ ����������� ��������� �������, ����� ����� ���� ������ ������(��� ������ ������� ��� ����������� ��������� �� ���������� ����� ������, ���� � ������ ������� ����� ����������)
 * ������� ����� �� whisper
 * �����: ������ �����, ��������� ����� ����� � ������� �� ���, �������� �������(�����, ����������, ������������ ����� � ��� �����)
 * �����: �������, ����������� � �����������
 */

/mob/living/simple_animal/dog

	name = "Dog"
	desc = "Just Dog"
	icon = 'tauceti/mobs/dogs/doge.dmi'
	icon_state = "shepherd"
	icon_dead = "shepherd_dead"
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/dog
	meat_amount = 3
	see_in_dark = 6
	stop_automated_movement = 0
	health = 150
	maxHealth = 150

	var/mob/owner
	var/mob/dog_target
	var/old_coords[3]	//x, y, z
	var/dog_state = DOG_STAT_WAIT
	var/loyalty = 50	//between 0 and 100, affects the chance of disobedience
	var/dog_icon = "shepherd"
	var/list/dog_names = list("dog", "�����")

/mob/living/simple_animal/dog/sheppard
	name = "Sheppard"
	desc = "Real hero guarding our galaxy"
	dog_names = list("dog","�����","shep","���", "���", "��", "�����")//��� � � ���� ��������. �����, ���� �����.
	loyalty = 70

/mob/living/simple_animal/dog/mishka
	name = "Mishka"
//	desc = "Real hero guarding our galaxy"
	dog_names = list("dog","�����","mish","���", "�����")//��� � � ���� ��������. �����, ���� �����.
	loyalty = 70

	icon_state = "husky"
	icon_dead = "husky_dead"
	dog_icon = "husky"

/obj/item/weapon/reagent_containers/food/snacks/meat/dog
	name = "Dog meat"
	desc = "Tastes like... well you know..."

/mob/living/simple_animal/dog/proc/listen_command(var/message, var/mob/user as mob)

	message = lowertext_tc(message)

	if(!message)
		return

	owner = user//��������

	var/dog_command
	for(var/dogname in dog_names)
		if(findtext(message, dogname))	//okay, it's about this dog
			dog_command = 1
			break

/*
 *NEW STAT PART
 */
	//������ �������� ��������� �� �������
	//todo: ���-�� � ���� �������

	var/new_state = 0
	if(!new_state)
		for(var/word in list("�����", "���", "����"))
			if(findtext(message, word))
				new_state = DOG_STAT_WAIT
				break

	if(!new_state)
		for(var/word in list("�� ����", "�����"))
			if(findtext(message, word))
				new_state = DOG_STAT_FOLLOW
				break

	if(!new_state)
		for(var/word in list("� ����", "�� ���", "����"))
			if(findtext(message, word))
				new_state = DOG_STAT_COME
				break

	if(!new_state)
		for(var/word in list("����", "�������"))
			if(findtext(message, word))
				new_state = DOG_STAT_FAKE_DEAD
				break

	if(!new_state)
		for(var/word in list("������", "����", "�&#255;�"))
			if(findtext(message, word))
				new_state = DOG_STAT_SIT
				break

	if(!new_state)
		for(var/word in list("������", "�&#255;�"))
			if(findtext(message, word))
				new_state = DOG_STAT_LIE
				break

/*
 *NEW STAT PART END
 */


/*
 *EMOTIONAL REACTION
 */
	var/emotional_reaction

	//����������� ������!
	if(!emotional_reaction)
		for(var/word in list("���", "��&#255;", "�����", "���"))
			if(findtext(message, word))
				custom_emote(1, "whines")
				emotional_reaction = 1
				break

	//���������� ������� �� �������
	if(!emotional_reaction)
		if(dog_command)
			for(var/word in list("&#255;�", "���", "���", "�����", "�����", "������"))
				if(findtext(message, word))
					custom_emote(1, "waves his tail")
					emotional_reaction = 1
					break
/*
 *EMOTIONAL REACTION END
 */

	//���������, ���� �������� ������
	//TODO: ������� ����������� ������� ����� ��������� ���������, � ���� ������� - return
	if(new_state)
		if(dog_command)
			turn_to(user)
			dog_state = new_state
			state_update(user)
		else
			var/count = 1
			for(var/mob/living/carbon/C in view(7,src)) //���������, ��� ����� ����� ������
				count++
//DEBAG
				world << count
//DEBAG END
			if(!prob(count*10))	//����������� ������� ������� ��� ��������� ������� �� ���������� ����� ������
				dog_state = new_state
				state_update(user)
	else
		if(dog_command)
			turn_to(user)
			bark()

/mob/living/simple_animal/dog/Life()
	..()

	switch(dog_state)

		if(DOG_STAT_FOLLOW)
			walk_to(src, dog_target, 1, 4)
			turn_to(dog_target)

		if(DOG_STAT_COME)
			walk_to(src, dog_target, 1, 4)
			if(get_dist(src, dog_target) <=1)//nerabotaetept'
				turn_to(dog_target)
				dog_state = DOG_STAT_WAIT
				walk(src, 0)

		if(DOG_STAT_FAKE_DEAD, DOG_STAT_SIT, DOG_STAT_LIE)
			if(old_coords[1] != x || old_coords[2] != y || old_coords[3] != z)
				dog_state = DOG_STAT_WAIT
				state_update()

	//�� �����, ��� �� ������� � ����� �� ������, ���������� �������� ������, � ��� �����
//� ��������
	for (var/atom/A in view(1,src))
		if(istype(A, /obj/machinery/bot/secbot))
			custom_emote(1, "����� �� ������")
			bark()
			turn_to(A)
		if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/C = A
			if(C == owner && C.stat != 0)
				dog_state = DOG_STAT_COME
				state_update(owner)
				custom_emote(1, "������")
		if(istype(A, /obj))
			if(prob(5))
				turn_to(A)
				custom_emote(1, "���������� [A]")

	//	if (istype(A, /mob/living/carbon/human))


	if(prob(1))
		dir = pick(WEST, EAST, NORTH, SOUTH)

/mob/living/simple_animal/dog/proc/state_update(var/mob/user as mob)

	if(dog_state != DOG_STAT_WAIT)
		stop_automated_movement = 1
	else
		stop_automated_movement = 0

	if(dog_state == DOG_STAT_FOLLOW)
		dog_target = user
		bark()

	if(dog_state == DOG_STAT_COME)
		dog_target = user

	if(dog_state == DOG_STAT_FAKE_DEAD)//+ ������, �� ����� �� �� ������ ���
		custom_emote(1, "���� � ����")
		walk(src, 0)
		icon_state = "[dog_icon]_dead"

	if(dog_state == DOG_STAT_SIT)
		custom_emote(1, "���")
		walk(src, 0)
		icon_state = "[dog_icon]_sit"

	if(dog_state == DOG_STAT_LIE)
		custom_emote(1, "��")
		walk(src, 0)
		icon_state = "[dog_icon]_lie"

	if(dog_state == DOG_STAT_FAKE_DEAD || dog_state == DOG_STAT_SIT || dog_state == DOG_STAT_LIE)
		old_coords[1] = x
		old_coords[2] = y
		old_coords[3] = z

	if(dog_state != DOG_STAT_FAKE_DEAD && dog_state != DOG_STAT_SIT && dog_state != DOG_STAT_LIE)
		icon_state = dog_icon

/mob/living/simple_animal/dog/proc/turn_to(var/mob/target as mob)

	if (target.loc.x < src.x)
		dir = WEST
	else if (target.loc.x > src.x)
		dir = EAST
	else if (target.loc.y < src.y)
		dir = SOUTH
	else if (target.loc.y > src.y)
		dir = NORTH
	else
		dir = SOUTH


/mob/living/simple_animal/dog/proc/bark()
	say(pick("Aw!", "YAP!", "Woof!", "Wof!", "Bark!"))

/mob/living/simple_animal/dog/mishka/bark()
	say(pick("Aw!", "Oaoaoa!", "Aoaoao!", "Yaya!"))