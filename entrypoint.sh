#!/bin/bash 

BGREEN='\033[1;32m'
BRED='\033[1;31m'
BYELLOW='\033[1;33m'
NC='\033[0m'

<<COMMENT
Function that returns a character depending on the type of problem.

ARGUMENTS:
    type --> The name of the problema

RETURNS:
    ⚠️ if type is 'WARNING:'
    ❌ if type is 'ERROR:'
COMMENT
function problemType() {
	type=$1
	
	if [ $type == "WARNING" ]; then
		echo "⚠️"
	fi
	if [ $type == "ERROR" ]; then
		echo "❌"
	fi
}

<<COMMENT
Function that checks if the file metrics.json exists.

ARGUMENTS:
    NO ARGUMENTS

RETURNS:
    0 if exist / 0 means success
    1 if doesn't exist / any other value than 0 means error
COMMENT
function isMetricJson(){
    if test -e metrics.json; then
        return 0
    else
        return 1
    fi
}

<<COMMENT
Function that checks if there is at least one key corresponding to the minimum or maximum value of some metric in metrics.json.

ARGUMENTS:
    key1 --> Key that refers to the maximum value of a metric.
    key2 --> Key that refers to the minimum value of a metric.

RETURNS:
    0 if at least one key exists / 0 means success
    1 if neither of both keys exists / any other value than 0 means error
