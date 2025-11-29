import OpenAI from "openai";
import FormData from "form-data";
import axios from "axios";

let client = null;

/**
 * Initialise OpenAI client safely
 */
function getClient() {
  if (!client) {
    const key = process.env.OPENAI_API_KEY;
    if (!key) {
      console.warn("WARNING: OPENAI_API_KEY missing — features dependent on OpenAI will fail.");
      return null;
    }

    client = new OpenAI({ apiKey: key });
  }

  return client;
}

/**
 * HEALTH CHECK (modern, correct)
 */
export async function checkOpenAIHealth() {
  try {
    const c = getClient();
    if (!c) return false;

    // Try a minimal, safe request
    const models = await c.models.list();
    return !!models && Array.isArray(models.data);
  } catch (err) {
    console.error("OpenAI health check failed:", err.message);
    return false;
  }
}

/**
 * WHISPER TRANSCRIPTION (updated for 2025 API)
 */
export async function transcribeAudio(audioBuffer, filename = "audio.wav") {
  try {
    const c = getClient();
    if (!c) throw new Error("OpenAI client missing");

    const form = new FormData();
    form.append("file", audioBuffer, filename);
    form.append("model", "gpt-4o-mini-transcribe"); // Modern whisper model

    const response = await axios.post(
      "https://api.openai.com/v1/audio/transcriptions",
      form,
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          ...form.getHeaders(),
        },
        timeout: 60000,
      }
    );

    return response.data.text || response.data.text;
  } catch (err) {
    console.error("Transcription error:", err.response?.data || err.message);
    throw new Error(
      `Transcription failed: ${
        err.response?.data?.error?.message || err.message
      }`
    );
  }
}

/**
 * REWRITE (streaming)
 */
export async function rewriteTextStreaming(messages, params, onChunk) {
  try {
    const c = getClient();
    if (!c) throw new Error("OpenAI client missing");

    const response = await c.chat.completions.create({
      model: "gpt-4o-mini",
      messages,
      temperature: params.temperature || 0.7,
      max_tokens: params.max_tokens || 500,
      stream: true,
    });

    let full = "";

    for await (const chunk of response) {
      const delta = chunk.choices[0]?.delta?.content;
      if (delta) {
        full += delta;
        onChunk && onChunk(delta);
      }
    }

    return full;
  } catch (err) {
    console.error("Rewrite stream error:", err.message);
    throw new Error(
      `Rewrite failed: ${
        err.response?.data?.error?.message || err.message
      }`
    );
  }
}

/**
 * REWRITE (non-streaming)
 */
export async function rewriteText(messages, params) {
  try {
    const c = getClient();
    if (!c) throw new Error("OpenAI client missing");

    const response = await c.chat.completions.create({
      model: "gpt-4o-mini",
      messages,
      temperature: params.temperature || 0.7,
      max_tokens: params.max_tokens || 500,
    });

    return response.choices[0].message.content.trim();
  } catch (err) {
    console.error("Rewrite error:", err.message);
    throw new Error(
      `Rewrite failed: ${
        err.response?.data?.error?.message || err.message
      }`
    );
  }
}
