//� ���� �� ������ ���������� ������ ������ � ���� � ���������, ��� ����� ������������ ������������ ��������� �������� �� ������ � ������� � ���������� � ���
//��� ��� �� �������� �������� ������ �� TODO:CYRILLIC

/*
*	Part I: �������������
*
*	����������� lowertext � uppertext ���������� ��������
*	��������, �� ����� ���� �� ���-�� ��������������, ��� ��� �������� � isBanned(), �� � ���� �� �����.
*/

/proc/lowertext_plus(text)
	var/lenght = length(text)
	var/new_text = null
	var/lcase_letter
	var/letter_ascii

	var/p = 1
	while(p++ <= lenght)
		lcase_letter = copytext(text, p, p + 1)
		letter_ascii = text2ascii(lcase_letter)

		if((letter_ascii >= 65 && letter_ascii <= 90) || (letter_ascii >= 192 && letter_ascii < 223))
			lcase_letter = ascii2text(letter_ascii + 32)
		else if(letter_ascii == 223)
			lcase_letter = letter_255	//"�"
		else
			new_text += lcase_letter

	return new_text

/proc/uppertext_plus(text)
	var/lenght = length(text)
	var/new_text = null
	var/ucase_letter
	var/letter_ascii

	var/p = 1
	while(p++ <= lenght)
		ucase_letter = copytext(text, p, p + 1)
		letter_ascii = text2ascii(ucase_letter)

		if((letter_ascii >= 97 && letter_ascii <= 122) || (letter_ascii >= 224 && letter_ascii < 255))
			ucase_letter = ascii2text(letter_ascii - 32)
		else if(letter_ascii == 255)
			ucase_letter = "�"
		else
			new_text += ucase_letter

	return new_text

/*
*	Part II: ������ �� "�"
*
*	����� ��������, ��� �������� ��� ������� ��� ... "�" �� ������������.
*	����� ����� ��� ����, ���-�� � �������� sanitize(��� � text.dm) ��������� ������ "�" �� letter_255
*/

var/letter_255 = ascii2text(182) // "�"

//Removes a few problematic characters
//�� ������ ������, ������ ������������� �������� �� ����� �� ���� �������. ���������, ����� ���-�� ����������� ���������.
/proc/sanitize_simple(var/t,var/list/repl_chars = list("\n"=" ","\t"=" ","�"=letter_255))

	if(length(t) > 1500)																// ���� "�������" �� �����������,
		world.log << "ERROR_SS_long_string([src]): [copytext(t, 1, MAX_MESSAGE_LEN)]"	// ����� ����� ���� ����� ������������.
		return "�"

	for(var/char in repl_chars)
		var/len = length(repl_chars[char])
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + repl_chars[char] + copytext(t, index+1)
			index = findtext(t, char, index + len)
	#ifdef DEBAG_CYRILLIC
	world << "DEBAG sanitize_simple: [t]"
	#endif
	return t

//��� ����������� ������ ������ � ����
//��������� � ���� ������������� ������� windows-1251(� ������ ������� ������)
/proc/sanitize_output(var/t)

	t = sanitize_simple(t, list(letter_255="&#255;","&#1103;"="&#255;"))	//��������� &#1103; ������ �� ������ ������
	#ifdef DEBAG_CYRILLIC
	world << "DEBAG sanitize_output: [t]"
	#endif
	return t

//��� ����������� ������ ������ � ��������� �����
//��������� ������������� unicode("����������" ��������� html)
/proc/sanitize_output2(var/t)

	t = sanitize_simple(t, list(letter_255="&#1103;","&#255;"="&#1103;"))	//��������� &#255; ������ �� ������ ������
	#ifdef DEBAG_CYRILLIC
	world << "DEBAG sanitize_output2: [t]"
	#endif
	return t

//���� ����� ��������� ����-������ ����� ����� ������, �� ���������� �� �������� �����\������ �� ��� ���������, ����� ��� �����
/proc/sanitize_plus(var/t,var/list/repl_chars = list("\n"=" ","\t"="","�"=letter_255))

	t = sanitize_output(sanitize(t, repl_chars))	//�������, �����-������ �������� � "�" ����������...
	#ifdef DEBAG_CYRILLIC
	world << "DEBAG sanitize_plus: [t]"
	#endif
	return t

//���������� - �����, ������� ���������� �������� � "�" � ���� "&#1103;". �������� ������������� �� ������� �������, ����������� ����� ������ ����
//������, �� �� ����� �������� � ����� ��� � ������� �������
/proc/sanitize_plus2(var/t,var/list/repl_chars = list("\n"=" ","\t"="","�"=letter_255))

	t = sanitize_output2(sanitize(t, repl_chars))
	#ifdef DEBAG_CYRILLIC
	world << "DEBAG sanitize_plus2: [t]"
	#endif
	return t

//����������, ���� �� ����� ���������� �� ������� �������� ����.
//���-�� � �������, ����� �������� ����� ��� ��������� sanitize �������� ������������
//� ���� ���������� �������� � input() as text (������, ��� ������)
/proc/revert_ja(var/t, var/list/repl_chars = list("&#255;", "&#1103;", letter_255))

	t = sanitize_simple(t, repl_chars)
	#ifdef DEBAG_CYRILLIC
	world << "DEBAG sanitize_plus2: [t]"
	#endif
	return t