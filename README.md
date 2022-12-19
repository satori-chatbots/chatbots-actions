
# SATORI Actions

![Test](https://github.com/jesusc/satori/workflows/test-satori-action/badge.svg)

This repository contains the implementation of the GitHub Actions to check chatbots using the SATORI chatbot platform.

## Development

This action has been tested with `act`. To run it, you can try:

```
 act -P ubuntu-latest=openjdk:18-alpine --env GITHUB_STEP_SUMMARY=/dev/stdout --rebuild -j check-dialogflow 
```