COMMENT
function keys_exist(){
  local key1="$1"
  local key2="$2"

  if jq -e ".\"$key1\"" "metrics.json" >/dev/null 2>&1 || jq -e ".\"$key2\"" "metrics.json" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

<<COMMENT
Function that checks if the key exists in metric.json.

ARGUMENTS:
    key --> Key that refers to some metric value. 

RETURNS:
    0 if exist / 0 means success
    1 if doesn't exist / any other value than 0 means error
COMMENT
function key_exist(){
    local key="$1"
    if jq -e ".${key}" "metrics.json" > /dev/null; then
        return 0
    else
        return 1
    fi
}

<<COMMENT
Function that evaluate metrics.

ARGUMENTS:
    max --> is the maximum value that the metric can take.
    min -->  is the minimum value that the metric can take.
    value --> is the value of the metric.

RETURNS:
    ✅ if value is within the range between max and min
    ⚠️ if value is equal to max or min
    ❌ if value is out of the range between max and min
COMMENT
function getResult(){
    max=$1
    min=$2
    value=$3
    if [ $(echo "$value >= $min && $value <= $max" | bc -l) -eq 1 ]
    then
        if [ $(echo "$value == $min || $value == $max" | bc -l) -eq 1 ]        
        then
            echo "⚠️"
        else
            echo "✅"
        fi        
    else
        echo "❌"
    fi
}


function getRanges(){
    max=$1
    min=$2
    echo "[ $min, $max ]"
       
}

function getDescription() {
    max=$1
    min=$2
    value=$3
    if [ $(echo "$value >= $min && $value <= $max" | bc -l) -eq 1 ]
    then
        if [ $(echo "$value == $min || $value == $max" | bc -l) -eq 1 ]        
        then
            if [ $(echo "$value == $min" | bc -l) -eq 1 ]; then
            echo "Be careful the metric is at the edge of the lower range."
        else
            echo "Be careful the metric is at the edge of the upper range."
        fi
        else
            echo "Everything is fine."
        fi        
    else
        if [ $(echo "$value < $min" | bc -l) -eq 1 ]; then
            echo "Metric is out of the lower range."
        else
            echo "Metric is out of the upper range."
        fi
    fi
}

<<COMMENT
Function that initializes the max and min values of the metric received as argument.

ARGUMENTS:
    metric --> It is the metric.

RETURNS:
    NO RETURNS:
COMMENT
function initializeEvalMetrics(){
    metric=$1
	case $metric in
	
    ENT)
     if isMetricJson; then
        if keys_exist ENT_MAX ENT_MIN; then
            if key_exist ENT_MIN; then
                gM_ENT_MIN=$(jq -r '.ENT_MIN' metrics.json)
            else
                gM_ENT_MIN=0
            fi
            if key_exist ENT_MAX; then
                gM_ENT_MAX=$(jq -r '.ENT_MAX' metrics.json)              
            else
                gM_ENT_MAX=9
            fi
        else
        echo "Metrics ENT_MAX or ENT_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_ENT_MIN=0
	 gM_ENT_MAX=9 
	 fi
     ;;

    INT)
     if isMetricJson; then
        if keys_exist INT_MAX INT_MIN; then
            if key_exist INT_MIN; then
                gM_INT_MIN=$(jq -r '.INT_MIN' metrics.json)
            else
                gM_INT_MIN=3
            fi
            if key_exist INT_MAX; then
                gM_INT_MAX=$(jq -r '.INT_MAX' metrics.json)              
            else
                gM_INT_MAX=29
            fi
        else
        echo "Metrics INT_MAX or INT_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_INT_MIN=3
	 gM_INT_MAX=29 
	 fi     
     ;;

    NL)
     if isMetricJson; then
        if keys_exist NL_MAX NL_MIN; then
            if key_exist NL_MIN; then
                gM_NL_MIN=$(jq -r '.NL_MIN' metrics.json)
            else
                gM_NL_MIN=1
            fi
            if key_exist NL_MAX; then
                gM_NL_MAX=$(jq -r '.NL_MAX' metrics.json)              
            else
                gM_NL_MAX=10
            fi
        else
        echo "Metrics NL_MAX or NL_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_NL_MIN=1
	 gM_NL_MAX=10
	 fi     
     ;;

    FLOW)
     if isMetricJson; then
        if keys_exist FLOW_MAX FLOW_MIN; then
            if key_exist FLOW_MIN; then
                gM_FLOW_MIN=$(jq -r '.FLOW_MIN' metrics.json)
            else
                gM_FLOW_MIN=2
            fi
            if key_exist FLOW_MAX; then
                gM_FLOW_MAX=$(jq -r '.FLOW_MAX' metrics.json)              
            else
                gM_FLOW_MAX=21
            fi
        else
        echo "Metrics FLOW_MAX or FLOW_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_FLOW_MIN=2
	 gM_FLOW_MAX=21 
	 fi     
     ;;
    
    PATH)
     if isMetricJson; then
        if keys_exist PATH_MAX PATH_MIN; then
            if key_exist PATH_MIN; then
                gM_PATH_MIN=$(jq -r '.PATH_MIN' metrics.json)
            else
                gM_PATH_MIN=2
            fi
            if key_exist PATH_MAX; then
                gM_PATH_MAX=$(jq -r '.PATH_MAX' metrics.json)              
            else
                gM_PATH_MAX=27
            fi
        else
        echo "Metrics PATH_MAX or PATH_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_PATH_MIN=2
	 gM_PATH_MAX=27 
	 fi     
     ;;

    LPE)
     if isMetricJson; then
        if keys_exist LPE_MAX LPE_MIN; then
            if key_exist LPE_MIN; then
                gM_LPE_MIN=$(jq -r '.LPE_MIN' metrics.json)
            else
                gM_LPE_MIN=3
            fi
            if key_exist LPE_MAX; then
                gM_LPE_MAX=$(jq -r '.LPE_MAX' metrics.json)              
            else
                gM_LPE_MAX=13
            fi
        else
        echo "Metrics LPE_MAX or LPE_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_LPE_MIN=3
	 gM_LPE_MAX=13 
	 fi     
     ;;

    SPL) 
     if isMetricJson; then
        if keys_exist SPL_MAX SPL_MIN; then
            if key_exist SPL_MIN; then
                gM_SPL_MIN=$(jq -r '.SPL_MIN' metrics.json)
            else
                gM_SPL_MIN=0
            fi
            if key_exist SPL_MAX; then
                gM_SPL_MAX=$(jq -r '.SPL_MAX' metrics.json)              
            else
                gM_SPL_MAX=7
            fi
        else
        echo "Metrics SPL_MAX or SPL_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_SPL_MIN=0
	 gM_SPL_MAX=7 
	 fi     
     ;;
    
    WL)
     if isMetricJson; then
        if keys_exist WL_MAX WL_MIN; then
            if key_exist WL_MIN; then
                gM_WL_MIN=$(jq -r '.WL_MIN' metrics.json)
            else
                gM_WL_MIN=3
            fi
            if key_exist WL_MAX; then
                gM_WL_MAX=$(jq -r '.WL_MAX' metrics.json)              
            else
                gM_WL_MAX=18
            fi
        else
        echo "Metrics WL_MAX or WL_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_WL_MIN=3
	 gM_WL_MAX=18 
	 fi     
     ;;
    
    CL)
     if isMetricJson; then
        if keys_exist CL_MAX CL_MIN; then
            if key_exist CL_MIN; then
                gM_CL_MIN=$(jq -r '.CL_MIN' metrics.json)
            else
                gM_CL_MIN=1
            fi
            if key_exist CL_MAX; then
                gM_CL_MAX=$(jq -r '.CL_MAX' metrics.json)              
            else
                gM_CL_MAX=5
            fi
        else
        echo "Metrics CL_MAX or CL_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_CL_MIN=1
	 gM_CL_MAX=5 
	 fi     
     ;;

    FPATH)
     if isMetricJson; then
        if keys_exist FPATH_MAX FPATH_MIN; then
            if key_exist FPATH_MIN; then
                gM_FPATH_MIN=$(jq -r '.FPATH_MIN' metrics.json)
            else
                gM_FPATH_MIN=1
            fi
            if key_exist FPATH_MAX; then
                gM_FPATH_MAX=$(jq -r '.FPATH_MAX' metrics.json)              
            else
                gM_FPATH_MAX=6
            fi
        else
        echo "Metrics FPATH_MAX or FPATH_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_FPATH_MIN=1
	 gM_FPATH_MAX=6 
	 fi     
     ;;
    
    FACT)
     if isMetricJson; then
        if keys_exist FACT_MAX FACT_MIN; then
            if key_exist FACT_MIN; then
                gM_FACT_MIN=$(jq -r '.FACT_MIN' metrics.json)
            else
                gM_FACT_MIN=1
            fi
            if key_exist FACT_MAX; then
                gM_FACT_MAX=$(jq -r '.FACT_MAX' metrics.json)              
            else
                gM_FACT_MAX=5
            fi
        else
        echo "Metrics FACT_MAX or FACT_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_FACT_MIN=1
	 gM_FACT_MAX=5
	 fi     
     ;;

    TPI)
    if isMetricJson; then
        if keys_exist TPI_MAX TPI_MIN; then
            if key_exist TPI_MIN; then
                gM_TPI_MIN=$(jq -r '.TPI_MIN' metrics.json)
            else
                gM_TPI_MIN=8
            fi
            if key_exist TPI_MAX; then
                gM_TPI_MAX=$(jq -r '.TPI_MAX' metrics.json)              
            else
                gM_TPI_MAX=30
            fi
        else
        echo "Metrics TPI_MAX or TPI_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_TPI_MIN=8
	 gM_TPI_MAX=30
	 fi     
     ;;
    
    WPTP)
     if isMetricJson; then
        if keys_exist WPTP_MAX WPTP_MIN; then
            if key_exist WPTP_MIN; then
                gM_WPTP_MIN=$(jq -r '.WPTP_MIN' metrics.json)
            else
                gM_WPTP_MIN=1
            fi
            if key_exist WPTP_MAX; then
                gM_WPTP_MAX=$(jq -r '.WPTP_MAX' metrics.json)              
            else
                gM_WPTP_MAX=7
            fi
        else
        echo "Metrics WPTP_MAX or WPTP_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_WPTP_MIN=1
	 gM_WPTP_MAX=7 
	 fi     
     ;;

    PPTP)
    if isMetricJson; then
        if keys_exist PPTP_MAX PPTP_MIN; then
            if key_exist PPTP_MIN; then
                gM_PPTP_MIN=$(jq -r '.PPTP_MIN' metrics.json)
            else
                gM_PPTP_MIN=0
            fi
            if key_exist PPTP_MAX; then
                gM_PPTP_MAX=$(jq -r '.PPTP_MAX' metrics.json)              
            else
                gM_PPTP_MAX=3
            fi
        else
        echo "Metrics PPTP_MAX or PPTP_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_PPTP_MIN=0
	 gM_PPTP_MAX=3 
	 fi     
     ;;    

	CPOP)
	 if isMetricJson; then
        if keys_exist CPOP_MAX CPOP_MIN; then
            if key_exist CPOP_MIN; then
                gM_CPOP_MIN=$(jq -r '.CPOP_MIN' metrics.json)
            else
                gM_CPOP_MIN=8
            fi
            if key_exist CPOP_MAX; then
                gM_CPOP_MAX=$(jq -r '.CPOP_MAX' metrics.json)              
            else
                gM_CPOP_MAX=250
            fi
        else
        echo "Metrics CPOP_MAX or CPOP_MIN do not exist in metrics.json"     
        fi
	 else	 
	 gM_CPOP_MIN=8
	 gM_CPOP_MAX=250 
	 fi     
	 ;;
	esac
}

