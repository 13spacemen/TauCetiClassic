//� ���� �� ������ ���������� ������ ������ � ���� � ���������, ��� ����� ������������ ������������ ��������� �������� �� ������ � ������� � ���������� � ���

/*
*	Part I: �������������
*
*	����������� lowertext � uppertext ���������� ��������
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
			lcase_letter = letter_255
		else
			new_text += lcase_letter

	return new_text

/proc/uppertext_plus(text)
	var/lenght = length(text)
	var/new_text = null
	var/lcase_letter
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

//��� ����������� ������ ������ � ����
//��������� � ���� ������������� ������� windows-1251(� ������ ������� ������)
/proc/sanitize_output(var/t)
	var/index = findtext(t, letter_255)
	while(index)
		t = copytext(t, 1, index) + "&#255;" + copytext(t, index+1)
		index = findtext(t, letter_255)

	//just in case
	index = findtext(t, "&#1103;")
	while(index)
		t = copytext(t, 1, index) + "&#255;" + copytext(t, index+1)
		index = findtext(t, letter_255)

	return t

//��� ����������� ������ ������ � ��������� �����
//��������� ������������� unicode("����������" ��������� html)
/proc/sanitize_output2(var/t)
	var/index = findtext(t, letter_255)
	while(index)
		t = copytext(t, 1, index) + "&#1103;" + copytext(t, index+1)
		index = findtext(t, letter_255)

	//just in case
	index = findtext(t, "&#255;")
	while(index)
		t = copytext(t, 1, index) + "&#1103;" + copytext(t, index+1)
		index = findtext(t, letter_255)

	return t

/proc/sanitize_plus(var/t,var/list/repl_chars = list("\n"=" ","\t"="","�"=letter_255,"&#1103;"=letter_255))
	//the same as:
	//sanitize_output(sanitize())

	t = html_encode(sanitize_simple(t, repl_chars))

	var/index = findtext(t, letter_255)
	while(index)
		t = copytext(t, 1, index) + "&#255;" + copytext(t, index+1)
		index = findtext(t, letter_255)

	return t

/proc/sanitize_plus2(var/t,var/list/repl_chars = list("\n"=" ","\t"="","�"=letter_255,"&#255;"=letter_255))
	//the same as:
	//sanitize_output2(sanitize())

	t = html_encode(sanitize_simple(t, repl_chars))

	var/index = findtext(t, letter_255)
	while(index)
		t = copytext(t, 1, index) + "&#1103;" + copytext(t, index+1)
		index = findtext(t, letter_255)

	return t

//����������, ���� �� ����� ���������� �� ������� �������� ����.
//���-�� � �������, ����� �������� ����� ��� ��������� sanitize �������� ������������
//� ���� ���������� �������� � input() as text (������, ��� ������)
/proc/revert_ja(var/t, var/list/repl_chars = list("&#255;", "&#1103;", letter_255))
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + "�" + copytext(t, index+1)
			index = findtext(t, char)
	return t