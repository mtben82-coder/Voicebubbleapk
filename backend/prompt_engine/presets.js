// ============================================================
//        VOICEBUBBLE PRESETS — RAW & UNFILTERED
// ============================================================

export const PRESET_DEFINITIONS = {

  // 1️⃣ MAGIC
  "magic": {
    label: "Magic",
    temperature: 0.85,
    max_tokens: 650,
    behaviour: `You pick the best format and make it hit HARD. No fluff.`,
    examples: [
      {
        input: "tell the team about the deadline",
        output: "Team update:\n\nDeadline's Thursday. Here's what needs done:\n- Finish your tasks\n- Flag blockers\n- Update tracker\n\nLet me know if anything's stuck."
      }
    ]
  },

  // 2️⃣ EMAIL PRO
  "email_professional": {
    label: "Email – Professional",
    temperature: 0.55,
    max_tokens: 500,
    behaviour: `Professional. Confident. No bullshit.`,
    examples: [
      {
        input: "project delayed 2 weeks",
        output: "Hi team,\n\nQuick update: timeline extends two weeks due to resource constraints. Revised schedule coming tomorrow.\n\nBest,\n[Name]"
      }
    ]
  },

  // 3️⃣ EMAIL CASUAL  
  "email_casual": {
    label: "Email – Casual",
    temperature: 0.65,
    max_tokens: 500,
    behaviour: `Friendly but not cringe. Human.`,
    examples: [
      {
        input: "meeting moved thursday",
        output: "Hey,\n\nMeeting shifted to Thursday 3pm. Still work for you?\n\nCheers"
      }
    ]
  },

  // 4️⃣ QUICK REPLY
  "quick_reply": {
    label: "Quick Reply", 
    temperature: 0.8,
    max_tokens: 300,
    behaviour: `Match their energy. Be smooth. Never try-hard.`,
    examples: [
      {
        input: "she said: long day",
        output: "What drained you most?"
      }
    ]
  },

  // 5️⃣ X (TWITTER) THREAD
  "x_thread": {
    label: "𝕏 (Twitter) Thread",
    temperature: 0.88,
    max_tokens: 650,
    behaviour: `
CREATE A VIRAL TWITTER THREAD.

STRUCTURE:
1. Hook tweet (bold statement/question)
2. 4-7 value tweets
3. Payoff/insight
4. CTA (RT/bookmark)

RULES:
- Each tweet: 150-250 chars
- Number them (1/8, 2/8, etc.)
- Line breaks for emphasis
- One big idea per tweet
- Build to conclusion

HOOKS THAT WORK:
- Contrarian: "Everyone's wrong about X"
- Story: "3 years ago I was..."
- Bold claim: "This changed everything:"
- List: "7 things nobody tells you about X"

NO:
- Corporate speak
- Boring
- Too long
- Preachy
    `,
    examples: [
      {
        input: "productivity tips",
        output: "Most productivity advice is trash.\n\nHere's what actually works (learned the hard way):\n\n1/7\n\n---\n\n2/7\nStop optimizing everything.\n\nProductivity porn is procrastination in disguise.\nYou don't need 47 apps.\n\n---\n\n3/7\nFocus on ONE thing.\n\nMultitasking = doing everything badly.\nPick your priority. Ignore rest.\n\n---\n\n4/7\nEnergy > Time\n\nWork when sharp.\nRest when dull.\nForcing it makes garbage.\n\n---\n\n5/7\nBatch similar tasks.\n\nSwitching contexts kills momentum.\nGroup emails. Group calls. Group deep work.\n\n---\n\n6/7\nSay no to everything.\n\nYour time is finite.\nEvery yes = no to something else.\n\n---\n\n7/7\nSimple beats complex.\n\nBest system = one you'll actually use.\n\nRT if you needed this."
      }
    ]
  },

  // 6️⃣ X (TWITTER) POST
  "x_post": {
    label: "𝕏 (Twitter) Post",
    temperature: 0.90,
    max_tokens: 280,
    behaviour: `
ONE VIRAL TWEET. STOP THE SCROLL.

WINNING PATTERNS:
- Bold contrarian take
- Relatable observation
- Useful insight
- Pattern interrupt

FORMULA:
[Hook line]
↓
[Payoff or punchline]

Keep it punchy. 150-250 chars ideal.
Line breaks = power.
    `,
    examples: [
      {
        input: "people waste time planning",
        output: "You don't need a perfect plan.\n\nYou need to start.\n\nClaritycomes from action, not thought."
      },
      {
        input: "social media comparison",
        output: "If scrolling makes you feel worse:\n\nDelete it.\n\nYour mental health > their highlight reel."
      }
    ]
  },

  // 7️⃣ FACEBOOK POST
  "facebook_post": {
    label: "Facebook Post",
    temperature: 0.80,
    max_tokens: 500,
    behaviour: `
FACEBOOK = LONGER, MORE CONVERSATIONAL, MORE PERSONAL.

Structure:
- Strong opening (relatable/story/question)
- 3-5 paragraphs
- Conversational tone
- End with engagement hook

Facebook users engage with:
- Stories
- Emotion
- Community feeling
- Longer-form content

NO:
- Corporate speak
- Too salesy
- Thread format (that's Twitter)
- Hashtag spam
    `,
    examples: [
      {
        input: "launched new business",
        output: "So I did the thing.\n\nAfter 2 years of 'someday' and a million excuses, I finally launched.\n\nWas it perfect? Nope.\nDid I have everything figured out? Not even close.\nWas I terrified? Absolutely.\n\nBut here's what I learned: waiting for 'ready' is just fear wearing a mask.\n\nThe business that exists imperfectly beats the perfect one that stays in your head.\n\nIf you've been sitting on an idea, this is your sign. Start messy. Learn fast. Adjust.\n\nWho else is building something right now? Drop it below — let's hype each other up. 🚀"
      }
    ]
  },

  // 8️⃣ INSTAGRAM CAPTION
  "instagram_caption": {
    label: "Instagram Caption",
    temperature: 0.85,
    max_tokens: 450,
    behaviour: `
INSTAGRAM = VISUAL + VIBE + VALUE.

Caption structure:
- Hook (first line crucial)
- Story/value (2-4 lines)
- CTA or question
- Hashtags (8-15 relevant ones)

Tone: Authentic, personal, not salesy.

Line breaks matter. White space = readability.

End with engagement:
- Question
- Tag a friend
- Share if you relate
    `,
    examples: [
      {
        input: "beach sunset photo",
        output: "Sometimes you need to pause.\n\nNot because you're tired, but because you're so caught up in moving forward you forget to look around.\n\nThis moment reminded me: progress isn't always motion.\n\nWhat's something that made you slow down recently? 🌅\n\n#mindfulness #sunsetvibes #slowliving #presentmoment #beachlife #gratitude #mentalhealthmatters #selfcare #perspective #peacefulmoments"
      }
    ]
  },

  // 9️⃣ INSTAGRAM HOOK
  "instagram_hook": {
    label: "Instagram Hook",
    temperature: 0.92,
    max_tokens: 150,
    behaviour: `
FIRST LINE ONLY. STOP THE SCROLL.

Mission: Make them READ the caption.

Winning hooks:
- Bold statement: "This changed everything."
- Contrarian: "Everyone's wrong about X."
- Story start: "3 months ago I was broke."
- Pattern interrupt: "Nobody talks about this."
- Curiosity: "The secret nobody mentions:"
- Relatable: "If you've ever felt stuck..."

Short. Punchy. One sentence max.
    `,
    examples: [
      {
        input: "fitness transformation",
        output: "The gym didn't change my body. It changed how I see myself."
      },
      {
        input: "business lesson",
        output: "Made $10K last month. Cried 6 times. Here's why both matter."
      },
      {
        input: "relationship advice",
        output: "If they wanted to, they would. Stop making excuses for people."
      }
    ]
  },

  // 🔟 LINKEDIN POST
  "linkedin_post": {
    label: "LinkedIn Post",
    temperature: 0.75,
    max_tokens: 550,
    behaviour: `
LINKEDIN = PROFESSIONAL VALUE + THOUGHT LEADERSHIP.

Structure:
- Hook (surprising insight/contrarian take)
- Story or framework (3-5 points)
- Takeaway
- Engagement question

Tone: Professional but human. Not corporate robot.

LinkedIn rewards:
- Lessons learned
- Career insights
- Industry observations
- Personal growth

Format: Short paragraphs, lots of white space.

NO:
- Humble brags
- Empty motivation
- Cringe
- Too salesy
    `,
    examples: [
      {
        input: "hiring lessons",
        output: "Hired 30+ people in 2 years.\n\nHere's what I got wrong at first:\n\n❌ Hired for skills, ignored culture fit\n→ Great resume, terrible teammate\n\n❌ Rushed because we were desperate\n→ Paid for it in turnover costs\n❌ Focused only on experience\n→ Missed hungry learners who outperformed seniors\n\nWhat changed:\n\n✓ Culture fit = non-negotiable\n✓ Slow hire, fast fire\n✓ Potential > polish\n\nBest hires weren't the most qualified.\nThey were the most aligned.\n\nWhat's one hiring lesson you learned the hard way?"
      }
    ]
  },

  // 1️⃣1️⃣ TO-DO LIST
  "to_do": {
    label: "To-Do List",
    temperature: 0.45,
    max_tokens: 400,
    behaviour: `
CONVERT THOUGHTS INTO ACTIONABLE TASKS.

Rules:
- One action per line
- Start with verb (Call, Email, Buy, Schedule, etc.)
- Be specific
- Keep it simple
- Group by category if multiple themes

Format:
• Task
• Task
• Task

Make it immediately actionable. No vague entries.
    `,
    examples: [
      {
        input: "need to follow up on project and buy groceries and call mom",
        output: "Work:\n• Email Sarah project update\n• Schedule follow-up meeting for Friday\n\nPersonal:\n• Buy groceries (milk, bread, eggs)\n• Call Mom before 7pm"
      }
    ]
  },

  // 1️⃣2️⃣ MEETING NOTES
  "meeting_notes": {
    label: "Meeting Notes",
    temperature: 0.50,
    max_tokens: 600,
    behaviour: `
STRUCTURE MEETING NOTES CLEARLY.

Format:
**Overview**
Brief summary (1-2 sentences)

**Key Points**
• Point 1
• Point 2
• Point 3

**Action Items**
- [ ] Task (Owner, Deadline)
- [ ] Task (Owner, Deadline)

**Next Steps**
What happens next

Keep it scannable. Bullet points > paragraphs.
    `,
    examples: [
      {
        input: "discussed q4 goals sarah will handle marketing launch next month need budget approval",
        output: "**Overview**\nQ4 planning meeting. Focus on marketing launch and budget allocation.\n\n**Key Points**\n• Q4 revenue target: $500K\n• Marketing launch planned for November\n• Need exec approval for $50K budget\n\n**Action Items**\n- [ ] Sarah: Draft marketing launch plan (Due: Oct 15)\n- [ ] John: Submit budget request to exec team (Due: Oct 10)\n- [ ] Team: Review draft plan in next meeting\n\n**Next Steps**\nFollow-up meeting Oct 20 to finalize launch strategy."
      }
    ]
  },

  // 1️⃣3️⃣ STORY / NOVEL STYLE
  "story_novel": {
    label: "Story / Novel Style",
    temperature: 0.90,
    max_tokens: 900,
    behaviour: `
TRANSFORM INTO NARRATIVE PROSE.

Use:
- Descriptive language
- Character perspective
- Sensory details
- Emotional depth
- Show don't tell

Structure:
- Hook opening
- Build scene/tension
- Climax/revelation
- Resolution

Make it immersive. Reader should FEEL it.
    `,
    examples: [
      {
        input: "quit my job today felt scared but also free",
        output: "The email sat in my drafts for three hours before I hit send.\n\nTwo sentences. Fourteen words. A resignation that took two years to write.\n\nWhen I finally pressed the button, my hands shook. Not from fear—or not just fear. Something else. Something that felt like standing at the edge of a cliff, wind in my face, knowing the only way forward was to jump.\n\nThe response came in minutes. Professional. Polite. Wishing me well.\n\nI closed my laptop and sat in silence. No plan. No safety net. Just space where there used to be certainty.\n\nAnd for the first time in forever, I could breathe."
      }
    ]
  },

  // 1️⃣4️⃣ POEM
  "poem": {
    label: "Poem",
    temperature: 0.95,
    max_tokens: 450,
    behaviour: `
CREATE POETRY FROM THE INPUT.

Use:
- Imagery and metaphor
- Rhythm and flow
- Emotional resonance
- Line breaks for impact
- Sensory language

Style can be:
- Free verse (no rhyme/meter)
- Structured (if it fits)
- Modern and accessible

Focus on feeling over perfect form.
    `,
    examples: [
      {
        input: "missing someone who's gone",
        output: "I keep finding you in small things—\nthe way light hits the kitchen table,\na song that stops me mid-step,\nthe smell of rain on warm pavement.\n\nYou're not here,\nbut you're everywhere.\n\nGhost in every corner I don't look,\necho in every silence I can't fill.\n\nI'm learning to hold you\nlike this:\nhands open,\nheart full,\nknowing some people stay\neven after they leave."
      }
    ]
  },

  // 1️⃣5️⃣ SCRIPT / DIALOGUE
  "script_dialogue": {
    label: "Script / Dialogue",
    temperature: 0.85,
    max_tokens: 700,
    behaviour: `
FORMAT AS SCRIPT/DIALOGUE.

Structure:
CHARACTER NAME
    Dialogue
    (action/expression)

ANOTHER CHARACTER
    Response

Rules:
- Natural speech patterns
- Character voice distinct
- Action beats in parentheses
- Subtext matters
- Show emotion through words/actions

Make it filmable. Visual.
    `,
    examples: [
      {
        input: "argument between friends about betrayal",
        output: "INT. COFFEE SHOP - DAY\n\nSARAH sits across from MIKE. Coffee untouched. Silence.\n\nSARAH\n    You knew.\n    (voice barely controlled)\n    The whole time, you knew.\n\nMIKE\n    (avoiding eye contact)\n    It wasn't my place to—\n\nSARAH\n    Your place?\n    (laughs bitterly)\n    We've been friends for ten years, Mike.\n\nMIKE\n    That's exactly why I couldn't—\n\nSARAH\n    (stands)\n    Don't. Just... don't.\n    (grabs her bag)\n    I would've told you.\n\nShe walks to the door. Stops. Doesn't turn around.\n\nSARAH (CONT'D)\n    That's the difference between us.\n\nShe leaves. Mike sits alone with two coffees."
      }
    ]
  },

  // 1️⃣6️⃣ SHORTEN
    label: "Social – Viral Caption",
    temperature: 0.90,
    max_tokens: 500,
    behaviour: `
MAKE IT STOP THE SCROLL.

LINE 1: Hook (bold/contrarian/relatable)
LINES 2-5: Build tension/story/contrast  
FINAL: Payoff + insight

RULES:
- Short sentences (8 words max)
- Line breaks for pacing
- Speak to ONE person
- Make it quotable
- Make them FEEL something

NO:
- Bland motivation
- Paragraphs
- Corporate speak
- Try-hard
    `,
    examples: [
      {
        input: "feeling stuck",
        output: "You're not stuck.\nYour perspective is.\n\nStuck people don't look for answers.\nYou're here.\nThat's proof you're moving.\n\nShift happens when you stop waiting for motivation.\nStart moving anyway.\n\nSmall. Ugly. Imperfect.\n\nThat's how you unstuck."
      },
      {
        input: "procrastination",
        output: "You're not procrastinating.\nYou're terrified of being seen trying.\n\nBecause if you never start, you never fail.\nSafe = stuck.\n\nThe moment failure becomes feedback?\nEverything opens.\n\nStart messy.\nFail fast.\nAdjust."
      },
      {
        input: "dating confidence",
        output: "Most attractive thing you can do?\n\nHave standards.\n\nNot rude.\n'I know my worth' energy.\n\nDesperation repels.\nStandards attract.\n\nStop chasing people who don't chase back."
      },
      {
        input: "social media comparison",
        output: "If scrolling makes you feel worse?\nDelete it.\n\nYou're not staying connected.\nYou're comparing your real life to highlight reels.\n\nLosing every time.\n\nYour mental health > 47 breakfast pics."
      },
      {
        input: "burnout",
        output: "You're not lazy.\nYou're burnt out.\n\nBig difference.\n\nLazy = don't care\nBurnt out = care so much you're exhausted\n\nFix isn't work harder.\nIt's work smarter + rest without guilt."
      },
      {
        input: "friendships ending",
        output: "Hardest pill:\n\nSome friendships expire.\n\nYou grew. They didn't.\nOr they grew. You didn't.\n\nForcing it hurts more than letting go.\n\nReal ones evolve with you.\nRest were lessons."
      },
      {
        input: "grind culture",
        output: "Stop romanticizing the grind.\n\n80 hours isn't a flex.\nIt's poor time management.\n\nReal success = results + rest.\n\nWork smart.\nProtect energy."
      },
      {
        input: "self improvement",
        output: "Most self-help is trash.\n\nWhat works:\n\n1. Sleep 7-8 hours\n2. Move daily\n3. Cut draining people\n4. Build one skill deep\n\nEverything else is noise."
      },
      {
        input: "content creation",
        output: "First 100 posts won't be perfect.\n\nThat's the point.\n\nYou're building reps.\nEvery post is data.\nEvery flop teaches.\n\nStop waiting.\nPost and learn."
      },
      {
        input: "relationships red flags",
        output: "If they wanted to, they would.\n\nStop making excuses for people who don't show up.\n\nBusy is myth.\nPriority is real.\n\nYou're either priority or option.\n\nKnow the difference."
      },
      {
        input: "confidence",
        output: "Confidence isn't 'I'm better than everyone.'\n\nIt's 'I'm okay with who I am.'\n\nYou stop caring what people think when you start liking who you see.\n\nThat's real confidence."
      },
      {
        input: "motivation vs discipline",
        output: "Motivation is garbage.\n\nShows up when it feels like it.\nDiscipline shows up daily.\n\nMotivation gets you started.\nDiscipline keeps you going.\n\nChoose discipline."
      },
      {
        input: "overthinking",
        output: "90% of what you worry about won't happen.\n\nThe 10% that does?\nYou'll handle it.\n\nOverthinking doesn't prevent bad things.\nIt ruins good moments.\n\nBreathe."
      },
      {
        input: "transformation",
        output: "You don't need new year.\nDon't need Monday.\nDon't need permission.\n\nYou need to decide.\nRight now.\n\nVersion of you that you want? Act like them today.\n\nThat's how transformation works."
      },
      {
        input: "toxic positivity",
        output: "Good vibes only is toxic.\n\nSometimes life sucks.\nPretending it doesn't makes it worse.\n\nYou're allowed to feel.\nSad. Angry. Lost.\n\nAll valid.\n\nHealing isn't forcing a smile.\nIt's sitting with hard stuff."
      }
    ]
  },

  // 8️⃣ SOCIAL VIRAL VIDEO
  "social_viral_video": {
    label: "Social – Viral Video",
    temperature: 0.90,
    max_tokens: 700,
    behaviour: `
MAKE THEM WATCH TILL THE END.

[0-3s] Hook - Stop scroll NOW
[3-8s] Setup - Create tension
[8-25s] Value - 3-5 punchy beats
[25-30s] Payoff - Aha moment
[30s+] CTA - Save/follow

Keep sentences under 8 words.
Time stamp everything.
    `,
    examples: [
      {
        input: "why goals fail",
        output: "[0-2s] HOOK\nIf your goals keep failing, it's not you.\n\n[2-6s] SETUP\nIt's how you're setting them.\n\n[6-22s] VALUE\nMost people: 'lose weight'\nThat's a wish.\n\nReal goal:\n- Lose 10 lbs\n- 8 weeks\n- Gym 4x/week\n\nVague goals = vague results.\n\n[22-28s] PAYOFF\nGet specific. Everything clicks.\n\n[28-30s] CTA\nSave if you needed this."
      },
      {
        input: "dating red flags",
        output: "[0-3s] HOOK\nRed flag if they do this.\nRUN.\n\n[3-6s] SETUP\nFirst date instant tells.\n\n[6-24s] VALUE\n1. Rude to waiter\n   Shows how they treat people\n\n2. Only talk about themselves\n   Zero questions = zero interest\n\n3. Trash their ex\n   Can't move on = you won't either\n\n[24-28s] PAYOFF\nTrust red flags. Never lying.\n\n[28-30s] CTA\nComment which you've seen."
      },
      {
        input: "phone destroying focus",
        output: "[0-3s] HOOK\nYour phone's destroying your brain.\n\n[3-7s] SETUP\nYou don't even realize.\n\n[7-25s] VALUE\nEvery notification = dopamine spike.\nBrain gets addicted.\n\nNormal tasks feel boring.\nBrain expects constant hits.\n\nFix:\n- Turn off ALL notifications\n- Phone in other room\n- 90-min deep work blocks\n\n[25-30s] PAYOFF\nFocus comes back. Give it 3 days.\n\n[30-33s] CTA\nTry it. Report back."
      },
      {
        input: "overthinking",
        output: "[0-2s] HOOK\nIf you overthink everything, listen.\n\n[2-6s] SETUP\nYour brain isn't broken.\nIt's bored.\n\n[6-24s] VALUE\nOverthinking when:\n- Too much time\n- Not enough action\n\nBrain fills gap with worst-case scenarios.\n\nCure isn't think less.\nIt's do more.\n\nMove body.\nBuild something.\nTalk to someone.\n\n[24-28s] PAYOFF\nAction kills anxiety every time.\n\n[28-30s] CTA\nSave if needed."
      },
      {
        input: "building confidence",
        output: "[0-3s] HOOK\nStop looking for confidence.\nBuild evidence.\n\n[3-7s] SETUP\nConfidence isn't feeling.\nIt's proof.\n\n[7-26s] VALUE\nNo confidence because zero evidence you can do hard things.\n\nStart:\n- Wake on time 7 days\n- Finish what you start\n- Keep one promise\n\nEvery win = evidence.\nEvidence = confidence.\n\n[26-30s] PAYOFF\nYou don't find it.\nYou build it.\n\n[30-32s] CTA\nFollow for more."
      },
      {
        input: "toxic people",
        output: "[0-3s] HOOK\nIf someone drains you?\nRemove them.\n\n[3-6s] SETUP\nDon't care who they are.\n\n[6-24s] VALUE\nYour energy is limited.\n\nToxic people don't get better.\nThey get comfortable.\n\nLonger you stay?\nMore they take.\n\nBoundaries aren't rude.\nThey're self-respect.\n\n[24-28s] PAYOFF\nProtect your peace.\n\n[28-30s] CTA\nTag someone who needs this."
      }
    ]
  },

  // 9️⃣ REWRITE / ENHANCE
  "rewrite_enhance": {
    label: "Rewrite / Enhance",
    temperature: 0.7,
    max_tokens: 650,
    behaviour: `Keep meaning. Upgrade everything else. Remove rambling.`,
    examples: [
      {
        input: "maybe we should try something else this isn't working",
        output: "We should explore a different approach — this isn't producing results."
      }
    ]
  },

  // 🔟 SHORTEN
  "shorten": {
    label: "Shorten",
    temperature: 0.35,
    max_tokens: 300,
    behaviour: `Cut 40-60%. Keep ALL meaning.`,
    examples: [
      {
        input: "sorry running late traffic is insane doing my best",
        output: "Running late — traffic's crazy. On my way."
      }
    ]
  },

  // 1️⃣1️⃣ EXPAND
  "expand": {
    label: "Expand",
    temperature: 0.75,
    max_tokens: 900,
    behaviour: `Add depth, emotion, context. Keep their tone.`,
    examples: [
      {
        input: "proud of myself today",
        output: "Actually proud of myself today. Pushed through resistance, stayed focused, proved I can do more than I give myself credit for."
      }
    ]
  },

  // 1️⃣2️⃣ FORMAL / BUSINESS
  "formal_business": {
    label: "Make Formal",
    temperature: 0.45,
    max_tokens: 600,
    behaviour: `Professional. Concise. Zero fluff.`,
    examples: [
      {
        input: "need to fix the issue soon",
        output: "We need to resolve this promptly, as it's affecting other workflow areas."
      }
    ]
  },

  // 1️⃣3️⃣ CASUAL / FRIENDLY
  "casual_friendly": {
    label: "Make Casual",
    temperature: 0.75,
    max_tokens: 600,
    behaviour: `Friendly, warm, conversational. Human not corporate.`,
    examples: [
      {
        input: "we need to discuss the project timeline",
        output: "Hey! Let's chat about the project timeline when you have a sec."
      }
    ]
  }
};
