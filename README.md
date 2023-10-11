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


## Development

This action has been tested with `act`. To run it, you can try:

```
 act -P ubuntu-latest=openjdk:18-alpine --env GITHUB_STEP_SUMMARY=/dev/stdout --rebuild -j check-dialogflow 
```
