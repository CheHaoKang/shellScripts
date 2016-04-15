import smtplib
import mimetypes
import string
import sys, os, getopt,time
import mimetypes
from datetime import datetime
from email import Encoders
from email.Message import Message
from email.MIMEAudio import MIMEAudio
from email.MIMEBase import MIMEBase
from email.MIMEMultipart import MIMEMultipart
from email.MIMEImage import MIMEImage
from email.MIMEText import MIMEText
from email.Header import Header
from email.Encoders import encode_base64

COMMASPACE = ', '

if sys.argv[1] == "Weekly" or sys.argv[1] == "weekly":
	build_type="Weekly Build"
elif sys.argv[1] == "Daily" or sys.argv[1] == "daily":
	build_type="Daily Build"
elif sys.argv[1] == "kcj" or sys.argv[1] == "KCJ":
        build_type="kcj merge Build"
else:
	build_type="Unknown Build"
build_date = os.getenv("cm_build_date")
build_project = os.getenv("cm_build_project")
build_branch = os.getenv("cm_build_branch")
build_feature = os.getenv("cm_build_feature")
build_start = os.getenv("cm_batch_build_start")
build_end = os.getenv("cm_batch_build_end")
build_label = os.getenv("cm_build_label")
build_release_host=os.getenv("cm_build_host_ip")
build_matchtable_check=os.getenv("cm_matchtablecheck_ok")


#from_addr = "CME@" + build_project
from_addr = "spmd1_cme@compalcomm.com"

to_addr=['GSMRDC_PDD2_SW1@Compalcomm.com','GSMRDC_PDD2_SW2@Compalcomm.com','GSMRDC_PDD2_SW3@Compalcomm.com','San_Hsu@compalcomm.com','nash_wang@compalcomm.com','Jacky_Chang@Compalcomm.com','Terri_Chen@Compalcomm.com','Ericyt_Lin@Compalcomm.com','Sam_Chen@compalcomm.com','David_Chang@Compalcomm.com','Kuanhung_Chen@Compalcomm.com','Tinna_Lai@Compalcomm.com','Sean_Liong@Compalcomm.com','JuLin_Shih@Compalcomm.com','Johnny_Wu@Compalcomm.com','David_Chih@Compalcomm.com','Cliff_Huang@Compalcomm.com','Miguel_Wang@Compalcomm.com','Ryan_Huang@Compalcomm.com','Maureen_Chang@Compalcomm.com','Teddy_Chen@Compalcomm.com','Tina_Huang@Compalcomm.com','Vance_Chen@Compalcomm.com','ivy_huang@Compalcomm.com','Gary_Lai@Compalcomm.com','Wayne_Wang@Compalcomm.com','Chevy_Chuang@Compalcomm.com','Slash_huang@compalcomm.com']
#to_addr=['Decken_Kang@Compalcomm.com']
#to_addr=['&GSMPDC_PD2_SW3@Compalcomm.com','&GSMPDC_SWSD_MD1@Compalcomm.com','Frank_Lai@compalcomm.com','Riya_Chih@compalcomm.com','Gloria_Hsu@Compalcomm.com','victor_hsu@Compalcomm.com','DavidA_Chang@Compalcomm.com']
#to_addr=['tj_yang@Compalcomm.com','ivy_huang@Compalcomm.com','san_hsu@Compalcomm.com','&GSMPDC_PD2_SW3@Compalcomm.com','leon_yang@compalcomm.com','Brook_Wu@compalcomm.com','YaFi_Lin@compalcomm.com','Chihyu_Wang@compalcomm.com','Wayne_Yu@compalcomm.com','Nick_Chang@compalcomm.com','Yuansheng_Tsai@compalcomm.com','KelvinA_Chang@compalcomm.com','kevin2_chang@compalcomm.com','Rayson_Chou@compalcomm.com','Wallace_Chu@compalcomm.com','henry_chung@compalcomm.com','Slash_Huang@compalcomm.com','Gary_Lai@compalcomm.com','Dylan_Pan@compalcomm.com','Sean_Yang@compalcomm.com','David_Yu@compalcomm.com','Justin_Chen@compalcomm.com']
#to_addr=['Robin_Le@Compalcomm.com','js_yu@Compalcomm.com','tj_yang@Compalcomm.com','sophie_chen@Compalcomm.com','ivy_huang@Compalcomm.com','san_hsu@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW1@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW2@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW3@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW4@Compalcomm.com','angela_hung@compalcomm.com','sylar_lan@compalcomm.com','linus_yen@compalcomm.com','kyle_hsiao@compalcomm.com','bryant_wang@compalcomm.com','ryan_chen@compalcomm.com','patrick26_hsieh@compalcomm.com','anderson_cheng@compalcomm.com','ted_lai@compalcomm.com','jim_hsu@compalcomm.com','jimmy_chang@compalcomm.com','jimmy_yen@compalcomm.com','victor_chen@compalcomm.com','ben_jiang@compalcomm.com','jack_chang@compalcomm.com','ivy_juan@compalcomm.com','duncan_shen@compalcomm.com','valen_wang@compalcomm.com','rita_chen@compalcomm.com','james_huang@compalcomm.com','linda_lo@compalcomm.com','ivan_lu@compalcomm.com']