echo "::group::Values for metrics evaluation"
echo "Initialize values for metrics evaluation"
initializeEvalMetrics ENT
initializeEvalMetrics INT
initializeEvalMetrics NL
initializeEvalMetrics FLOW
initializeEvalMetrics PATH
initializeEvalMetrics LPE
initializeEvalMetrics SPL
initializeEvalMetrics WL
initializeEvalMetrics CL
initializeEvalMetrics FPATH
initializeEvalMetrics FACT
initializeEvalMetrics TPI
initializeEvalMetrics WPTP
initializeEvalMetrics PPTP
initializeEvalMetrics CPOP
echo "::endgroup::"


if [ "$INPUT_FORMAT" = "" ]; then
    echo -e "${BRED}Format must be specified${NC}"
    exit 1
fi

echo -e "Testing chat-bot from ${BYELLOW}$GITHUB_REPOSITORY${NC} with:"
echo -e " - format: ${BYELLOW}[$INPUT_FORMAT]${NC}"

repo=$(echo $GITHUB_REPOSITORY | cut -d'/' -f2)

if [ "$INPUT_FORMAT" = "conga" ]; then
    INPUT_FILES=$repo.xmi
else
    echo "::group::Compressing repository"
    INPUT_FILES=chatbot.zip
    PLANTUML_TXT=chatbot.txt
    if [ "$INPUT_FORMAT" = "Rasa" ]; then
        if [ "$INPUT_VERSION" = "1.10" ]; then
            echo "Version: 1.10"
        else
            echo "Version: 2.0 or 3.0"
            zip -r $INPUT_FILES data/ actions/ config.yml credentials.yml domain.yml endpoints.yml
        fi
    else
         if [ "$INPUT_FORMAT" = "Dialogflow" ]; then
            echo "Version: 2.0 or 3.0"
            zip -r $INPUT_FILES entities/ intents/ agent.json package.json
         fi
    fi        
    echo "::endgroup::"
