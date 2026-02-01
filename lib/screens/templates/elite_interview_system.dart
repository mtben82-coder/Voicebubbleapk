// ============================================================
//        ELITE GUIDED INTERVIEW SYSTEM
// ============================================================
//
// This is what $500+ resume writers & consultants actually do:
// - Deep discovery questions
// - Push for specifics & metrics  
// - Know exactly what makes content WORK
// - Never accept vague answers
//
// We do it 1000x better, by VOICE.
//
// ============================================================

import 'package:flutter/material.dart';

/// Interview question with smart follow-ups
class InterviewQuestion {
  final String id;
  final String question;           // The actual question to ask
  final String whyItMatters;       // Shown to user - why this matters
  final String exampleAnswer;      // What a GREAT answer sounds like
  final String pushForMore;        // If answer is weak, ask this
  final List<String> proTips;      // Expert tips shown before they answer
  final List<String> commonMistakes; // What to avoid
  final int minSeconds;            // Minimum recording length expected
  final int idealSeconds;          // Ideal recording length
  final bool requiresMetrics;      // Should contain numbers?
  final bool requiresSpecifics;    // Should contain names/details?
  final List<String> keywords;     // Keywords that indicate good answer

  const InterviewQuestion({
    required this.id,
    required this.question,
    required this.whyItMatters,
    required this.exampleAnswer,
    this.pushForMore = '',
    this.proTips = const [],
    this.commonMistakes = const [],
    this.minSeconds = 15,
    this.idealSeconds = 45,
    this.requiresMetrics = false,
    this.requiresSpecifics = false,
    this.keywords = const [],
  });
}

/// Quality assessment of an answer
class AnswerQuality {
  final int score;              // 0-100
  final String feedback;        // What to improve
  final bool hasMetrics;
  final bool hasSpecifics;
  final bool isLongEnough;
  final List<String> missing;   // What's missing
  final List<String> strengths; // What's good
  final bool needsMore;

  const AnswerQuality({
    required this.score,
    required this.feedback,
    this.hasMetrics = false,
    this.hasSpecifics = false,
    this.isLongEnough = false,
    this.missing = const [],
    this.strengths = const [],
    this.needsMore = false,
  });
}

// ============================================================
// 🏆 RESUME INTERVIEW - What $500 resume writers ask
// ============================================================