#to_addr=['alan_deng@compalcomm.com','bruno_lin@compalcomm.com','tina_liu@compalcomm.com','rex_tsao@compalcomm.com','taylor_cheng@compalcomm.com']

subject="CCI Android " + build_type + " " + build_project + " " + build_feature
if build_type == "Weekly Build":
	subject += "." + build_label
else:
	subject += " " + build_date

if os.getenv("cm_build_ok") == "y" and os.getenv("cm_matchtablecheck_ok") == "yes":
	subject += " success"
elif os.getenv("cm_build_ok") == "y" and os.getenv("cm_matchtablecheck_ok") == "none":
        subject += " success"
else:
	subject += " failed"
log_android_file=os.getenv("cm_code_root_dir") + "/" + os.getenv("cm_build_log_zip")
log_git_log=os.getenv("cm_code_root_dir") + "/" + os.getenv("cm_git_log_zip")
log_checkin_log=os.getenv("cm_code_root_dir") + "/" + os.getenv("cm_checkin_log_zip")

if os.getenv("cm_matchtablecheck_ok") != "none":
	log_matchtablecheck_log=os.getenv("cm_code_root_dir") + "/" + os.getenv("cm_matchtablecheck_log_zip")
	build_log_files = [log_android_file, log_git_log, log_checkin_log, log_matchtablecheck_log]
else:
	build_log_files = [log_android_file, log_git_log, log_checkin_log]
#build_log_files = [log_android_file, log_git_log]
##build_log_files = []

subject += " %02d:%02d:%02d\t" % (datetime.now().hour, datetime.now().minute, datetime.now().second)

if build_type == "Weekly Build":
	bin_url = build_release_host+"/cme_release/" + build_project + "/" + build_branch + "/" + build_feature
	codebase_url = build_release_host+"/cme_release/" + build_project + "/" + build_branch + "/" + build_feature
#	bin_url_win = "\\gsm_sw01\BU2-SMD\Internal Release\UT Image\SA77\WB" + build_label
#	codebase_url_win = "\\gsm_sw01\BU2-SMD\Internal Release\SW Source Code Release\SA77\WB" + build_label
	bin_url_win = "10.113.1.56\SW_Project\J68\SA77\\2_WeeklyFormal_Build\\WB" + build_label
	codebase_url_win = "10.113.1.56\SW_Project\J68\SA77\\3_CodeBase\\WB" + build_label
else:
	bin_url = build_release_host+"/dailybuild/" + build_project + "/" + build_date
	codebase_url = build_release_host+"/dailybuild/" + build_project + "/" + build_date
	bin_url_win = build_release_host+"\dailybuild\\" + build_project + "\\" + build_date
	codebase_url_win = build_release_host+"\dailybuild\\" + build_project + "\\" + build_date


mail_msg_header = """<html>
<head>
<style>
<!--
 /* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Tahoma;
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
 /* Page Definitions */
@page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	layout-grid:18.0pt;}
div.Section1
	{page:Section1;}
-->
</style>
</head>
<body>
<div class=Section1 style='layout-grid:18.0pt'>
"""

mail_msg_tail = "\n</div>\n</body>\n</html>\n"

##<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Build Part => %s</span></font></p>
mail_msg_str = ""
mail_msg_str += mail_msg_header
mail_msg_str += """<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Dear All,</span></font></p>
<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Build statistics:</span></font></p>"""

if build_matchtable_check == "no":
	mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma color=red><span lang=EN-US style='font-size:14.0pt;font-family:Tahoma'>Matchtable check FAIL. Please check attachment error_matchtablecheck-log.zip</span></font></p>"

