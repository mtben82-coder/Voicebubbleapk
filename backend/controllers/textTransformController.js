import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// AI Transformation Prompts
const TRANSFORMATION_PROMPTS = {
  rewrite: `You are a professional editor. Rewrite the given text to improve clarity, flow, and readability while maintaining the original meaning and tone. Make it more engaging and polished.

Rules:
- Keep the same length approximately
- Maintain the original tone and style
- Fix any grammar or clarity issues
- Make it more engaging
- Return ONLY the rewritten text, no explanations`,

  expand: `You are a content expansion specialist. Take the given text and expand it with more detail, examples, and context while maintaining the original message and tone.

Rules:
- Add 50-100% more content
- Include relevant details and examples
- Maintain the original tone
- Keep it coherent and well-structured
- Return ONLY the expanded text, no explanations`,

  shorten: `You are a content editor specializing in concise writing. Shorten the given text while preserving all key information and maintaining clarity.

Rules:
- Reduce length by 30-50%
- Keep all essential information
- Maintain clarity and readability
- Preserve the original tone
- Return ONLY the shortened text, no explanations`,

  professional: `You are a business communication expert. Rewrite the given text in a professional, formal tone suitable for business contexts.

Rules:
- Use formal, professional language
- Remove casual expressions
- Maintain clarity and directness
- Keep it respectful and authoritative
- Return ONLY the professional version, no explanations`,

  casual: `You are a friendly communication specialist. Rewrite the given text in a casual, conversational tone that feels natural and approachable.

Rules:
- Use casual, friendly language
- Make it conversational and warm
- Keep it natural and relatable
- Maintain the core message
- Return ONLY the casual version, no explanations`,
};

// Transform text using AI
async function transformText(req, res) {
  try {
    const { text, action, context } = req.body;

    // Validate input
    if (!text || !action) {
      return res.status(400).json({
        success: false,
        error: 'Text and action are required'
      });
    }

    if (!TRANSFORMATION_PROMPTS[action]) {
      return res.status(400).json({
        success: false,
        error: 'Invalid action. Supported actions: rewrite, expand, shorten, professional, casual'
      });
    }

    // Build the prompt
    const systemPrompt = TRANSFORMATION_PROMPTS[action];
    let userPrompt = `Text to transform: "${text}"`;
    
    if (context && context.trim()) {
      userPrompt += `\n\nContext (surrounding text): "${context}"`;
    }

    console.log(`🤖 AI Transform Request: ${action} | Text: "${text.substring(0, 50)}..."`);

    // Call OpenAI
    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: userPrompt }
      ],
      temperature: 0.3,
      max_tokens: 1000,
    });

    const transformedText = completion.choices[0].message.content.trim();

    console.log(`✅ AI Transform Success: ${action} | Result: "${transformedText.substring(0, 50)}..."`);

    res.json({
      success: true,
      originalText: text,
      transformedText: transformedText,
      action: action,
      usage: completion.usage
    });

  } catch (error) {
    console.error('❌ Text transformation error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to transform text',
      details: error.message
    });
  }
}

// Batch transform multiple texts
async function batchTransformText(req, res) {
  try {
    const { texts, action, context } = req.body;

    if (!texts || !Array.isArray(texts) || texts.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Texts array is required'
      });
    }

    if (texts.length > 10) {
      return res.status(400).json({
        success: false,
        error: 'Maximum 10 texts per batch request'
      });
    }

    console.log(`🤖 Batch AI Transform Request: ${action} | ${texts.length} texts`);

    const results = [];
    
    for (const text of texts) {
      try {
        const systemPrompt = TRANSFORMATION_PROMPTS[action];
        let userPrompt = `Text to transform: "${text}"`;
        
        if (context && context.trim()) {
          userPrompt += `\n\nContext: "${context}"`;
        }

        const completion = await openai.chat.completions.create({
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: systemPrompt },
            { role: "user", content: userPrompt }
          ],
          temperature: 0.3,
          max_tokens: 1000,
        });

        results.push({
          originalText: text,
          transformedText: completion.choices[0].message.content.trim(),
          success: true
        });

      } catch (error) {
        results.push({
          originalText: text,
          transformedText: null,
          success: false,
          error: error.message
        });
      }
    }

    console.log(`✅ Batch AI Transform Complete: ${results.filter(r => r.success).length}/${results.length} successful`);

    res.json({
      success: true,
      action: action,
      results: results
    });

  } catch (error) {
    console.error('❌ Batch text transformation error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to batch transform texts',
      details: error.message
    });
  }
}

// Get available transformation actions
function getTransformationActions(req, res) {
  const actions = Object.keys(TRANSFORMATION_PROMPTS).map(action => ({
    id: action,
    name: action.charAt(0).toUpperCase() + action.slice(1),
    description: getActionDescription(action)
  }));

  res.json({
    success: true,
    actions: actions
  });
}

function getActionDescription(action) {
  const descriptions = {
    rewrite: 'Improve clarity, flow, and readability',
    expand: 'Add more detail and context',
    shorten: 'Make it concise while keeping key info',
    professional: 'Convert to formal, business tone',
    casual: 'Make it friendly and conversational'
  };
  
  return descriptions[action] || 'Transform text';
}

export {
  transformText,
  batchTransformText,
  getTransformationActions
};