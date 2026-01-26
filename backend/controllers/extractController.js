// backend/controllers/extractController.js

import { AppError } from "../utils/errors.js";
import { createChatCompletion } from "../services/openaiService.js";

/**
 * POST /api/extract/outcomes
 * Body: { text, language? }
 * Returns: { outcomes: [{type, text},...] }
 */
export async function extractOutcomes(req, res, next) {
  const start = Date.now();
  try {
    const { text, language = "auto" } = req.body || {};

    if (!text || typeof text !== "string") {
      throw new AppError("Text is required and must be a string.", 400);
    }

    // Build extraction prompt
    const systemPrompt = `You are a clarity-focused AI that extracts actionable outcomes from speech.

MISSION: Extract atomic, independently actionable outcomes ONLY.

OUTCOME TYPES (choose ONE per item):
- message: Something to communicate/send
- task: Action to complete
- idea: Concept/insight to develop
- content: Post/article/creative output
- note: Information to remember

RULES:
1. Each outcome = SHORT (1-2 sentences max)
2. Each outcome = INDEPENDENTLY ACTIONABLE
3. NO long-form writing
4. NO fluff or filler
5. Extract 2-10 outcomes (quality > quantity)

OUTPUT FORMAT (JSON only):
{
  "outcomes": [
    {"type": "task", "text": "Email John about budget"},
    {"type": "idea", "text": "Feature: Auto-save drafts"}
  ]
}
${language && language !== "auto" ? `\n\nLANGUAGE: Respond in "${language}" language.` : ""}`;

    const messages = [
      { role: "system", content: systemPrompt },
      { role: "user", content: text }
    ];

    const output = await createChatCompletion({
      messages,
      temperature: 0.4,
      maxTokens: 600,
    });

    // Parse JSON response
    let parsed;
    try {
      // Try to extract JSON from response (in case AI adds extra text)
      const jsonMatch = output.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        parsed = JSON.parse(jsonMatch[0]);
      } else {
        parsed = JSON.parse(output);
      }
    } catch (parseError) {
      throw new AppError("Failed to parse AI response as JSON", 500);
    }

    if (!parsed.outcomes || !Array.isArray(parsed.outcomes)) {
      throw new AppError("Invalid outcomes format from AI", 500);
    }

    const duration = Date.now() - start;
    return res.json({
      outcomes: parsed.outcomes,
      duration_ms: duration,
    });
  } catch (err) {
    return next(err);
  }
}

/**
 * POST /api/extract/unstuck
 * Body: { text, language? }
 * Returns: { insight, action }
 */
export async function extractUnstuck(req, res, next) {
  const start = Date.now();
  try {
    const { text, language = "auto" } = req.body || {};

    if (!text || typeof text !== "string") {
      throw new AppError("Text is required and must be a string.", 400);
    }

    // Build unstuck prompt
    const systemPrompt = `You are a calm, insightful AI that helps people get unstuck.

MISSION: Extract ONE insight + ONE small action.

RULES:
1. Insight = What's actually going on (1-2 sentences, gentle, clear)
2. Action = One TINY doable step (specific, not overwhelming)
3. NO therapy speak
4. NO generic advice
5. NO multiple actions
6. Tone = Calm, supportive, practical

OUTPUT FORMAT (JSON only):
{
  "insight": "You're feeling overwhelmed because you're trying to do everything at once.",
  "action": "Write down just 3 things that matter most today."
}
${language && language !== "auto" ? `\n\nLANGUAGE: Respond in "${language}" language.` : ""}`;

    const messages = [
      { role: "system", content: systemPrompt },
      { role: "user", content: text }
    ];

    const output = await createChatCompletion({
      messages,
      temperature: 0.5,
      maxTokens: 400,
    });

    // Parse JSON response
    let parsed;
    try {
      const jsonMatch = output.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        parsed = JSON.parse(jsonMatch[0]);
      } else {
        parsed = JSON.parse(output);
      }
    } catch (parseError) {
      throw new AppError("Failed to parse AI response as JSON", 500);
    }

    if (!parsed.insight || !parsed.action) {
      throw new AppError("Invalid unstuck format from AI", 500);
    }

    const duration = Date.now() - start;
    return res.json({
      insight: parsed.insight,
      action: parsed.action,
      duration_ms: duration,
    });
  } catch (err) {
    return next(err);
  }
}
