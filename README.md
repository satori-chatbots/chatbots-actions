<p align="center">
  <a href="https://github.com/satori-chatbots/chatbots-actions"><img alt="typescript-action status" src="https://github.com/jesusc/satori/workflows/test-satori-action/badge.svg"></a>
</p>

# SATORI Actions



This repository contains the implementation of a GitHub action for quality assurance of chatbots using the SATORI chatbot platform. In particular, the action: 
1. Extracts the chatbot design, producing a visualisation;
2. Applies a suite of design metrics (chatbot size, intent quality, chatbot output phrases, chatbot vocabulary, conversation, see details [here](http://www.miso.es/pubs/ACMSAC_2022.pdf)); and
3. Validates the design against well-formedness rules and quality practices (e.g., detection of unused intents, poorly trained intents, too long replies).


## Usage

Add the following entry to your Github workflow YAML file with the required inputs:

```yaml
uses: satori-chatbots/chatbots-actions@1.0
with:
    format: "Rasa"
    version: 2.0
```

### Required Inputs
The following inputs are required:
| Input | Description |
| --- | --- |
| `format` | Specifies the technology with which the chatbot was developed. Set it to `Rasa` or `Dialogflow`. |
| `version` | Specifies the Rasa version in which the chatbot was developed. Set it to `2.0` to specify Rasa 2.0 or `3.0` to specify Rasa 3.0. This input is not taken into account if the format has been defined in `Dialogflow`. |


## Possible extra configuration

For point 2 of SATORI actions, "Applies a suite of design metrics" the action allows the user to define the thresholds for these metrics as well as which ones they want to be evaluated in their project.

To do this, you must add a file called `metrics.json` to the root of the repository (if this file does not exist, all metrics will be evaluated, and the thresholds will be defined based on a study conducted on 250 GitHub chatbots). The file must adhere to the following structure:

```json
{
"ENT_MIN": 0.00,
"ENT_MAX": 9.00,
"INT_MIN": 3.00,
"INT_MAX": 29.00,
"NL_MIN": 1.00,
"NL_MAX": 10.00,
"FLOW_MIN": 2.00,
"FLOW_MAX": 21.00,
"PATH_MIN": 2.00,
"PATH_MAX": 27.00,
"LPE_MIN": 3.00,
"LPE_MAX": 13.00,
"SPL_MIN": 0.00,
"SPL_MAX": 7.00,
"WL_MIN": 3.00,
"WL_MAX": 18.00,
"CL_MIN": 1.00,
"CL_MAX": 5.00,
"FPATH_MIN": 1.00,
"FPATH_MAX": 6.00,
"FACT_MIN": 1.00,
"FACT_MAX": 5.00,
"TPI_MIN": 8.00,
"TPI_MAX": 30.00,
"WPTP_MIN": 1.00,
"WPTP_MAX": 7.00,
"PPTP_MIN": 0.00,
"PPTP_MAX": 3.00,
"CPOP_MIN": 8.00,
"CPOP_MAX": 250.00   
}
```

Through this JSON, it will be possible to establish the thresholds, and in the event that the evaluation of a certain metric is not required, the minimum and maximum values defined for that metric must be removed from this JSON. This means that it is only necessary to define a threshold (minimum or maximum) for any metric to have it considered in the evaluation. For example, if you want only the metrics ENT, INT, FLOW, and TPI to be evaluated, the content of the metrics.json file should be as follows:

```json
{
"ENT_MIN": 1.00,
"INT_MIN": 3.00,
"INT_MAX": 29.00,
"FLOW_MIN": 2.00,
"FLOW_MAX": 21.00,
"TPI_MIN": 8.00
}
```

For more information about these metrics, please visit: <a href='http://miso.ii.uam.es/asymobService/metrics.html'>asymob</a>.

## Development

This action has been tested with `act`. To run it, you can try:

```
 act -P ubuntu-latest=openjdk:18-alpine --env GITHUB_STEP_SUMMARY=/dev/stdout --rebuild -j check-dialogflow 
```
