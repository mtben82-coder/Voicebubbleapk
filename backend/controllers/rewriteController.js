// backend/controllers/rewriteController.js

import { AppError } from "../utils/errors.js";
import { createChatCompletion, createChatCompletionStream } from "../services/openaiService.js";
import { buildMessages, getPresetParameters } from "../prompt_engine/builder.js";
import {
  getRewriteFromCache,
  setRewriteInCache,
} from "../cache/rewriteCache.js";

/**
 * POST /api/rewrite/batch
 * Body: { text, presetId, language? }
 * Returns JSON with full rewritten text.
 */
export async function batchRewrite(req, res, next) {
  const start = Date.now();
  try {
    const { text, presetId, language = "auto" } = req.body || {};

    if (!text || typeof text !== "string") {
      throw new AppError("Text is required and must be a string.", 400);
    }

    if (!presetId || typeof presetId !== "string") {
      throw new AppError("presetId is required and must be a string.", 400);
    }

    // 1) Try cache
    const cached = await getRewriteFromCache({ text, presetId, language });
    if (cached) {
      const duration = Date.now() - start;
      return res.json({
        text: cached,
        cached: true,
        duration_ms: duration,
      });
    }

    // 2) Build messages from our god-tier prompt engine
    const messages = buildMessages({ presetId, userText: text, language });
    const params = getPresetParameters(presetId);

    const output = await createChatCompletion({
      messages,
      temperature: params.temperature,
      maxTokens: params.max_tokens,
    });

    // 3) Cache result
    await setRewriteInCache({ text, presetId, language, output });

    const duration = Date.now() - start;
    return res.json({
      text: output,
      cached: false,
      duration_ms: duration,
    });
  } catch (err) {
    return next(err);
  }
}

/**
 * POST /api/rewrite
 * Streaming endpoint (SSE).
 * Body: { text, presetId, language? }
 */
export async function streamRewrite(req, res, next) {
  const start = Date.now();
  try {
    const { text, presetId, language = "auto" } = req.body || {};

    if (!text || typeof text !== "string") {
      throw new AppError("Text is required and must be a string.", 400);
    }

    if (!presetId || typeof presetId !== "string") {
      throw new AppError("presetId is required and must be a string.", 400);
    }

    // SSE headers
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");

    // 1) Cache check
    const cached = await getRewriteFromCache({ text, presetId, language });
    if (cached) {
      const duration = Date.now() - start;
      res.write(
        `data: ${JSON.stringify({ chunk: cached, cached: true })}\n\n`
      );
      res.write(
        `data: ${JSON.stringify({
          type: "done",
          text: cached,
          cached: true,
          duration_ms: duration,
        })}\n\n`
      );
      return res.end();
    }

    // 2) Build prompt messages
    const messages = buildMessages({ presetId, userText: text, language });
    const params = getPresetParameters(presetId);

    let fullText = "";
    const result = await createChatCompletionStream({
      messages,
      temperature: params.temperature,
      maxTokens: params.max_tokens,
      async onChunk(chunk) {
        fullText += chunk;
        res.write(`data: ${JSON.stringify({ chunk })}\n\n`);
      },
    });

    // 3) Cache result
    await setRewriteInCache({ text, presetId, language, output: result });

    const duration = Date.now() - start;
    res.write(
      `data: ${JSON.stringify({
        type: "done",
        text: result,
        cached: false,
        duration_ms: duration,
      })}\n\n`
    );
    res.end();
  } catch (err) {
    // Return error via SSE format
    const duration = Date.now() - start;
    try {
      res.write(
        `data: ${JSON.stringify({
          type: "error",
          error: "Rewrite failed",
          message: err.message,
          duration_ms: duration,
        })}\n\n`
      );
      res.end();
    } catch {
      // if headers already sent and connection dead, nothing we can do
    }
    return next(err);
  }
}

