
# SATORI Actions

![Test](https://github.com/jesusc/satori/workflows/test-satori-action/badge.svg)

This repository contains the implementation of the GitHub Actions to check chatbots using the SATORI chatbot platform.

## Usage

Add the following entry to your Github workflow YAML file with the required inputs:

```yaml
uses: satori-chatbots/chatbots-actions
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