const resumeInterview = [
  // OPENER - Build rapport, understand context
  InterviewQuestion(
    id: 'resume_context',
    question: "What kind of role are you applying for, and what's making you look for a new opportunity?",
    whyItMatters: "Resume writers tailor EVERYTHING to your target role. A resume for a startup vs corporate job looks completely different.",
    exampleAnswer: "I'm a senior software engineer looking for a Staff Engineer role at a mid-size tech company. I've been at my current company 4 years and hit the ceiling - no more growth, and I want to lead larger technical initiatives.",
    pushForMore: "Can you be more specific about the type of company and role level you're targeting?",
    proTips: [
      "Be specific about role level (Senior, Lead, Manager, etc.)",
      "Name 2-3 target companies if you have them",
      "Mention what's MISSING at your current job",
    ],
    commonMistakes: [
      "Being too vague: 'I want a good job'",
      "Not knowing your target: makes the resume generic",
    ],
    minSeconds: 20,
    idealSeconds: 45,
  ),

  // EXPERIENCE - The meat
  InterviewQuestion(
    id: 'resume_current_role',
    question: "Tell me about your current or most recent role. What do you ACTUALLY do day-to-day, and what's the biggest thing you've accomplished?",
    whyItMatters: "This becomes your top bullet points. Recruiters spend 6 seconds on a resume - your recent role better be STRONG.",
    exampleAnswer: "I'm a Senior Engineer at Stripe. Day-to-day I lead a team of 4 engineers building the payments reconciliation system. Biggest accomplishment: I redesigned our batch processing pipeline which reduced processing time from 6 hours to 45 minutes and saved the company about 2 million dollars in infrastructure costs annually.",
    pushForMore: "That's good, but can you add specific numbers? Team size, revenue impact, percentage improvements, users affected?",
    proTips: [
      "ALWAYS include numbers: team size, revenue, users, percentage improvements",
      "Use the formula: Did X, which resulted in Y, measured by Z",
      "Focus on IMPACT not just tasks",
      "If you don't know exact numbers, estimate: 'approximately' is fine",
    ],
    commonMistakes: [
      "Listing tasks instead of achievements: 'Wrote code' vs 'Built feature that increased conversion 25%'",
      "No numbers: 'Improved performance' vs 'Reduced latency by 60%'",
      "Being humble: This is not the time. Brag.",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresMetrics: true,
    requiresSpecifics: true,
    keywords: ['increased', 'reduced', 'saved', 'led', 'built', 'launched', '%', '\$', 'million', 'team of'],
  ),

  InterviewQuestion(
    id: 'resume_achievement_proud',
    question: "What's the achievement you're MOST proud of in your career? The thing that makes you think 'yeah, I crushed that.'",
    whyItMatters: "This often becomes your headline achievement - the thing that makes recruiters stop and say 'we need to talk to this person.'",
    exampleAnswer: "I'm most proud of leading the migration of our entire monolith to microservices while keeping the site live. Zero downtime over 8 months. My CEO mentioned it in our all-hands. We went from deploying once a week to 50 times a day, and engineering velocity doubled.",
    pushForMore: "That's great! What was the measurable business impact? Revenue, users, speed improvement?",
    proTips: [
      "Pick something with clear before/after",
      "Ideally something that got recognized (promotion, award, CEO mention)",
      "The bigger the scope, the better",
      "If technical: translate to business impact",
    ],
    commonMistakes: [
      "Picking something small",
      "Not connecting to business value",
      "Being vague about the outcome",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresMetrics: true,
    keywords: ['proud', 'led', 'saved', 'grew', 'launched', 'promoted', 'recognized'],
  ),

  InterviewQuestion(
    id: 'resume_leadership',
    question: "Have you led people, projects, or initiatives? Tell me about a time you were in charge of something important.",
    whyItMatters: "Leadership experience is the #1 differentiator for senior roles. Even informal leadership counts.",
    exampleAnswer: "I've never had direct reports, but I led our platform team's biggest initiative last year - rebuilding our authentication system. I coordinated 3 teams across 2 time zones, ran weekly syncs with stakeholders, made the technical architecture decisions, and delivered 2 weeks early. My manager told me it was the smoothest cross-team project he'd seen.",
    pushForMore: "How many people were involved? What was at stake if it failed?",
    proTips: [
      "Leadership isn't just managing people",
      "Leading a project, mentoring juniors, driving a decision - all count",
      "Show you can influence without authority",
      "Include the stakes - what was riding on this?",
    ],
    commonMistakes: [
      "Saying 'I haven't led anyone' - you probably have, informally",
      "Not mentioning the scope/stakes",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresSpecifics: true,
    keywords: ['led', 'coordinated', 'managed', 'mentored', 'drove', 'decided', 'team', 'project'],
  ),

  InterviewQuestion(
    id: 'resume_skills',
    question: "What are your strongest technical skills and tools? What would you consider yourself an expert in?",
    whyItMatters: "Skills get you past the ATS (applicant tracking system). Missing a keyword can mean auto-rejection.",
    exampleAnswer: "Expert level: Python, Go, PostgreSQL, AWS (EC2, Lambda, RDS, S3), Kubernetes, Docker. Strong: React, TypeScript, Redis, Kafka. I'm also good at system design - I've designed systems handling 10 million requests per day.",
    pushForMore: "Any certifications? What about soft skills like system design, architecture, communication?",
    proTips: [
      "Be specific: 'Python' not 'programming'",
      "Include cloud platforms with specific services",
      "Mention scale you've worked at",
      "Don't forget: CI/CD, testing, monitoring tools",
      "Check the job posting - mirror their language",
    ],
    commonMistakes: [
      "Being too general: 'coding' instead of specific languages",
      "Forgetting tools: Git, Jira, monitoring (DataDog, etc)",
      "Not matching job posting keywords",
    ],
    minSeconds: 20,
    idealSeconds: 40,
    keywords: ['expert', 'proficient', 'years', 'certified'],
  ),

  InterviewQuestion(
    id: 'resume_education',
    question: "Quick one - education background? Degree, school, graduation year, any honors or relevant activities?",
    whyItMatters: "Less important for experienced folks, but still needs to be there. Honors and activities can differentiate.",
    exampleAnswer: "BS in Computer Science from UC Berkeley, 2018. Graduated cum laude, was president of the AI club, and did undergrad research in machine learning.",
    pushForMore: "",
    proTips: [
      "Include GPA only if 3.5+",
      "Leadership roles in clubs count",
      "Relevant coursework only if recent grad",
    ],
    commonMistakes: [
      "Including high school (never do this)",
      "Listing every course you took",
    ],
    minSeconds: 10,
    idealSeconds: 20,
  ),

  InterviewQuestion(
    id: 'resume_why_you',
    question: "Last one - in one sentence, what makes you different from every other candidate applying for this role?",
    whyItMatters: "This becomes your professional summary. The hook that makes them keep reading.",
    exampleAnswer: "I'm a backend engineer who's unusually strong at understanding business context - I've shipped 3 features that directly drove revenue because I talk to customers, not just product managers.",
    pushForMore: "What's your unique combination? The thing no one else has?",
    proTips: [
      "Find your unique intersection",
      "Technical + business is powerful",
      "Industry expertise + skills",
      "Not 'I work hard' - everyone says that",
    ],
    commonMistakes: [
      "Generic: 'I'm a hard worker' - means nothing",
      "Too humble: 'I'm pretty good at...'",
      "Too long: this should be punchy",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

// ============================================================
// 🎓 COLLEGE ESSAY INTERVIEW - What $10K consultants do
// ============================================================

const collegeEssayInterview = [
  InterviewQuestion(
    id: 'essay_prompt',
    question: "Read me the essay prompt you're responding to.",
    whyItMatters: "Every word of your essay needs to answer THIS prompt. Off-topic = rejection.",
    exampleAnswer: "The prompt is: 'Describe a challenge, setback, or failure you experienced. How did it affect you, and what did you learn?'",
    proTips: [
      "We'll come back to this prompt throughout",
      "The best essays answer the prompt in unexpected ways",
    ],
    minSeconds: 10,
    idealSeconds: 30,
  ),

  InterviewQuestion(
    id: 'essay_moment',
    question: "Close your eyes for a second. Think of a specific MOMENT in your life that changed how you see yourself or the world. Not a topic - a MOMENT. Where were you? What did you see, hear, feel?",
    whyItMatters: "Admissions officers read 30,000 essays. They remember SCENES, not summaries. 'I learned leadership' is forgettable. 'Standing in the rain after my team lost' is memorable.",
    exampleAnswer: "I was 15, sitting in my mom's hospital room at 2am. The fluorescent lights were buzzing. She was asleep after surgery, and I was holding her hand, watching the heart monitor. I remember thinking 'I'm not ready to be the adult yet' but knowing I had to be.",
    pushForMore: "Can you put me IN that moment more? What did you see? What sounds do you remember? What were you physically feeling?",
    proTips: [
      "Specific > General. ALWAYS.",
      "Sensory details: what did you SEE, HEAR, SMELL, FEEL?",
      "A small moment with big meaning beats a big moment with obvious meaning",
      "Admissions officers can spot generic 'mission trip changed my life' essays instantly",
    ],
    commonMistakes: [
      "Picking the 'impressive' moment instead of the REAL moment",
      "Being vague: 'It was really hard' - SHOW don't tell",
      "Choosing what you think they want to hear",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresSpecifics: true,
    keywords: ['remember', 'felt', 'saw', 'heard', 'thought', 'realized'],
  ),

  InterviewQuestion(
    id: 'essay_before',
    question: "Who were you BEFORE this moment? What did you believe about yourself or the world that was about to change?",
    whyItMatters: "Great essays show transformation. We need to see who you were to appreciate who you became.",
    exampleAnswer: "Before that night, I thought I was just a normal kid. My mom handled everything. I focused on school, basketball, hanging out with friends. I thought being strong meant never showing you're scared. I thought asking for help was weakness.",
    pushForMore: "What's one specific belief you held that turned out to be wrong?",
    proTips: [
      "Be honest about your younger self - including flaws",
      "Show the contrast with who you are now",
      "Vulnerability is strength in essays",
    ],
    commonMistakes: [
      "Making your 'before' self too perfect",
      "Not being honest about flaws or naivety",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),

  InterviewQuestion(
    id: 'essay_struggle',
    question: "What was genuinely HARD about this experience? Not the sanitized version - the real struggle.",
    whyItMatters: "Admissions officers can smell fake difficulty. They want to see you faced something real and came out different.",
    exampleAnswer: "The hardest part wasn't taking care of my mom - it was being angry at her for getting sick, and then feeling guilty for being angry. I had to drop basketball, my grades slipped, and I pushed my friends away because I didn't want them to see me struggling. I cried in my car in the school parking lot more times than I can count.",
    pushForMore: "What's something about this you've never told anyone?",
    proTips: [
      "Real struggle has messy emotions",
      "It's okay to show anger, fear, doubt",
      "Admissions officers are humans - they connect with honesty",
      "You don't have to have it all figured out",
    ],
    commonMistakes: [
      "Making the struggle sound too clean",
      "Skipping to the lesson without sitting in the difficulty",
      "Being afraid to show negative emotions",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    keywords: ['hard', 'difficult', 'struggled', 'felt', 'scared', 'angry', 'confused', 'cried'],
  ),

  InterviewQuestion(
    id: 'essay_turning',
    question: "Was there a turning point? A moment where something shifted?",
    whyItMatters: "The best essays have a pivot - a realization, a conversation, a small moment where the light came in.",
    exampleAnswer: "The turning point was when my mom woke up from a nap and saw me doing homework while also meal-prepping for the week. She started crying and said 'I'm so sorry you have to do this.' And I realized - I wasn't angry at her. I was proud of myself. I was becoming someone I actually liked.",
    pushForMore: "What specifically triggered that realization?",
    proTips: [
      "Turning points can be small moments",
      "Often it's something someone said, or a sudden realization",
      "This doesn't have to be dramatic",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),

  InterviewQuestion(
    id: 'essay_now',
    question: "Who are you NOW because of this experience? Not who do you want to be - who ARE you?",
    whyItMatters: "The essay needs to show growth, but authentic growth - not a perfect happy ending.",
    exampleAnswer: "I'm someone who knows I can handle hard things. I still don't have it all figured out - I still struggle with asking for help sometimes. But I learned that strength isn't about doing everything alone, it's about showing up even when you're scared. I want to be a nurse now, not because of some noble calling, but because I know what it feels like to be the scared person in the waiting room, and I want to be the calm presence for someone else.",
    pushForMore: "What's something you still struggle with? Growth isn't about being perfect.",
    proTips: [
      "Don't wrap it up too neatly",
      "Show ongoing growth, not 'I'm fixed now'",
      "Connect to your future without being corny about it",
      "Authenticity > Perfection",
    ],
    commonMistakes: [
      "Claiming you're now perfect",
      "Forced connection to your major/career",
      "Sounding like you have it all figured out (you're 17, you don't, and that's okay)",
    ],
    minSeconds: 45,
    idealSeconds: 90,
  ),

  InterviewQuestion(
    id: 'essay_voice',
    question: "Last thing - tell me something random about yourself. A quirk, a weird hobby, something that makes you YOU.",
    whyItMatters: "Great essays have VOICE. A little weirdness makes you memorable and human.",
    exampleAnswer: "I have very strong opinions about sandwich construction. I think about it way too much. The structural integrity of a sandwich is a serious matter and most people get it wrong.",
    pushForMore: "",
    proTips: [
      "This might not make it into the essay directly",
      "But it helps capture YOUR voice",
      "Weird is good. Memorable is the goal.",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

// ============================================================
// 💍 WEDDING SPEECH INTERVIEW - What speechwriters ask
// ============================================================

const weddingSpeechInterview = [
  InterviewQuestion(
    id: 'speech_role',
    question: "First, what's your role? Best man, maid of honor, father of the bride, etc? And how long have you known them?",
    whyItMatters: "Your role determines your angle. Best friend vs parent vs sibling = completely different speech.",
    exampleAnswer: "Best man. I've known Jake since we were 5 - we grew up next door, went to the same schools, were roommates in college. He's basically my brother.",
    minSeconds: 15,
    idealSeconds: 30,
  ),

  InterviewQuestion(
    id: 'speech_who',
    question: "In your own words, who IS this person you're toasting? Not their resume - their ESSENCE. What makes them THEM?",
    whyItMatters: "The speech needs to capture their authentic personality - not generic 'they're a great person' stuff.",
    exampleAnswer: "Jake is the most loyal person I know. Not in a loud way - he's actually kind of quiet. But when you need him, he's there. No questions. He once drove 4 hours at 2am because I called him drunk and sad. He also has the worst taste in movies - like genuinely terrible - and he thinks he's a great cook when he's really not. But he tries so hard at everything.",
    pushForMore: "What's something about them that might surprise people who don't know them well?",
    proTips: [
      "Mix the meaningful with the mundane",
      "Quirks make them real",
      "Think about what you'd miss if they were gone",
    ],
    commonMistakes: [
      "Generic: 'They're kind, smart, funny' - everyone says this",
      "Only serious or only funny - need both",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresSpecifics: true,
  ),

  InterviewQuestion(
    id: 'speech_funny',
    question: "Tell me a FUNNY story about them. Something that makes you laugh even now. Bonus if it gently embarrasses them.",
    whyItMatters: "Every great speech has a laugh moment. It relaxes the room and shows your real relationship.",
    exampleAnswer: "Okay so Jake once tried to impress a girl in college by claiming he could do a backflip. He could not, in fact, do a backflip. He ended up in a bush, covered in leaves, while the girl just walked away. He still insists he 'almost had it.' We bring up the Bush Incident at least once a year.",
    pushForMore: "Do you have another one? The more options the better.",
    proTips: [
      "Embarrassing is good, humiliating is not",
      "Nothing about exes, bathroom stuff, or anything truly private",
      "Should make THEM laugh too, not cringe",
      "Test it: Would they tell this story themselves?",
    ],
    commonMistakes: [
      "Going too far - nothing that'll make grandma uncomfortable",
      "Inside jokes no one else gets",
      "Making them look bad vs endearingly foolish",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    keywords: ['funny', 'laugh', 'hilarious', 'remember when', 'can\'t believe'],
  ),

  InterviewQuestion(
    id: 'speech_change',
    question: "How did you see them CHANGE when they met their partner? What's different about them now?",
    whyItMatters: "This is the emotional core. You're witnessing what their partner brings out in them.",
    exampleAnswer: "Before Sarah, Jake was always kind of restless. Like he was looking for something but didn't know what. When he met her, something settled. He stopped trying to prove himself all the time. He laughs more. He actually makes plans for the future now instead of living week to week. She makes him brave enough to be soft, if that makes sense.",
    pushForMore: "Can you give me a specific example of this change you noticed?",
    proTips: [
      "Be specific about the transformation",
      "This is the moment the room goes from laughing to tearing up",
      "What does their partner bring out that no one else could?",
    ],
    commonMistakes: [
      "Generic: 'They seem happy' - dig deeper",
      "Making it about you: 'I used to hang out with them more'",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    keywords: ['before', 'now', 'changed', 'different', 'noticed', 'realized'],
  ),

  InterviewQuestion(
    id: 'speech_moment',
    question: "Is there a moment that showed you 'this is real love'? Something you witnessed between them?",
    whyItMatters: "This is your proof point. You're not just saying they're great together - you're showing it.",
    exampleAnswer: "I knew it was real when I saw Jake take care of Sarah when she had food poisoning on a trip. I'm talking really gross, really sick. And Jake didn't flinch. He held her hair back, cleaned up after her, made her soup, never once complained. Most couples hide that stuff at the beginning. They didn't. That's when I knew - they'd already jumped past the performance phase.",
    pushForMore: "Any other moments? Maybe something more lighthearted?",
    proTips: [
      "Small moments often hit harder than big ones",
      "Look for times when they didn't know you were watching",
      "How do they look at each other?",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),

  InterviewQuestion(
    id: 'speech_partner',
    question: "What do you want to say directly to their partner? You're welcoming them into your friend's life.",
    whyItMatters: "Great speeches speak TO the partner at some point, not just ABOUT them.",
    exampleAnswer: "To Sarah: Thank you for loving my best friend the way he deserves to be loved. Thank you for making him laugh, for being patient with his bad cooking, for not making fun of his terrible movie choices - well, okay, you can make fun of those. Welcome to the family. I've got his back, but now I've got yours too.",
    pushForMore: "",
    proTips: [
      "Keep it warm and welcoming",
      "Acknowledge what they bring to your person",
      "This is generosity - make THEM feel loved",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),

  InterviewQuestion(
    id: 'speech_toast',
    question: "How do you want to end it? What's your wish for them? This is your toast.",
    whyItMatters: "The toast is the final moment. Leave them with something meaningful.",
    exampleAnswer: "I wish them a marriage full of inside jokes, terrible movie nights, at least one more backflip attempt, and the kind of love that makes the hard days bearable and the good days unforgettable. To Jake and Sarah.",
    pushForMore: "",
    proTips: [
      "Callback to an earlier joke if you can",
      "Keep it short - 2-3 sentences max",
      "End on love, not laughs",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

// ============================================================
// 🚀 PITCH DECK INTERVIEW - What startup advisors ask
// ============================================================

const pitchDeckInterview = [
  InterviewQuestion(
    id: 'pitch_oneliner',
    question: "In ONE sentence - what does your company do? Pretend you have 10 seconds in an elevator with an investor.",
    whyItMatters: "If you can't explain it in one sentence, you don't understand it well enough. VCs decide in seconds whether to keep listening.",
    exampleAnswer: "We're Uber for dog walking - on-demand pet care that arrives in 15 minutes.",
    pushForMore: "Can you make it shorter? What's the simplest version?",
    proTips: [
      "The '[Known Company] for [X]' format works if it's accurate",
      "Avoid jargon - your grandma should understand it",
      "Lead with what you DO, not the technology",
      "If you're using AI, that's HOW, not WHAT",
    ],
    commonMistakes: [
      "Too long: If it takes 3 sentences, start over",
      "Too much jargon: 'AI-powered ML platform' - what does it DO?",
      "Explaining the technology instead of the value",
    ],
    minSeconds: 10,
    idealSeconds: 20,
  ),

  InterviewQuestion(
    id: 'pitch_problem',
    question: "What problem are you solving? I want to FEEL the pain. Tell me about someone who has this problem right now.",
    whyItMatters: "Investors invest in pain. If the problem isn't painful enough, no one will pay to solve it.",
    exampleAnswer: "Sarah is a nurse who works 12-hour shifts. She has a dog named Max who she loves, but she feels guilty every single day leaving him alone. She's tried asking neighbors but feels like a burden. She's looked at dog walkers but they need 24-hour notice. Last Tuesday she came home to find Max had an accident because she got stuck at work. She cried. There are 50 million Sarahs in America.",
    pushForMore: "How do you know this is a real problem? Have you talked to these people?",
    proTips: [
      "Make it a STORY about a real person",
      "Use specifics - name, situation, emotion",
      "Quantify: How many people have this problem?",
      "Show you've TALKED to people with this problem",
    ],
    commonMistakes: [
      "Assuming the problem is obvious - prove it",
      "Solving a problem you have, that no one else has",
      "No data or customer interviews",
    ],
    minSeconds: 45,
    idealSeconds: 90,
    requiresSpecifics: true,
    keywords: ['problem', 'pain', 'struggle', 'frustrated', 'million', 'people'],
  ),

  InterviewQuestion(
    id: 'pitch_solution',
    question: "How does your product solve this? Walk me through the user experience - what happens when Sarah opens your app?",
    whyItMatters: "The solution needs to be obviously better. If it's only slightly better, no one will switch.",
    exampleAnswer: "Sarah opens the app, sees available walkers near her with ratings and photos. She taps 'Book Now', picks a 30-minute walk, and a verified walker shows up in 15 minutes. She gets GPS tracking of the walk, photos of Max at the park, and a notification when he's back home safe. Total time: 90 seconds to book. Cost: \$25.",
    pushForMore: "Why is this 10x better than the alternative?",
    proTips: [
      "Show don't tell - walk through the experience",
      "Make the '10x better' clear",
      "What's the magic moment?",
      "Compare to what they do TODAY",
    ],
    commonMistakes: [
      "Describing features instead of experience",
      "Not showing why it's dramatically better",
      "Too many features - focus on the core magic",
    ],
    minSeconds: 45,
    idealSeconds: 90,
  ),

  InterviewQuestion(
    id: 'pitch_market',
    question: "How big is this market? I want TAM, SAM, SOM if you know them, or just help me understand the size of the opportunity.",
    whyItMatters: "VCs need to see a path to a big outcome. A great solution to a tiny problem isn't venture-scale.",
    exampleAnswer: "The US pet care market is \$100 billion and growing 6% yearly. Dog services specifically is \$30 billion. Our serviceable market - urban dog owners who work full-time - is about \$5 billion. We're starting in SF where there are 200,000 households with dogs and an average income of \$120K.",
    pushForMore: "Where did these numbers come from? Are these paying customers or potential customers?",
    proTips: [
      "Bottom-up is more credible than top-down",
      "TAM = Total market, SAM = Segment you can serve, SOM = What you can realistically get",
      "Show the market is big AND growing",
      "If you're creating a new category, be honest about that",
    ],
    commonMistakes: [
      "'If we get just 1% of the market' - VCs hate this",
      "Using TAM when you'll never reach it",
      "No sources for numbers",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresMetrics: true,
    keywords: ['billion', 'million', 'market', 'growing', '%', 'TAM', 'SAM'],
  ),

  InterviewQuestion(
    id: 'pitch_traction',
    question: "What traction do you have? Users, revenue, growth rate, waitlist - whatever you've got.",
    whyItMatters: "Traction is proof. Ideas are cheap. Execution is everything.",
    exampleAnswer: "We launched 6 months ago. 10,000 users, 3,000 monthly active. \$50K monthly recurring revenue, growing 30% month over month. 4.9 stars on the App Store with 500 reviews. NPS of 72. Retention at day 30 is 40%, which is strong for consumer apps.",
    pushForMore: "What's your growth rate? How are people finding you?",
    proTips: [
      "Lead with your BEST metric",
      "Show growth rate, not just absolute numbers",
      "If pre-revenue, show user growth, waitlist, engagement",
      "Retention is often more impressive than acquisition",
    ],
    commonMistakes: [
      "Hiding weak metrics - VCs will find them",
      "Showing vanity metrics (downloads) over real ones (active users)",
      "No growth rate - static numbers aren't impressive",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresMetrics: true,
    keywords: ['users', 'revenue', 'MRR', 'growth', '%', 'month over month', 'active'],
  ),

  InterviewQuestion(
    id: 'pitch_business',
    question: "How do you make money? What's the business model and unit economics?",
    whyItMatters: "Investors need to see a path to profitability, even if it's years away.",
    exampleAnswer: "We take 20% of every booking. Average order value is \$25, so we make \$5 per walk. Customer acquisition cost is \$15, but average customer lifetime value is \$300 because they book twice a week for 6+ months. We also have a subscription tier at \$99/month for unlimited walks that 20% of active users have upgraded to - that's where the margin is.",
    pushForMore: "What are your unit economics? Do you make money on each transaction?",
    proTips: [
      "Know your CAC (customer acquisition cost), LTV (lifetime value), and margins",
      "LTV/CAC ratio above 3 is great",
      "If you're not profitable yet, show the path",
    ],
    commonMistakes: [
      "Not knowing unit economics",
      "'We'll figure out monetization later' - red flag",
      "Assuming scale will fix bad economics",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresMetrics: true,
    keywords: ['revenue', 'margin', 'CAC', 'LTV', 'unit economics', '\$', '%'],
  ),

  InterviewQuestion(
    id: 'pitch_team',
    question: "Why is YOUR team the one to build this? What's your unfair advantage?",
    whyItMatters: "VCs bet on teams, not just ideas. Why will YOU win against everyone else who has this idea?",
    exampleAnswer: "I ran operations at Rover for 3 years - I know the pet care industry inside out, including why Rover's model has limitations. My cofounder was a senior engineer at Uber - she built their surge pricing algorithm and knows how to handle real-time matching at scale. We've also already built and sold a pet tech startup before. We're the only team with deep pet industry knowledge AND on-demand logistics experience.",
    pushForMore: "Have you worked together before? Why will you win against competitors?",
    proTips: [
      "Show relevant experience - why YOU?",
      "Unfair advantages: industry experience, technical skills, relationships",
      "Previous startup experience (even failures) is valuable",
      "Show you've worked together before if you have",
    ],
    commonMistakes: [
      "'We're passionate about this' - not enough",
      "Resumes without relevance to this problem",
      "Not addressing obvious experience gaps",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresSpecifics: true,
    keywords: ['experience', 'built', 'worked at', 'founded', 'expertise', 'unfair advantage'],
  ),

  InterviewQuestion(
    id: 'pitch_ask',
    question: "How much are you raising and what will you use it for? What milestones will you hit?",
    whyItMatters: "The ask needs to be specific with clear milestones. Vague asks = no investment.",
    exampleAnswer: "We're raising \$2 million at a \$10 million post-money valuation. 18 months of runway. Use of funds: 50% on engineering to build the platform, 30% on customer acquisition to launch in 3 more cities, 20% on operations. Milestones: hit \$500K MRR, expand to 5 cities, reach 100K users. Those metrics position us for a Series A.",
    pushForMore: "What milestones will this money help you hit?",
    proTips: [
      "Be specific: amount, valuation if you have one, use of funds",
      "Show the milestones this money unlocks",
      "18 months runway is standard for seed",
      "Connect milestones to next fundraise",
    ],
    commonMistakes: [
      "Vague use of funds",
      "No milestones attached to the raise",
      "Raising too little (can't hit milestones) or too much (too dilutive)",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresMetrics: true,
    keywords: ['raising', 'valuation', 'runway', 'milestones', '\$', 'million'],
  ),
];

// ============================================================
// QUALITY SCORING ENGINE
// ============================================================

class QualityScorer {
  /// Analyze answer quality based on question requirements
  static AnswerQuality scoreAnswer({
    required InterviewQuestion question,
    required String answer,
    required int recordingSeconds,
  }) {
    final metrics = <String>[];
    final specifics = <String>[];
    final strengths = <String>[];
    final missing = <String>[];
    
    // Check length
    final isLongEnough = recordingSeconds >= question.minSeconds;
    if (!isLongEnough) {
      missing.add('Try to elaborate more - aim for at least ${question.minSeconds} seconds');
    } else if (recordingSeconds >= question.idealSeconds) {
      strengths.add('Great detail level');
    }
    
    // Check for metrics if required
    final hasMetrics = _containsMetrics(answer);
    if (question.requiresMetrics) {
      if (hasMetrics) {
        strengths.add('Good use of specific numbers');
      } else {
        missing.add('Add specific numbers (%, \$, team size, time saved, etc.)');
      }
    }
    
    // Check for specifics if required
    final hasSpecifics = _containsSpecifics(answer);
    if (question.requiresSpecifics) {
      if (hasSpecifics) {
        strengths.add('Good specific details');
      } else {
        missing.add('Add more specific details (names, places, examples)');
      }
    }
    
    // Check for keywords
    final keywordCount = _countKeywords(answer, question.keywords);
    final keywordRatio = question.keywords.isEmpty ? 1.0 : keywordCount / question.keywords.length;
    if (keywordRatio > 0.3) {
      strengths.add('Hitting the right points');
    }
    
    // Calculate score
    var score = 50; // Base score
    
    if (isLongEnough) score += 15;
    if (recordingSeconds >= question.idealSeconds) score += 10;
    if (hasMetrics && question.requiresMetrics) score += 15;
    if (hasSpecifics && question.requiresSpecifics) score += 10;
    score += (keywordRatio * 20).round();
    
    score = score.clamp(0, 100);
    
    // Generate feedback
    String feedback;
    if (score >= 85) {
      feedback = "Excellent! This is exactly what we need.";
    } else if (score >= 70) {
      feedback = "Good! A few more details would make it perfect.";
    } else if (score >= 50) {
      feedback = "Getting there. Try adding more specifics.";
    } else {
      feedback = "Let's try again with more detail.";
    }
    
    return AnswerQuality(
      score: score,
      feedback: feedback,
      hasMetrics: hasMetrics,
      hasSpecifics: hasSpecifics,
      isLongEnough: isLongEnough,
      missing: missing,
      strengths: strengths,
      needsMore: score < 70,
    );
  }
  
  static bool _containsMetrics(String text) {
    // Look for numbers, percentages, dollar amounts
    final metricPatterns = [
      RegExp(r'\d+%'),           // Percentages
      RegExp(r'\$[\d,]+'),       // Dollar amounts
      RegExp(r'\d+x'),           // Multipliers
      RegExp(r'\d+\s*(million|billion|thousand|k|m|b)', caseSensitive: false),
      RegExp(r'team of \d+'),    // Team sizes
      RegExp(r'\d+\s*(hours?|days?|weeks?|months?|years?)'),  // Time periods
      RegExp(r'\d+\s*(users?|customers?|clients?)'),  // User counts
    ];
    
    return metricPatterns.any((pattern) => pattern.hasMatch(text));
  }
  
  static bool _containsSpecifics(String text) {
    // Look for specific details
    final lowerText = text.toLowerCase();
    
    // Check for proper nouns (capitalized words that aren't sentence starters)
    final hasProperNouns = RegExp(r'(?<=[.!?]\s+|\n|^)[A-Z][a-z]+(?:\s+[A-Z][a-z]+)*')
        .allMatches(text).length > 1;
    
    // Check for specific indicators
    final specificIndicators = [
      'remember when',
      'for example',
      'specifically',
      'one time',
      'at my',
      'in my',
      'last year',
      'last month',
    ];
    
    return hasProperNouns || specificIndicators.any((s) => lowerText.contains(s));
  }
  
  static int _countKeywords(String text, List<String> keywords) {
    final lowerText = text.toLowerCase();
    return keywords.where((k) => lowerText.contains(k.toLowerCase())).length;
  }
}