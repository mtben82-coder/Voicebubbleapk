// ============================================================
//        ELITE INTERVIEWS PART 2
// ============================================================
//
// More guided interview flows for high-stakes templates
//
// ============================================================

import 'elite_interview_system.dart';

// ============================================================
// ⚖️ INSURANCE APPEAL INTERVIEW
// ============================================================

const insuranceAppealInterview = [
  InterviewQuestion(
    id: 'appeal_denial',
    question: "Let's start with the basics. What claim was denied? What's the claim number, date of service, and what exactly did they deny?",
    whyItMatters: "The appeal letter needs to reference the exact claim. Insurance companies use any error as an excuse to deny again.",
    exampleAnswer: "Claim number 892347, date of service January 15th. They denied my MRI for my lower back. The denial code was 'not medically necessary.' I've been dealing with severe back pain for 6 months.",
    proTips: [
      "Have the denial letter in front of you",
      "Note the exact denial reason - we'll address it directly",
      "Get the claim number and date exactly right",
    ],
    minSeconds: 20,
    idealSeconds: 45,
    requiresSpecifics: true,
  ),

  InterviewQuestion(
    id: 'appeal_medical',
    question: "Tell me about your medical situation. What are your symptoms? How long has this been going on? How does it affect your daily life?",
    whyItMatters: "We need to establish medical necessity. The more specific you are about how this impacts your life, the stronger the case.",
    exampleAnswer: "I've had lower back pain for 6 months, rating it 7 out of 10 most days. It radiates down my left leg. I can't sit at my desk for more than 30 minutes. I've had to stop running, which I did 4 times a week. Some days I can barely get out of bed. It's affecting my job performance.",
    pushForMore: "How specifically does this affect your daily activities? Work? Sleep? Family?",
    proTips: [
      "Be specific about pain level (use 1-10 scale)",
      "Describe functional limitations - what can't you do?",
      "Duration matters - longer = more serious",
      "Impact on work strengthens the case",
    ],
    commonMistakes: [
      "Being vague: 'It hurts' vs 'I can't sit for more than 30 minutes'",
      "Not mentioning daily life impact",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresSpecifics: true,
    keywords: ['pain', 'can\'t', 'unable', 'months', 'weeks', 'daily', 'work', 'sleep'],
  ),

  InterviewQuestion(
    id: 'appeal_tried',
    question: "What treatments have you already tried? Physical therapy, medications, other interventions?",
    whyItMatters: "Insurance companies want to see you've tried conservative treatments first. This proves the MRI/procedure is the next logical step.",
    exampleAnswer: "I did 8 weeks of physical therapy, 3 times a week - didn't help. I've been on ibuprofen 800mg daily, tried Flexeril muscle relaxant, neither gave relief. I also tried a chiropractor for 6 sessions. My doctor says we've exhausted conservative treatment.",
    pushForMore: "How long did you try each treatment? Were there any side effects?",
    proTips: [
      "List EVERYTHING you've tried",
      "Include duration of each treatment",
      "Document why each one didn't work",
      "This shows you're not jumping to expensive procedures",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['tried', 'weeks', 'physical therapy', 'medication', 'didn\'t work', 'no relief'],
  ),

  InterviewQuestion(
    id: 'appeal_doctor',
    question: "What does your doctor say? Why do they believe this test or procedure is necessary?",
    whyItMatters: "Doctor's medical opinion is the strongest evidence. Insurance companies can deny your opinion, but they have to address the doctor's.",
    exampleAnswer: "Dr. Smith, my orthopedic specialist, says the MRI is essential to rule out a herniated disc or spinal stenosis. The symptoms are consistent with nerve compression. Without the MRI, he can't create a proper treatment plan. He said we're flying blind. He's willing to do a peer-to-peer review if needed.",
    pushForMore: "Did your doctor write a letter of medical necessity? Will they do a peer-to-peer call?",
    proTips: [
      "Quote your doctor if possible",
      "Mention their specialty - specialists carry more weight",
      "Note if they'll do a peer-to-peer review (insurance has to accept this)",
      "Ask your doctor for a Letter of Medical Necessity if they haven't provided one",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['doctor', 'says', 'necessary', 'essential', 'believes', 'diagnosis', 'treatment plan'],
  ),

  InterviewQuestion(
    id: 'appeal_request',
    question: "To be crystal clear - what are you asking for? Full coverage? Reconsideration? Expedited review?",
    whyItMatters: "The appeal needs a specific ask. Vague requests get ignored.",
    exampleAnswer: "I'm requesting immediate reversal of the denial and full coverage of the MRI. I'm also requesting an expedited review because my condition is worsening and I'm at risk of permanent nerve damage according to my doctor.",
    proTips: [
      "Be specific and assertive",
      "Request expedited review if condition is worsening",
      "Mention you'll escalate to state insurance commissioner if needed",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

// ============================================================
// 📝 EULOGY INTERVIEW - Sensitive, thoughtful questions
// ============================================================

const eulogyInterview = [
  InterviewQuestion(
    id: 'eulogy_who',
    question: "Take a breath. Tell me who we're honoring today. Their name, who they were to you, and how long you knew them.",
    whyItMatters: "This grounds everything. The eulogy needs to establish your relationship and your right to speak.",
    exampleAnswer: "My grandmother, Rose, who was 92. I knew her my entire life - 35 years. She lived next door to us growing up. She was more than a grandmother, she was my second parent.",
    proTips: [
      "Take your time with this",
      "It's okay to get emotional",
      "There's no wrong answer here",
    ],
    minSeconds: 20,
    idealSeconds: 45,
  ),

  InterviewQuestion(
    id: 'eulogy_essence',
    question: "If someone who never met them asked you to describe them - not what they did for work or their resume, but who they WERE as a person - what would you say?",
    whyItMatters: "This captures their essence. People want to remember who someone really was, not just facts about them.",
    exampleAnswer: "Grandma Rose was the toughest woman I ever knew, but in a quiet way. She survived the war, raised 5 kids mostly alone, never complained about anything. She had this way of making everyone feel special - like you were the only person in the room. And she always had cookies in the jar. Always. Even when money was tight. She said 'a home without cookies isn't a home.'",
    pushForMore: "What would surprise someone who only met them briefly?",
    proTips: [
      "Focus on character traits, not accomplishments",
      "Quirks and habits make them real",
      "What did they say that you'll never forget?",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresSpecifics: true,
    keywords: ['was', 'always', 'never', 'would', 'way of', 'remember'],
  ),

  InterviewQuestion(
    id: 'eulogy_story',
    question: "Tell me a story about them. A moment that captures who they really were. It can be funny, touching, or both.",
    whyItMatters: "Stories are how we remember people. A good eulogy has at least one story that makes people laugh and cry.",
    exampleAnswer: "When grandma was 85, a guy broke into her house. She was in the kitchen making tea. She grabbed her frying pan, chased him through the living room, caught him at the front door, and made him apologize. Then - and this is the part that's so HER - she made him sit down and tell her why he was stealing. He was desperate, needed money. She gave him \$50, made him a sandwich, and told him to come back anytime but through the front door. He actually did come back, years later, to tell her he'd turned his life around.",
    pushForMore: "Do you have another story? Maybe something more everyday?",
    proTips: [
      "Pick a story that reveals their character",
      "Details matter - what did they say?",
      "It's okay if the story is small - small stories can be powerful",
    ],
    minSeconds: 60,
    idealSeconds: 120,
    requiresSpecifics: true,
    keywords: ['remember when', 'one time', 'she/he said', 'she/he would', 'story'],
  ),

  InterviewQuestion(
    id: 'eulogy_taught',
    question: "What did they teach you? Not in a classroom way - what life lesson did you learn from them that you'll carry forever?",
    whyItMatters: "Legacy is about what lives on. This connects their life to the future.",
    exampleAnswer: "She taught me that strength isn't about being loud or tough. It's about showing up every single day, even when it's hard. She never complained. Not once. Even in the hospital at the end, she was asking the nurses about their kids. She taught me that how you treat people - especially people who can't do anything for you - that's who you really are.",
    pushForMore: "Can you give me an example of when you used this lesson?",
    proTips: [
      "Be specific about the lesson",
      "How has it affected how you live?",
      "This is often the most powerful part of a eulogy",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['taught', 'learned', 'showed', 'lesson', 'never forget'],
  ),

  InterviewQuestion(
    id: 'eulogy_miss',
    question: "What will you miss most? Not the big things - the small everyday things.",
    whyItMatters: "The small things hit hardest. 'I'll miss her smile' is generic. 'I'll miss her calling me by my childhood nickname' is real.",
    exampleAnswer: "I'll miss her phone calls at exactly 7am every Sunday. I'll miss her terrible coffee that she insisted was perfect. I'll miss her saying 'you're too skinny, eat more' every time I walked in. I'll miss her hands - they were always busy doing something, making something.",
    pushForMore: "What sound or smell or small thing will trigger a memory of them?",
    proTips: [
      "The more specific, the more powerful",
      "Sensory details: sounds, smells, textures",
      "What everyday thing will now be different?",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['miss', 'will never', 'won\'t hear', 'won\'t see', 'every time'],
  ),

  InterviewQuestion(
    id: 'eulogy_goodbye',
    question: "If you could say one last thing to them, what would it be?",
    whyItMatters: "This is often how eulogies end. A direct goodbye that lets everyone feel the loss and the love together.",
    exampleAnswer: "Rest now, Grandma. You earned it. You took care of everyone your whole life - let us take care of your memory now. I'll make sure there are always cookies in the jar. And I'll tell my kids about you - they'll know you through our stories. Save me a seat at the kitchen table.",
    proTips: [
      "This is personal. Say what you need to say.",
      "Callbacks to earlier stories work well here",
      "It's okay to be simple: sometimes 'I love you' is enough",
    ],
    minSeconds: 15,
    idealSeconds: 45,
  ),
];

// ============================================================
// 💼 PERFORMANCE REVIEW INTERVIEW
// ============================================================

const performanceReviewInterview = [
  InterviewQuestion(
    id: 'review_context',
    question: "Who are you reviewing? Their name, role, and how long you've worked together.",
    whyItMatters: "Sets the context for the review.",
    exampleAnswer: "Alex Chen, Senior Software Engineer, been my direct report for 2 years. He's been at the company for 3 years total, promoted to senior last year.",
    minSeconds: 15,
    idealSeconds: 30,
  ),

  InterviewQuestion(
    id: 'review_achievements',
    question: "What were their biggest wins this review period? I want specific projects, outcomes, and impact.",
    whyItMatters: "The review needs concrete accomplishments. 'Did good work' means nothing. Specific achievements matter for their career.",
    exampleAnswer: "Alex led the payment migration project - zero downtime moving \$200M in annual transactions to the new system. He also mentored two junior engineers, both of whom got promoted this year. He built the new monitoring dashboard that reduced incident response time by 40%.",
    pushForMore: "Can you add metrics to any of these? Revenue, percentage improvement, team impact?",
    proTips: [
      "Be specific: project names, numbers, timeline",
      "Include things they might be too humble to mention",
      "What did they do that no one else could have?",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresMetrics: true,
    keywords: ['led', 'built', 'improved', 'saved', '%', '\$', 'project'],
  ),

  InterviewQuestion(
    id: 'review_strengths',
    question: "What are they genuinely great at? Not just 'good teammate' - what makes them stand out?",
    whyItMatters: "Strengths should guide their career path. Generic strengths don't help anyone.",
    exampleAnswer: "Alex is exceptional at breaking down complex problems. He can look at a massive technical challenge and immediately identify the critical path. He's also unusually good at communicating technical concepts to non-engineers - product loves working with him because he translates instead of lecturing.",
    pushForMore: "Can you give an example of when this strength really showed?",
    proTips: [
      "Be specific about the strength",
      "Give an example that demonstrates it",
      "Connect it to business value",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),

  InterviewQuestion(
    id: 'review_growth',
    question: "Where do they need to grow? Be honest and specific - vague feedback doesn't help them improve.",
    whyItMatters: "Honest growth areas are a gift. If you're not honest, you're not helping them. Frame it constructively but don't soften it into meaninglessness.",
    exampleAnswer: "Alex needs to get better at delegation. He takes too much on himself and becomes a bottleneck. Last quarter he was working 70-hour weeks because he didn't trust others with critical pieces. He also could improve at speaking up in cross-functional meetings - he has great ideas but waits to be asked.",
    pushForMore: "What's a specific situation where this held them back?",
    proTips: [
      "Be specific - what behavior needs to change?",
      "Frame it as 'to get to the next level' not 'you're bad at'",
      "Give an example of when this hurt them",
      "Suggest concrete ways to improve",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['needs to', 'could improve', 'should work on', 'growth area', 'development'],
  ),

  InterviewQuestion(
    id: 'review_goals',
    question: "What should they focus on next review period? What goals would stretch them?",
    whyItMatters: "Goals give direction. 'Keep doing good work' isn't a goal. Specific, measurable goals drive growth.",
    exampleAnswer: "I want Alex to lead the API redesign project - bigger scope than anything he's done, with 3 engineers under him. I want him to delegate effectively, which means he should be doing zero individual coding on that project. I also want him to present at one all-hands meeting and take our leadership communication course.",
    proTips: [
      "Make goals specific and measurable",
      "Include at least one stretch goal",
      "Connect goals to their growth areas",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['goal', 'want', 'should', 'next', 'focus on', 'stretch'],
  ),
];

// ============================================================
// 📧 SALES EMAIL INTERVIEW
// ============================================================

const salesEmailInterview = [
  InterviewQuestion(
    id: 'sales_target',
    question: "Who are you selling to? Job title, industry, company size - paint me a picture of your ideal customer.",
    whyItMatters: "Great cold emails feel personal. Generic emails get deleted. You need to know exactly who you're talking to.",
    exampleAnswer: "VP of Sales at mid-size B2B SaaS companies, 50-200 employees, Series A to C funded. They've probably tried Salesforce but found it too complex. They care about pipeline visibility and forecasting accuracy. Usually mid-40s, promoted from sales rep, understands the pain their team feels.",
    pushForMore: "What keeps them up at night? What would make them look like a hero?",
    proTips: [
      "The more specific, the better the email",
      "Think about their pain, not your product",
      "What would make them look good to their boss?",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresSpecifics: true,
    keywords: ['VP', 'Director', 'Manager', 'company', 'industry', 'size'],
  ),

  InterviewQuestion(
    id: 'sales_pain',
    question: "What problem are you solving for them? I want to feel their pain - the frustration, the wasted time, the stress.",
    whyItMatters: "Emails that open with 'We're excited to share...' get deleted. Emails that open with 'Tired of spending 4 hours updating your CRM?' get replies.",
    exampleAnswer: "Their sales reps spend 4+ hours a week doing manual data entry. Their CRM is always outdated because no one wants to update it. They're losing deals because of poor follow-up - things fall through the cracks. Every forecast is a guess. Their boss asks for the pipeline and they spend 2 hours scrambling to build a report they don't trust.",
    pushForMore: "What's the cost of this pain? Lost revenue, wasted hours, missed quota?",
    proTips: [
      "Quantify the pain if possible",
      "Use their language - how would THEY describe it?",
      "What's the emotional component? Frustration? Embarrassment?",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['pain', 'problem', 'frustrated', 'wasting', 'hours', 'losing', 'stress'],
  ),

  InterviewQuestion(
    id: 'sales_solution',
    question: "How do you solve this? Give me the outcome, not the features. What's different after they use you?",
    whyItMatters: "No one cares about your features. They care about their results. 'AI-powered logging' = boring. 'Your CRM updates itself, no data entry' = interesting.",
    exampleAnswer: "Calls and emails automatically log to the CRM - zero data entry. Every customer touchpoint is captured without the rep doing anything. Forecasts are based on actual activity data, not guesses. Reps save 5+ hours per week. Managers can see real pipeline without asking anyone.",
    pushForMore: "Can you make this more concrete? What specific outcome can you promise?",
    proTips: [
      "Focus on outcomes, not features",
      "Use specific numbers: 'save 5 hours' not 'save time'",
      "What's the before/after transformation?",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresMetrics: true,
    keywords: ['save', 'automatically', 'without', 'no more', 'instead of', 'results'],
  ),

  InterviewQuestion(
    id: 'sales_proof',
    question: "Why should they believe you? Customer names, results, case studies - what's your proof?",
    whyItMatters: "Email 2 in the sequence adds credibility. Specific results from similar companies are the best proof.",
    exampleAnswer: "Acme Corp increased their close rate by 30% in 3 months. We're used by 500 sales teams, including Stripe, Notion, and HubSpot. G2 rated us #1 in customer satisfaction. I can send case studies from companies in their industry.",
    pushForMore: "Do you have a customer who's in their exact industry or situation?",
    proTips: [
      "Name-drop recognizable companies if you can",
      "Specific metrics beat vague claims",
      "Same industry proof is most compelling",
    ],
    minSeconds: 20,
    idealSeconds: 45,
    keywords: ['customer', 'company', 'results', '%', 'increased', 'saved', 'rated'],
  ),
];

// ============================================================
// 📱 LINKEDIN POST INTERVIEW  
// ============================================================

const linkedInInterview = [
  InterviewQuestion(
    id: 'linkedin_insight',
    question: "What's the insight, lesson, or story you want to share? What's the one thing you want people to take away?",
    whyItMatters: "LinkedIn posts that try to say everything say nothing. One clear point, well made, gets engagement.",
    exampleAnswer: "I want to share that I almost quit my startup last month. I was burned out, doubting everything. But I realized burnout wasn't a signal to quit - it was a signal that I was doing it wrong. I changed my approach and now I'm more excited than ever.",
    pushForMore: "Can you make the takeaway even more specific? One sentence.",
    proTips: [
      "One post = One idea",
      "Your unique take on something everyone experiences",
      "What would make someone stop scrolling?",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['learned', 'realized', 'insight', 'lesson', 'story', 'share'],
  ),

  InterviewQuestion(
    id: 'linkedin_story',
    question: "What's the story behind this? Give me the context, the struggle, the turning point.",
    whyItMatters: "Story = engagement. Facts are forgettable, stories are shareable.",
    exampleAnswer: "Three weeks ago I was sitting in my car in the parking lot, completely drained. I had just finished a 14-hour day and realized I'd have to do the same thing tomorrow. I texted my cofounder 'I don't know if I can keep doing this.' His response changed everything - he said 'Then let's do it differently.'",
    pushForMore: "What happened next? What changed?",
    proTips: [
      "Specific moments > general feelings",
      "Vulnerability gets engagement - show the struggle",
      "What's the transformation?",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresSpecifics: true,
    keywords: ['was', 'felt', 'realized', 'moment', 'then', 'after'],
  ),

  InterviewQuestion(
    id: 'linkedin_takeaway',
    question: "What should people DO with this information? What's actionable?",
    whyItMatters: "The best LinkedIn posts give people something to use. A takeaway makes it valuable, not just interesting.",
    exampleAnswer: "If you're burning out, don't power through - that's how I burned out worse. Instead: Pick ONE thing to stop doing. For me it was checking Slack after 7pm. That single change gave me my evenings back and I came back to work refreshed.",
    proTips: [
      "Specific advice beats generic advice",
      "'Try this ONE thing' is more actionable than a list of 10",
      "What would YOU tell your past self?",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['do', 'try', 'should', 'tip', 'advice', 'action', 'one thing'],
  ),
];

// ============================================================
// MASTER INTERVIEW REGISTRY
// ============================================================

/// Get the interview flow for a template
List<InterviewQuestion>? getInterviewForTemplate(String templateId) {
  switch (templateId) {
    case 'resume': return resumeInterview;
    case 'college_essay': return collegeEssayInterview;
    case 'wedding_speech': return weddingSpeechInterview;
    case 'pitch_deck': return pitchDeckInterview;
    case 'insurance_appeal': return insuranceAppealInterview;
    case 'eulogy': return eulogyInterview;
    case 'performance_review': return performanceReviewInterview;
    case 'sales_email_sequence': return salesEmailInterview;
    case 'linkedin_post': return linkedInInterview;
    default: return null; // Falls back to standard template flow
  }
}

/// Check if a template has a guided interview
bool hasGuidedInterview(String templateId) {
  return getInterviewForTemplate(templateId) != null;
}