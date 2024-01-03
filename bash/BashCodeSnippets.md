# Bash Code Snippets

### Contents
+ [Basics](#basics)
+ [Text](#text)
+ [Input](#input)
<br>

## Basics

### Get Current Shell's PID
```bash
MY_PID=$$
echo $MY_PID
```

## Text

### Color Text
```bash
BLK='\033[0;30m'    # Black
RED='\033[0;31m'    # Red
GRN='\033[0;32m'    # Green
YLW='\033[0;33m'    # Yellow
BLU='\033[0;34m'    # Blue
PUP='\033[0;35m'    # Purple
CYA='\033[0;36m'    # Cyan
WHT='\033[0;37m'    # White
NOC='\033[0m'       # No Color(=Reset)
echo -e "${BLK}Black${NOC}"
echo -e "${RED}Red${NOC}"
echo -e "${GRN}Green${NOC}"
echo -e "${YLW}Yellow${NOC}"
echo -e "${BLU}Blue${NOC}"
echo -e "${PUP}Purple${NOC}"
echo -e "${CYA}Cyan${NOC}"
echo -e "${WHT}White${NOC}"
```

### Print Arrows
   
```bash
echo -e 'LEFT  : \U2190'
echo -e 'UP    : \U2191'
echo -e 'RIGHT : \U2192'
echo -e 'DOWN  : \U2193'
echo -e 'L & R : \U2194'
echo -e 'U & D : \U2195'
```

## Input

### Wait until Keyevent
```bash
read -s -p "Press enter to continue"; echo
read -s -n 1 -p "Press any key to continue"; echo
```
