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
merge_branch=os.getenv("mergeBranch")

from_addr = "CME@" + merge_branch

#to_addr_success=['Decken_Kang@Compalcomm.com']
to_addr_success=['Alan_Deng@Compalcomm.com','Gary_Yeh@Compalcomm.com','Bruno_Lin@Compalcomm.com','Decken_Kang@Compalcomm.com','San_Hsu@compalcomm.com','nash_wang@compalcomm.com','Jacky_Chang@Compalcomm.com','Terri_Chen@Compalcomm.com','Ericyt_Lin@Compalcomm.com','Sam_Chen@compalcomm.com','David_Chang@Compalcomm.com','Kuanhung_Chen@Compalcomm.com','Tinna_Lai@Compalcomm.com','Sean_Liong@Compalcomm.com','JuLin_Shih@Compalcomm.com','Johnny_Wu@Compalcomm.com','David_Chih@Compalcomm.com','Cliff_Huang@Compalcomm.com','Miguel_Wang@Compalcomm.com','Jandy_Tseng@Compalcomm.com','Ravi_Chang@Compalcomm.com','Ryan_Huang@Compalcomm.com','Maureen_Chang@Compalcomm.com','Teddy_Chen@Compalcomm.com']
to_addr_fail=['GSMRDC_PDD2_SW1@Compalcomm.com','GSMRDC_PDD2_SW2@Compalcomm.com','GSMRDC_PDD2_SW3@Compalcomm.com','San_Hsu@compalcomm.com','nash_wang@compalcomm.com','Jacky_Chang@Compalcomm.com','Terri_Chen@Compalcomm.com','Ericyt_Lin@Compalcomm.com','Sam_Chen@compalcomm.com','David_Chang@Compalcomm.com','Kuanhung_Chen@Compalcomm.com','Linda_Her@Compalcomm.com','Tinna_Lai@Compalcomm.com','Sean_Liong@Compalcomm.com','JuLin_Shih@Compalcomm.com','Johnny_Wu@Compalcomm.com','David_Chih@Compalcomm.com','Cliff_Huang@Compalcomm.com','Miguel_Wang@Compalcomm.com','Jandy_Tseng@Compalcomm.com','Ravi_Chang@Compalcomm.com','Ryan_Huang@Compalcomm.com','Maureen_Chang@Compalcomm.com','Teddy_Chen@Compalcomm.com']
#to_addr_test_fail=['decken_kang@compalcomm.com']
#to_addr_test_success=['decken_kang@compalcomm.com','Jack_Chiang@compalcomm.com']
#to_addr=['&GSMPDC_PD2_SW3@Compalcomm.com','San_Hsu@compalcomm.com','nash_wang@compalcomm.com','Jacky_Chang@Compalcomm.com','Pei_Yuan_Chou@Compalcomm.com','Terri_Chen@Compalcomm.com','Ericyt_Lin@Compalcomm.com','Sam_Chen@compalcomm.com']
#to_addr=['&GSMPDC_PD2_SW3@Compalcomm.com','&GSMPDC_SWSD_MD1@Compalcomm.com','Frank_Lai@compalcomm.com','Riya_Chih@compalcomm.com','Gloria_Hsu@Compalcomm.com','victor_hsu@Compalcomm.com','DavidA_Chang@Compalcomm.com']
#to_addr=['tj_yang@Compalcomm.com','ivy_huang@Compalcomm.com','san_hsu@Compalcomm.com','&GSMPDC_PD2_SW3@Compalcomm.com','leon_yang@compalcomm.com','Brook_Wu@compalcomm.com','YaFi_Lin@compalcomm.com','Chihyu_Wang@compalcomm.com','Wayne_Yu@compalcomm.com','Nick_Chang@compalcomm.com','Yuansheng_Tsai@compalcomm.com','KelvinA_Chang@compalcomm.com','kevin2_chang@compalcomm.com','Rayson_Chou@compalcomm.com','Wallace_Chu@compalcomm.com','henry_chung@compalcomm.com','Slash_Huang@compalcomm.com','Gary_Lai@compalcomm.com','Dylan_Pan@compalcomm.com','Sean_Yang@compalcomm.com','David_Yu@compalcomm.com','Justin_Chen@compalcomm.com']
#to_addr=['Robin_Le@Compalcomm.com','js_yu@Compalcomm.com','tj_yang@Compalcomm.com','sophie_chen@Compalcomm.com','ivy_huang@Compalcomm.com','san_hsu@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW1@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW2@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW3@Compalcomm.com','&GSMRDC_RDHQ3_PD2_SW4@Compalcomm.com','angela_hung@compalcomm.com','sylar_lan@compalcomm.com','linus_yen@compalcomm.com','kyle_hsiao@compalcomm.com','bryant_wang@compalcomm.com','ryan_chen@compalcomm.com','patrick26_hsieh@compalcomm.com','anderson_cheng@compalcomm.com','ted_lai@compalcomm.com','jim_hsu@compalcomm.com','jimmy_chang@compalcomm.com','jimmy_yen@compalcomm.com','victor_chen@compalcomm.com','ben_jiang@compalcomm.com','jack_chang@compalcomm.com','ivy_juan@compalcomm.com','duncan_shen@compalcomm.com','valen_wang@compalcomm.com','rita_chen@compalcomm.com','james_huang@compalcomm.com','linda_lo@compalcomm.com','ivan_lu@compalcomm.com']

#to_addr=['alan_deng@compalcomm.com','bruno_lin@compalcomm.com','tina_liu@compalcomm.com','rex_tsao@compalcomm.com','taylor_cheng@compalcomm.com']

subject="CCI Android Merge " + merge_branch + " " + build_type

if os.getenv("cm_merge_code_ok") == "y":
	subject += " success"
else:
	subject += " failed"
log_merge_file=os.getenv("cm_code_root_dir") + "/mergecode.zip"
#log_merge_file=os.getenv("cm_root_dir") + "/mergecode.zip"
#log_git_log=os.getenv("cm_code_root_dir") + "/" + os.getenv("cm_git_log_zip")
build_log_files = [log_merge_file]
##build_log_files = []

subject += " %02d:%02d:%02d\t" % (datetime.now().hour, datetime.now().minute, datetime.now().second)

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
if os.getenv("cm_merge_code_ok") == "y":
    mail_msg_str += """<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Dear All,</span></font></p>
<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Merge Code SUCCESS</span></font></p>"""
else:
    mail_msg_str += """<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Dear All,</span></font></p>
<p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Merge Code CONFLICT</span></font></p>"""

mail_msg_str +="<br><p class=MsoNormal><font size=2 face=Tahoma><span lang=EN-US style='font-size:10.0pt;font-family:Tahoma'>Please refer to attachment for merge logs.</span></font></p>"
mail_msg_str += """<br/>"""
mail_msg_str += mail_msg_tail

mail_obj = MIMEMultipart()
mail_obj['Subject'] = subject
mail_obj['From'] = from_addr
if os.getenv("cm_merge_code_ok") == "y":
    mail_obj['To'] = COMMASPACE.join(to_addr_success)
else:
    mail_obj['To'] = COMMASPACE.join(to_addr_fail)
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
    if os.getenv("cm_merge_code_ok") == "y":
        s.sendmail(from_addr,to_addr_success,mail_obj.as_string())
    else:
        s.sendmail(from_addr,to_addr_fail,mail_obj.as_string()) 
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
