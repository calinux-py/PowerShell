# Ask-AI
![](https://img.shields.io/badge/-PowerShell-blue)


## Overview

Ask-AI is a simple PowerShell script that interacts with the OpenAI GPT API to generate text completions. The function `Ask-AI` takes user input and sends it to the API, which returns a response using less than 50 words.

## Requirements

- PowerShell
- OpenAI API key

## Installation

1. Clone this repository to your local machine.
2. Replace `'YOUR OPEN AI API'` in the script with your actual OpenAI API key.

## Usage

Run the script, and then call the function `Ask-AI`:

```powershell
Ask-AI
```

1. You'll see the prompt "`nUser Input:`.
2. Enter your query.
3. Receive a response from the GPT engine.

## Configuration

You can change the settings of the API call by modifying the `$body` variable in the script:

- `'temperature'`: Controls the randomness (0 is deterministic, 1 is random).
- `'max_tokens'`: The maximum number of tokens for the output.
- `'top_p'`: Controls diversity via nucleus sampling.
- `'frequency_penalty'`: Penalty for frequent tokens.
- `'presence_penalty'`: Penalty for new tokens.
