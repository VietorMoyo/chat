const axios = require('axios');
require('dotenv').config();

/**
 * Translates text using the MyMemory Translation API (Free).
 * Documentation: https://mymemory.translated.net/doc/spec.php
 *
 * @param {string} text - The text to translate.
 * @param {string} targetLang - The target language code (e.g., 'es').
 * @param {string} sourceLang - The source language code (e.g., 'en').
 * @returns {Promise<string>} - The translated text.
 */
async function translateText(text, targetLang, sourceLang) {
  // If languages are the same, return original text
  if (sourceLang === targetLang) {
    return text;
  }

  try {
    const langPair = `${sourceLang}|${targetLang}`;
    const url = `https://api.mymemory.translated.net/get?q=${encodeURIComponent(text)}&langpair=${encodeURIComponent(langPair)}`;

    const response = await axios.get(url);

    if (response.data && response.data.responseData) {
      const translatedText = response.data.responseData.translatedText;
      console.log(`[MyMemory] Translated "${text}" (${sourceLang}) to "${translatedText}" (${targetLang})`);
      return translatedText;
    } else {
      console.warn('[MyMemory] Unexpected response structure:', response.data);
      return text;
    }
  } catch (error) {
    console.error('[MyMemory] Translation error:', error.message);
    // Fallback to original text if translation fails
    return text;
  }
}

module.exports = { translateText };