fi

XMI_OUTPUT="${INPUT_FILES/.zip/.xmi}"
echo "VER OUTPUT: $XMI_OUTPUT"
METRICS_OUTPUT="${INPUT_FILES/.zip/.metrics.json}"

if [ "$INPUT_FORMAT" = "conga" ]; then
#  echo `ls /`
    java -jar /AsymobJSON.jar $INPUT_FILES | tee /tmp/output.txt
    COUNT=`grep "INP = 0" /tmp/output.txt | wc --lines`
    if [ $COUNT -gt 2 ]; then
	echo "More than two intents with INP > 2"
	exit 1
    fi
else
    echo "::debug::{Running CONGA with $INPUT_FILES}"
    ls
    java -jar /CongaReverse3.4_pUML.jar $INPUT_FILES $INPUT_FORMAT $INPUT_VERSION

    XMI_FILE=./chatbot.xmi

    if test -f "$XMI_FILE"; then    
        echo -e "${BGREEN}Archivo $XMI_FILE ha sido creado exitosamente${NC}"
    else
        echo -e "${BRED}Hubo un error al generar el archivo $XMI_FILE${NC}"
        exit 1
    fi

    java -jar /plantUML-encode.jar $PLANTUML_TXT
    imgEncoded=$(cat plantUML-encoded.txt)

    congaValidator=$(java -jar /CONGA_Validator.jar $XMI_OUTPUT 2>&1)    

    echo "::debug::{Running Asymob with $XMI_OUTPUT}"
    java -jar /AsymobJSON.jar $XMI_OUTPUT
fi

globalMetrics=$(jq -r '.["Global Metrics"]' $METRICS_OUTPUT)

gM_ENT=$(echo "$globalMetrics" | jq '.ENT')
gM_INT=$(echo "$globalMetrics" | jq '.INT')
gM_NL=$(echo "$globalMetrics" | jq '.NL')
gM_FLOW=$(echo "$globalMetrics" | jq '.FLOW')
gM_PATH=$(echo "$globalMetrics" | jq '.PATH')
gM_LPE=$(echo "$globalMetrics" | jq '.LPE')
gm_LPE=$(echo "$gm_LPE" | bc)

