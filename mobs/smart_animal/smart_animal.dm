/*
 * �������� simple_animal, ���� ����������� �� ���������� ���
 * �������� ���-�� simple_animal.dm
 * ��� ������ ������ � �����������, ����� ������� ������ � smart_animal_reactions.dm(�����)
 */
/mob/living/simple_animal/smart_animal

	//��������� ������, ����� ������� � ���-�� ����������� �� ���
	proc/listen_talks(message, mob/user as mob)
		return

	//���������� , ���� ���-�� ����� �� �������� � ����� ����, ���� ��� ������� ��� ������.
	//������� � HasEntered() �������� ���-�� ���������, �� � ������ ��������
	//����� ���� ������������� �������, ���� ������, ���� ���� ��������� �������� ����(��� �� �����, ��)
	HasEntered(AM as mob|obj)
		return

	//���� ���-�� � ���� ��������� ����-�� �������(����������, ��� ��������), �������� �� ���� ����
	proc/fight(var/mob/attacker, var/mob/attacked)
		return

	//� ����������
	//������� �� ������ ���� � ���� ������
	//����� ���������, ������ �� �� � ���� ����, � ����� �� ���-�� �������������
	proc/mob_death(dead as mob)
		return

	//����� ���-�� �� ����-�� ������� � ���� ��������� ����
	proc/target_point(var/atom/target, var/mob/user)
		return

	//����������� � ����������� ����
	proc/turn_to(var/atom/target)
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