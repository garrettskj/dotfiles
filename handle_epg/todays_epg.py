#!/usr/bin/env python

import xmltv
import time
import subprocess
import json

def todays_schedule():
	l_time = time.localtime()
	#tm_year=2019, tm_mon=3, tm_mday=26, tm_hour=22, tm_min=49, tm_sec=54, tm_wday=1, tm_yday=85
	today = []
	for time_value in range(0,len(l_time)):
		if time_value < 5: # only get the Y/M/D/H/M
			if int(l_time[time_value] <= 9):
				today.append(str(l_time[time_value]).zfill(2))
			else:
				today.append(str(l_time[time_value]))

	# returns time YYYYMMDDHHmm
	return ''.join(today)

def get_xml_data(time):

	# generate the XML filename based on today's date.
	xml_filename = time[:-4] + ".xml"

	# try and see if the file already exists.
	try:
		print ("Looking for today's EPG Data...")
		fh = open(xml_filename, 'r')
		fh.close()
	except FileNotFoundError:
		# If the file doesn't exist, go and get it.
		print ("We didn't find today's EPG data, therefore we are going to need to go and get it...")
		username = input("Enter your Zap2it username: ").rstrip()
		password = input("Enter your Zap2it password: ").rstrip()
		p = subprocess.Popen(["perl", "zap2xml.pl", '-u', username, '-p', password, '-U', '-o', xml_filename], stdout=subprocess.PIPE)
		p.communicate()
	
	try:
		with open(xml_filename, 'r') as xml_file:
			programs = xmltv.read_programmes(xml_file)
	except FileNotFoundError:
		print("Unable to open the file still. Check your usernames and permissions and try again.")
		exit()

	return programs

def print_schedule(programs, channel_list):

	for pgram in programs:
		# Determine if we even have the channel, by looking at the latest channel list and comparing it.
		if pgram['channel'].split('.')[0][1:] in [channel_data[0] for channel_data in channel_list]:
			# Now determine if the show starts today, (removed hours and minutes)
			if pgram['start'].startswith(todays_schedule()[:-4]):
				# If the start time + the duration is before than the current time, assume it's over.
				if (int(pgram['start'][8:12]) + int(pgram['length']['length'])) < int(todays_schedule()[-4:]):
					order = "OVER:"
				# otherwise, if the show time started before the current time, assume it's happening now.
				elif pgram['start'][8:12] < (todays_schedule()[-4:]):
					order = "NOW:"
				# otherwise the show is still upcoming.
				else:
					order = "SOON:"
				# Print the title, the start time, and the channel
				print(f"{order} {pgram['title'][0][0]} at {pgram['start'][8:12]}+{pgram['length']['length']} on Channel: {pgram['channel'].split('.')[0][1:]}") 

def json_channel_list(hdhomerun_channel_file):

	with open(hdhomerun_channel_file) as json_file:
		data = json.load(json_file)

	goodChannelList = []

	for channel in data:
		for g_key, g_value in channel.items():
			if g_key == 'GuideNumber':
				chan = g_value
			if g_key == 'GuideName':
				name = g_value

		goodChannelList.append((chan, name))
		
	return goodChannelList

def main_prog():

	short_time = todays_schedule()

	program_data = get_xml_data(short_time)

	avail_channels = json_channel_list('lineup.json')

	print_schedule(program_data, avail_channels)

if __name__ == '__main__':
	main_prog()

# {'channel': 'I1796.20655.zap2it.com',                                                                    
# 'episode-num': [('SH02507767.0000', 'dd_progid')],                                                       
# 'icon': [{'src': 'https://zap2it.tmsimg.com/assets/p13264747_st_v8_aa.jpg'}],                            
# 'length': {'length': '30', 'units': 'minutes'},                                                          
# 'new': True,                                                                                             
# 'start': '20190402090000 -0700',                                                                         
# 'stop': '20190402093000 -0700',                                                                          
# 'title': [('Art of Life', 'en')],                                                                        
# 'url': ['https://tvlistings.zap2it.com//overview.html?programSeriesId=SH02507767&tmsId=SH025077670000']},