gM_SPL=$(echo "$globalMetrics" | jq '.SPL')
gM_WL=$(echo "$globalMetrics" | jq '.WL')
gM_CL=$(echo "$globalMetrics" | jq '.CL')
gM_FPATH=$(echo "$globalMetrics" | jq '.FPATH')
gM_FACT=$(echo "$globalMetrics" | jq '.FACT')
gM_TPI=$(echo "$globalMetrics" | jq '.TPI')
gM_WPTP=$(echo "$globalMetrics" | jq '.WPTP')
gM_PPTP=$(echo "$globalMetrics" | jq '.PPTP')
gM_CPOP=$(echo "$globalMetrics" | jq '.CPOP')

#Making chatbot conversation flow
echo "# Chatbot conversation flow" >> "${GITHUB_STEP_SUMMARY}"
echo "![$repo conversation flow](http://www.plantuml.com/plantuml/png/$imgEncoded)" >> "${GITHUB_STEP_SUMMARY}"
echo "#### This diagram is built thanks to:  <a href='https://plantuml.com/'>PlantUML</a>" >> "${GITHUB_STEP_SUMMARY}"
echo "****" >> "${GITHUB_STEP_SUMMARY}"

#Making table about metrics
echo "# Chatbot Metrics" >> "${GITHUB_STEP_SUMMARY}"
echo "| RESULT | METRIC | VALUE | RANGE | DESCRIPTION |" >> "${GITHUB_STEP_SUMMARY}"
echo " :-: | :-: | :-: | :-: | :--- " >> "${GITHUB_STEP_SUMMARY}"
if isMetricJson; then
    if keys_exist ENT_MAX ENT_MIN; then
    echo " $(getResult $gM_ENT_MAX $gM_ENT_MIN $gM_ENT) | ENT | $gM_ENT | $(getRanges $gM_ENT_MAX $gM_ENT_MIN) | $(getDescription $gM_ENT_MAX $gM_ENT_MIN $gM_ENT) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist INT_MAX INT_MIN; then
    echo " $(getResult $gM_INT_MAX $gM_INT_MIN $gM_INT) | INT | $gM_INT | $(getRanges $gM_INT_MAX $gM_INT_MIN) | $(getDescription $gM_INT_MAX $gM_INT_MIN $gM_INT) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist NL_MAX NL_MIN; then
    echo " $(getResult $gM_NL_MAX $gM_NL_MIN $gM_NL) | NL | $gM_NL | $(getRanges $gM_INT_MAX $gM_INT_MIN) | $(getDescription $gM_NL_MAX $gM_NL_MIN $gM_NL) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist FLOW_MAX FLOW_MIN; then
    echo " $(getResult $gM_FLOW_MAX $gM_FLOW_MIN $gM_FLOW) | FLOW | $gM_FLOW | $(getRanges $gM_FLOW_MAX $gM_FLOW_MIN) | $(getDescription $gM_FLOW_MAX $gM_FLOW_MIN $gM_FLOW) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist PATH_MAX PATH_MIN; then
    echo " $(getResult $gM_PATH_MAX $gM_PATH_MIN $gM_PATH) | PATH | $gM_PATH | $(getRanges $gM_PATH_MAX $gM_PATH_MIN) | $(getDescription $gM_PATH_MAX $gM_PATH_MIN $gM_PATH) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist LPE_MAX LPE_MIN; then
    echo " $(getResult $gM_LPE_MAX $gM_LPE_MIN $gM_LPE) | LPE | $gM_LPE | $(getRanges $gM_LPE_MAX $gM_LPE_MIN) | $(getDescription $gM_LPE_MAX $gM_LPE_MIN $gM_LPE) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist SPL_MAX SPL_MIN; then
    echo " $(getResult $gM_SPL_MAX $gM_SPL_MIN $gM_SPL) | SPL | $gM_SPL | $(getRanges $gM_SPL_MAX $gM_SPL_MIN) | $(getDescription $gM_SPL_MAX $gM_SPL_MIN $gM_SPL) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist WL_MAX WL_MIN; then
    echo " $(getResult $gM_WL_MAX $gM_WL_MIN $gM_WL) | WL | $gM_WL | $(getRanges $gM_WL_MAX $gM_WL_MIN) | $(getDescription $gM_WL_MAX $gM_WL_MIN $gM_WL) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist CL_MAX CL_MIN; then
    echo " $(getResult $gM_CL_MAX $gM_CL_MIN $gM_CL) | CL | $gM_CL | $(getRanges $gM_CL_MAX $gM_CL_MIN) | $(getDescription $gM_CL_MAX $gM_CL_MIN $gM_CL) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist FPATH_MAX FPATH_MIN; then
    echo " $(getResult $gM_FPATH_MAX $gM_FPATH_MIN $gM_FPATH) | FPATH | $gM_FPATH | $(getRanges $gM_FPATH_MAX $gM_FPATH_MIN) | $(getDescription $gM_FPATH_MAX $gM_FPATH_MIN $gM_FPATH) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist FACT_MAX FACT_MIN; then
    echo " $(getResult $gM_FACT_MAX $gM_FACT_MIN $gM_FACT) | FACT | $gM_FACT | $(getRanges $gM_FACT_MAX $gM_FACT_MIN) | $(getDescription $gM_FACT_MAX $gM_FACT_MIN $gM_FACT) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist TPI_MAX TPI_MIN; then
    echo " $(getResult $gM_TPI_MAX $gM_TPI_MIN $gM_TPI) | TPI | $gM_TPI | $(getRanges $gM_TPI_MAX $gM_TPI_MIN) | $(getDescription $gM_TPI_MAX $gM_TPI_MIN $gM_TPI) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist WPTP_MAX WPTP_MIN; then
    echo " $(getResult $gM_WPTP_MAX $gM_WPTP_MIN $gM_WPTP) | WPTP | $gM_WPTP | $(getRanges $gM_WPTP_MAX $gM_WPTP_MIN) | $(getDescription $gM_WPTP_MAX $gM_WPTP_MIN $gM_WPTP) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist PPTP_MAX PPTP_MIN; then
    echo " $(getResult $gM_PPTP_MAX $gM_PPTP_MIN $gM_PPTP) | PPTP | $gM_PPTP | $(getRanges $gM_PPTP_MAX $gM_PPTP_MIN) | $(getDescription $gM_PPTP_MAX $gM_PPTP_MIN $gM_PPTP) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
    if keys_exist CPOP_MAX CPOP_MIN; then
    echo " $(getResult $gM_CPOP_MAX $gM_CPOP_MIN $gM_CPOP) | CPOP | $gM_CPOP | $(getRanges $gM_CPOP_MAX $gM_CPOP_MIN) | $(getDescription $gM_CPOP_MAX $gM_CPOP_MIN $gM_CPOP) |" >> "${GITHUB_STEP_SUMMARY}"
    fi
