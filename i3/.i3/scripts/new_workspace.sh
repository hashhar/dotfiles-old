#!/usr/bin/env bash

# workspace[0]="1: "
# workspace[1]="1:  1"
# workspace[2]="1:  2"
# # Terminals
# workspace[3]="2: "
# workspace[4]="2:   "
# workspace[5]="2:    "
# workspace[6]="2:  "
# workspace[7]="2:  "
# # Code Editing
# workspace[8]="3:  "
# workspace[9]="3:   "
# workspace[10]="3:    "
# workspace[11]="3:  "
# workspace[12]="3:  "
# # Firefox
# workspace[13]="4: "
# workspace[14]="4: "
# workspace[15]="4: "
# workspace[16]="4: "
# workspace[17]="4: "
# # File Explorer
# workspace[18]="5: "
# # VM
# workspace[19]="6: "
# workspace[20]="6: "
# workspace[21]="6: "
# workspace[22]="6: "
# workspace[23]="6: "
# # Chat and Correspondence
# workspace[24]="7: "
# workspace[25]="7: "
# workspace[26]="7: "
# workspace[27]="7: "
# # Reading and Study
# workspace[28]="8:  "
# # Movies and TV
# workspace[29]="9:  "
# # Music
# workspace[30]="10: "
# 
# for (( i = 0; i < 30; i++ )); do
# 	i3-msg -t command workspace ${workspace[i]}
# 	if [ $? -eq 0 ]; then
# 		break
# 	fi
# done

i3-msg workspace $(($(i3-msg -t get_workspaces | tr , '\n' | grep '\"num\":' | cut -d : -f 2 | sort -rn | head -1) + 1))