if build_matchtable_check == "yes":
	mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma color=red><span lang=EN-US style='font-size:14.0pt;font-family:Tahoma'>Matchtable check SUCCESS</span></font></p>"

mail_msg_str += "<br>"
mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma color=red><span lang=EN-US style='font-size:14.0pt;font-family:Tahoma'>Stop MTBF : *#*#6823#*#* </span></font></p>"

if build_start != "" and build_end != "":
	mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma>&nbsp&nbsp&nbsp&nbspStart &nbspTime : %s</font></p>" % (build_start)
	mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma>&nbsp&nbsp&nbsp&nbspFinish Time : %s</font></p>" % (build_end)

mail_msg_str +="<br><p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Please refer to attachment for build logs.</span></font></p>"
mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma>Linux : </font></p>"
mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style=\'font-size:10.0pt;font-family:Tahoma\'>The result binaries are located in <a href=\"smb://%s\">smb://%s</a></span></font></p>\n" % (bin_url, bin_url)
mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>And the archived patch files are located in <a href=\"smb://%s\">smb://%s</a></span></font></p>\n" % (codebase_url, codebase_url)
mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma>Windows : </font></p>"
mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style=\'font-size:10.0pt;font-family:Tahoma\'>The result binaries are located in <a href=\"\\\%s\">\\\%s</a></span></font></p>\n" % (bin_url_win, bin_url_win)
mail_msg_str += "<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>And the archived patch files are located in <a href=\"\\\%s\">\\\%s</a></span></font></p>\n" % (codebase_url_win, codebase_url_win)
mail_msg_str += """<br/>"""
mail_msg_str += mail_msg_tail

mail_obj = MIMEMultipart()
mail_obj['Subject'] = subject
mail_obj['From'] = from_addr
mail_obj['To'] = COMMASPACE.join(to_addr)
#msg = "From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n%s" % (from_addr, to_addr,subject, msg_txt)

msg_content = MIMEText(mail_msg_str)
msg_content.replace_header('Content-Type', 'text/html; charset="big5"')
mail_obj.attach(msg_content)

for path in build_log_files:
	print "Attaching \"" + path + "\"..."

	try:
		ctype, encoding = mimetypes.guess_type(path)
		if ctype is None or encoding is not None:
			ctype = 'application/octet-stream'
		maintype, subtype = ctype.split('/', 1)

		if maintype == 'text':
			fp = open(path)
			# Note: we should handle calculating the charset
			msg = MIMEText(fp.read(), _subtype=subtype)
			fp.close()
		elif maintype == 'image':
			fp = open(path, 'rb')
			msg = MIMEImage(fp.read(), _subtype=subtype)
			fp.close()
		elif maintype == 'audio':
			fp = open(path, 'rb')
			msg = MIMEAudio(fp.read(), _subtype=subtype)
			fp.close()
		else:
			fp = open(path, 'rb')
			msg = MIMEBase(maintype, subtype)
			msg.set_payload(fp.read())
			fp.close()
			# Encode the payload using Base64
			encode_base64(msg)

		# Set the filename parameter
		msg.add_header('Content-Disposition', 'attachment', filename=os.path.split(path)[1])
		mail_obj.attach(msg)

	except Exception, e:
		print "** Exception **"
		print e
		pass

s = smtplib.SMTP('10.113.2.107')
s.set_debuglevel(0);

__SendMailResult = "%04d/%02d/%02d %02d:%02d:%02d\t\t" % (datetime.now().year, datetime.now().month, datetime.now().day, datetime.now().hour, datetime.now().minute, datetime.now().second)

try:
#	smtp_server.sendmail(mail_from_addr, mail_to_addrs, mail_obj.as_string())
	s.sendmail(from_addr,to_addr,mail_obj.as_string())
except smtplib.SMTPRecipientsRefused, e:
	__SendMailResult += "** Exception SMTPRecipientsRefused **", e
except smtplib.SMTPHeloError, e:
	__SendMailResult += "** Exception SMTPHeloError **", e
except smtplib.SMTPSenderRefused , e:
	__SendMailResult += "** Exception SMTPSenderRefused **", e
except smtplib.SMTPDataError , e:
	__SendMailResult += "** Exception SMTPDataError **", e
else:
	__SendMailResult += "Send mail OK"

__SendMailResult += "\n"

print __SendMailResult
s.quit()
