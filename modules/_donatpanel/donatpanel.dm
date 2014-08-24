/proc/donatinfo()


	var/percent = 0
	var/cost = 2000
	var/donate = 0
	var/month = "��������� ���&#1103;�"

	var/list/Params = file2list("config/donatinfo.txt")

	for(var/t in Params)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)
		if (!name)
			continue

		switch(name)
			if("hide")
				return	//��� ������ ������� ��� ��������, ������� � �������� ������ �����
			if("cost")
				cost = text2num(value)
			if("donate")
				donate = text2num(value)
			if("month")
				month = value


	percent = round((100 * donate)/cost)
	var/di_width = min(percent, 100)
	//var/progressbar_width = percent * 3//1% = 3px
	//world << "progressbar_width [progressbar_width]"

	//TODO: "�� ���� ����� �� ����������: ...", ������� ������ ����� �����, �� � ������ ������������ �������� �� �����������
	var/output = "<HEAD><TITLE>�����&#1103; ���������&#1103;</TITLE></HEAD><BODY bgcolor='#373737' text='#DFE5EB'><div align='center'>\n"
	output += "<h2>�����&#1103; ���������&#1103;!</h2>"
	output += "������ ������� ��&#1103; ���������� ����� �����, � �� ����� �������&#1103; �� ���� ������.<br>"
	output += "���������&#1103; � ���, ��� ��� ������: http://forums.tauceti.ru/talks/index.php?topic=1253.0<br><br>"
	output += "���� ������� �� [month]:<br>"
	output += "<div style='background-color: #DFDFDF; position: relative; width: 400px; height: 23px; border: 1px solid black; margin: 0px; padding: 0px;'>\n"//������ 23? �� ��, ���� ��������� ��� ���� � ������ ������ ��������� ����� ������������
	output += "<div style='position: absolute; left: 0px; background-color: #FF0D1E; width: [di_width]%; height: 20px; margin: 0px; padding: 0px; border: 1px solid white;'></div>"
	output += "<div style='color: 000000; position: absolute; left: 0; width: 400px; height: 22px; margin: 0px; padding: 0px; vertical-align: middle'>[percent]%</div>"
	output += "</div>"
	output += "<small>*�����&#1103;��� ������&#1103;���&#1103; ��� � ��������� ����,<br>���������&#1103; �����: [cost] ������.</small>"
	//output += "<A href='?src=[ref];'>������� � �������� � �������</A>"
	output += "</div></BODY>"

	usr << browse(output, "window=donatinfo;size=620x250;can_resize=0;")