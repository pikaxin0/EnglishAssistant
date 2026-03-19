#!/usr/bin/env node
import { translate } from '../shared/ai.js';
import { getDb } from '../shared/db.js';
import { readFileSync } from 'fs';
import { existsSync } from 'fs';

async function main() {
  // Get text from command-line argument
  let text = process.argv[2];

  if (!text) {
    console.error('Error: No text provided for translation');
    console.error('Usage: english-assistant "<text to translate>"');
    console.error('       english-assistant <file-path>');
    process.exit(1);
  }

  // Check if the argument is a file path (for AHK temp file support)
  if (existsSync(text)) {
    text = readFileSync(text, 'utf-8');
  }

  try {
    // Translate the text
    const translation = await translate(text);

    // Save to database
    const db = getDb();
    db.insertTranslation(text, translation);

    // Output translation to stdout (for AHK to capture)
    console.log(translation);

    process.exit(0);
  } catch (error) {
    // Output error to stdout
    if (error instanceof Error) {
      console.error(error.message);
    } else {
      console.error('Error: Translation failed');
    }
    process.exit(1);
  }
}

main();