else 
    echo " $(getResult $gM_ENT_MAX $gM_ENT_MIN $gM_ENT) | ENT | $gM_ENT | $(getRanges $gM_ENT_MAX $gM_ENT_MIN) | $(getDescription $gM_ENT_MAX $gM_ENT_MIN $gM_ENT) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_INT_MAX $gM_INT_MIN $gM_INT) | INT | $gM_INT | $(getRanges $gM_INT_MAX $gM_INT_MIN) | $(getDescription $gM_INT_MAX $gM_INT_MIN $gM_INT) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_NL_MAX $gM_NL_MIN $gM_NL) | NL | $gM_NL | $(getRanges $gM_NL_MAX $gM_NL_MIN) | $(getDescription $gM_NL_MAX $gM_NL_MIN $gM_NL) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_FLOW_MAX $gM_FLOW_MIN $gM_FLOW) | FLOW | $gM_FLOW | $(getRanges $gM_FLOW_MAX $gM_FLOW_MIN) | $(getDescription $gM_FLOW_MAX $gM_FLOW_MIN $gM_FLOW) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_PATH_MAX $gM_PATH_MIN $gM_PATH) | PATH | $gM_PATH | $(getRanges $gM_PATH_MAX $gM_PATH_MIN) | $(getDescription $gM_PATH_MAX $gM_PATH_MIN $gM_PATH) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_LPE_MAX $gM_LPE_MIN $gM_LPE) | LPE | $gM_LPE | $(getRanges $gM_LPE_MAX $gM_LPE_MIN) | $(getDescription $gM_LPE_MAX $gM_LPE_MIN $gM_LPE) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_SPL_MAX $gM_SPL_MIN $gM_SPL) | SPL | $gM_SPL | $(getRanges $gM_SPL_MAX $gM_SPL_MIN) | $(getDescription $gM_SPL_MAX $gM_SPL_MIN $gM_SPL) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_WL_MAX $gM_WL_MIN $gM_WL) | WL | $gM_WL | $(getRanges $gM_WL_MAX $gM_WL_MIN) | $(getDescription $gM_WL_MAX $gM_WL_MIN $gM_WL) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_CL_MAX $gM_CL_MIN $gM_CL) | CL | $gM_CL | $(getRanges $gM_CL_MAX $gM_CL_MIN) | $(getDescription $gM_CL_MAX $gM_CL_MIN $gM_CL) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_FPATH_MAX $gM_FPATH_MIN $gM_FPATH) | FPATH | $gM_FPATH | $(getRanges $gM_FPATH_MAX $gM_FPATH_MIN) | $(getDescription $gM_FPATH_MAX $gM_FPATH_MIN $gM_FPATH) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_FACT_MAX $gM_FACT_MIN $gM_FACT) | FACT | $gM_FACT | $(getRanges $gM_FACT_MAX $gM_FACT_MIN) | $(getDescription $gM_FACT_MAX $gM_FACT_MIN $gM_FACT) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_TPI_MAX $gM_TPI_MIN $gM_TPI) | TPI | $gM_TPI | $(getRanges $gM_TPI_MAX $gM_TPI_MIN) | $(getDescription $gM_TPI_MAX $gM_TPI_MIN $gM_TPI) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_WPTP_MAX $gM_WPTP_MIN $gM_WPTP) | WPTP | $gM_WPTP | $(getRanges $gM_WPTP_MAX $gM_WPTP_MIN) | $(getDescription $gM_WPTP_MAX $gM_WPTP_MIN $gM_WPTP) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_PPTP_MAX $gM_PPTP_MIN $gM_PPTP) | PPTP | $gM_PPTP | $(getRanges $gM_PPTP_MAX $gM_PPTP_MIN) | $(getDescription $gM_PPTP_MAX $gM_PPTP_MIN $gM_PPTP) |" >> "${GITHUB_STEP_SUMMARY}"
    echo " $(getResult $gM_CPOP_MAX $gM_CPOP_MIN $gM_CPOP) | CPOP | $gM_CPOP | $(getRanges $gM_CPOP_MAX $gM_CPOP_MIN) | $(getDescription $gM_CPOP_MAX $gM_CPOP_MIN $gM_CPOP) |" >> "${GITHUB_STEP_SUMMARY}"
