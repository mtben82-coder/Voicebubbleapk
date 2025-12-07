// backend/cache/rewriteCache.js

import { getCached, setCached, hashContent } from "./cacheClient.js";

const REWRITE_TTL =
  parseInt(process.env.REWRITE_CACHE_TTL, 10) || 60 * 60 * 24 * 7; // 7 days

function buildKey({ text, presetId, language = "auto" }) {
  const hash = hashContent(text);
  return `rewrite:${presetId}:${language}:${hash}`;
}

export async function getRewriteFromCache({ text, presetId, language }) {
  const key = buildKey({ text, presetId, language });
  return await getCached(key);
}

export async function setRewriteInCache({ text, presetId, language, output }) {
  const key = buildKey({ text, presetId, language });
  return await setCached(key, output, REWRITE_TTL);
}

