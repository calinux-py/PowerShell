# AI-PowerShell (Ask-AI v.2)

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)

AI-PowerShell (Ask-AI v.2) is a PowerShell function designed to simplify troubleshooting within PowerShell. With this tool, you can easily request assistance for resolving errors, rectifying syntax issues, or locating the right commands using the power of OpenAI's GPT-3 engine.

## Prerequisites

Before you get started, make sure you have the following prerequisites:

- PowerShell 5.1 or higher
- An OpenAI API key

## Installation

1. Clone or download this repository to your local machine.
2. Open the `AskAI.ps1` file.
3. Replace `'OPENAI API HERE'` with your actual OpenAI API key.
4. Save the changes.

## Usage

AI-PowerShell offers several options to customize your interaction:

- `/s`: Display the full message sent to OpenAI's API.
- `/d`: Request detailed assistance (expands tokens and word count from OpenAI).
- `/a`: Display the full message and request detailed assistance.
- `/i`: Send a custom message to OpenAI's API.
- `/help` or `/?`: Display the help message.

### Examples

   To request assistance with the last error message:
   ```powershell
   Ask-AI
   ```

   To display the help message:
   ```powershell
   Ask-AI /?
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