fi
echo "#### For more information on the interpretation of these metrics, please visit:  <a href='http://miso.ii.uam.es/asymobService/metrics.html'>asymob</a>" >> "${GITHUB_STEP_SUMMARY}"

#Making table of conga validations
echo "****" >> "${GITHUB_STEP_SUMMARY}"
echo "# Conga Validation" >> "${GITHUB_STEP_SUMMARY}"

SAVEIFS=$IFS
IFS=$'\n'  
congaValidProb=($congaValidator) 
IFS=$SAVEIFS
total=${#congaValidProb[@]}
cont=1

echo "| RESULT | ID | PROBLEM |" >> "${GITHUB_STEP_SUMMARY}"
echo " :-: | :-: | :--- " >> "${GITHUB_STEP_SUMMARY}"
if [ $total -gt 0 ]; then
	while [ $cont -lt $total ]
	do		
		SAVEIFS=$IFS
		IFS=$':'  
		row=(${congaValidProb[$cont]}) 
		IFS=$SAVEIFS
		rule=$(echo "${row[1]}" | cut -c 1-4)
		rule=$(echo "$rule" | tr -d ' ')
		des=$(echo "${row[1]}" | cut -c 5-)
        echo " $(problemType ${row[0]}) | $rule | $des |" >> "${GITHUB_STEP_SUMMARY}"
		cont=$((cont+1))
	done
fi
echo "#### Summary: ${congaValidProb[0]}" >> "${GITHUB_STEP_SUMMARY}"

echo "::group::Metrics"
echo "Information about metrics"
echo "::endgroup::"
echo "Expected file"
echo $METRICS_OUTPUT

exit 0
