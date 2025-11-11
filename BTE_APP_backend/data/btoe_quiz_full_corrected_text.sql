
CREATE TABLE IF NOT EXISTS quiz_questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    behavior_symbol TEXT,
    behavior_name TEXT,
    question TEXT NOT NULL,
    answer TEXT NOT NULL
);

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ga', 'Gestures Absent', 'What does the Arm Cross (Acc) behavior typically indicate?', 'A need for assurance, warmth, or protection; sometimes defensiveness or intimidation based on posture details.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ga', 'Gestures Absent', 'How many common variations of the Arm Cross are noted in the BToE?', 'There are four variations, each with specific meanings based on posture and hand position.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ga', 'Gestures Absent', 'What does a tight grip during an arm cross suggest?', 'It suggests a strong need for reassurance or self-comfort.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ga', 'Gestures Absent', 'What might upward-pointing thumbs during an arm cross signal?', 'Upward thumbs usually indicate confidence despite the defensive posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ga', 'Gestures Absent', 'How is anger sometimes shown in an Arm Cross?', 'Anger may be signaled by clenched fists or strong digital flexion during the gesture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ht', 'head tilt', 'What emotions are commonly associated with the Head Tilt (Ht)?', 'Curiosity, flirtation, innocence, and openness.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ht', 'head tilt', 'Why is the Head Tilt considered a vulnerable gesture?', 'It exposes vital areas like the neck, signaling trust or non-aggression.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ht', 'head tilt', 'What are conflicting behaviors to the Head Tilt gesture?', 'Jaw Clenching (Jc) and boredom (Tp) are listed as conflicting behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ht', 'head tilt', 'What context can make a Head Tilt appear as feigned boredom?', 'When paired with a lack of engagement or facial expression indicating disinterest.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ht', 'head tilt', 'Does the direction of the tilt (left or right) matter in analysis?', 'No, the BToE considers the direction of the tilt irrelevant to interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ct', 'Chin Thrust', 'What does the Chin Thrust gesture commonly signify?', 'It often signals aggression, challenge, or dominance, especially in Western cultures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ct', 'Chin Thrust', 'What cultural differences are associated with Chin Thrust?', 'In the Middle East and parts of Eastern Europe, it can signal agreement or direction rather than aggression.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ct', 'Chin Thrust', 'What physiological part is exposed during a Chin Thrust?', 'The throat and neck area, which are considered vulnerable, indicating confidence or challenge.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ct', 'Chin Thrust', 'How does Chin Thrust relate to clothing adjustment?', 'It can be a micro-gesture used by men to adjust shirt collars, known as ventilatory behavior.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ct', 'Chin Thrust', 'What is the difference between the two variations of Chin Thrust?', 'One is deliberate and communicative, while the other is a short-lived, automatic ventilatory movement.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ef', 'Brow Flash', 'What is the primary social function of the Eyebrow Flash?', 'To signal friendliness, trustworthiness, and non-threatening intent during greetings.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ef', 'Brow Flash', 'How is anger visually different from an Eyebrow Flash?', 'Anger lowers the eyebrows significantly, while an eyebrow flash raises them quickly.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ef', 'Brow Flash', 'What are the two gesture variations of Eyebrow Flash?', 'Ef1 is the brief flash; Ef2 is sustained raising of the eyebrows.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ef', 'Brow Flash', 'What unconscious behavior often follows seeing an eyebrow flash?', 'The receiver often unconsciously returns the eyebrow flash.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ef', 'Brow Flash', 'What does a constant raised eyebrow signal if not friendly intent?', 'It may indicate anger, fear, or emphasis of a serious point.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hd', 'Downcast', 'What emotions does the Head Downcast gesture typically convey?', 'Shame, guilt, submission, and sometimes internal anger.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hd', 'Downcast', 'How can Head Downcast behavior vary by context?', 'It may also signal flirtation or courtship when used by women in social settings.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hd', 'Downcast', 'What group frequently exhibits the Head Downcast behavior?', 'Abused spouses, bullied children, and victims of trauma often display it.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hd', 'Downcast', 'Is Head Downcast considered a vulnerable or aggressive gesture?', 'It is typically considered vulnerable and submissive.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hd', 'Downcast', 'How does this behavior affect perception in interviews?', 'It may indicate psychological discomfort, low self-esteem, or an attempt to avoid confrontation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lc', 'Lip Compress', 'What does the Lip Compress 6 behavior typically indicate?', 'The Lip Compress 6 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lc', 'Lip Compress', 'When might Lip Compress 6 appear during an interview?', 'Lip Compress 6 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lc', 'Lip Compress', 'What body region is primarily involved in Lip Compress 6?', 'Lip Compress 6 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lc', 'Lip Compress', 'How does Lip Compress 6 relate to deception detection?', 'Lip Compress 6 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lc', 'Lip Compress', 'What is one conflicting or amplifying behavior for Lip Compress 6?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Lip Compress 6 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ts', 'Teeth Suck', 'What does the Teeth Suck 7 behavior typically indicate?', 'The Teeth Suck 7 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ts', 'Teeth Suck', 'When might Teeth Suck 7 appear during an interview?', 'Teeth Suck 7 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ts', 'Teeth Suck', 'What body region is primarily involved in Teeth Suck 7?', 'Teeth Suck 7 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ts', 'Teeth Suck', 'How does Teeth Suck 7 relate to deception detection?', 'Teeth Suck 7 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ts', 'Teeth Suck', 'What is one conflicting or amplifying behavior for Teeth Suck 7?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Teeth Suck 7 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tu', 'Turtling', 'What does the Turtling 8 behavior typically indicate?', 'The Turtling 8 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tu', 'Turtling', 'When might Turtling 8 appear during an interview?', 'Turtling 8 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tu', 'Turtling', 'What body region is primarily involved in Turtling 8?', 'Turtling 8 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tu', 'Turtling', 'How does Turtling 8 relate to deception detection?', 'Turtling 8 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tu', 'Turtling', 'What is one conflicting or amplifying behavior for Turtling 8?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Turtling 8 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Om', 'Object Mouth', 'What does the Object Mouth 9 behavior typically indicate?', 'The Object Mouth 9 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Om', 'Object Mouth', 'When might Object Mouth 9 appear during an interview?', 'Object Mouth 9 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Om', 'Object Mouth', 'What body region is primarily involved in Object Mouth 9?', 'Object Mouth 9 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Om', 'Object Mouth', 'How does Object Mouth 9 relate to deception detection?', 'Object Mouth 9 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Om', 'Object Mouth', 'What is one conflicting or amplifying behavior for Object Mouth 9?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Object Mouth 9 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jc', 'Jaw clench', 'What does the Jaw clench 10 behavior typically indicate?', 'The Jaw clench 10 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jc', 'Jaw clench', 'When might Jaw clench 10 appear during an interview?', 'Jaw clench 10 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jc', 'Jaw clench', 'What body region is primarily involved in Jaw clench 10?', 'Jaw clench 10 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jc', 'Jaw clench', 'How does Jaw clench 10 relate to deception detection?', 'Jaw clench 10 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jc', 'Jaw clench', 'What is one conflicting or amplifying behavior for Jaw clench 10?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Jaw clench 10 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wd', 'Wing Dilation', 'What does the Wing Dilation 11 behavior typically indicate?', 'The Wing Dilation 11 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wd', 'Wing Dilation', 'When might Wing Dilation 11 appear during an interview?', 'Wing Dilation 11 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wd', 'Wing Dilation', 'What body region is primarily involved in Wing Dilation 11?', 'Wing Dilation 11 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wd', 'Wing Dilation', 'How does Wing Dilation 11 relate to deception detection?', 'Wing Dilation 11 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wd', 'Wing Dilation', 'What is one conflicting or amplifying behavior for Wing Dilation 11?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Wing Dilation 11 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cg', 'Confirmation Glance', 'What does the Confirmation Glance 12 behavior typically indicate?', 'The Confirmation Glance 12 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cg', 'Confirmation Glance', 'When might Confirmation Glance 12 appear during an interview?', 'Confirmation Glance 12 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cg', 'Confirmation Glance', 'What body region is primarily involved in Confirmation Glance 12?', 'Confirmation Glance 12 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cg', 'Confirmation Glance', 'How does Confirmation Glance 12 relate to deception detection?', 'Confirmation Glance 12 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cg', 'Confirmation Glance', 'What is one conflicting or amplifying behavior for Confirmation Glance 12?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Confirmation Glance 12 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Yn', 'Yawn', 'What does the Yawn 13 behavior typically indicate?', 'The Yawn 13 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Yn', 'Yawn', 'When might Yawn 13 appear during an interview?', 'Yawn 13 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Yn', 'Yawn', 'What body region is primarily involved in Yawn 13?', 'Yawn 13 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Yn', 'Yawn', 'How does Yawn 13 relate to deception detection?', 'Yawn 13 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Yn', 'Yawn', 'What is one conflicting or amplifying behavior for Yawn 13?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Yawn 13 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ha', 'Happiness', 'What does the Happiness 14 behavior typically indicate?', 'The Happiness 14 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ha', 'Happiness', 'When might Happiness 14 appear during an interview?', 'Happiness 14 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ha', 'Happiness', 'What body region is primarily involved in Happiness 14?', 'Happiness 14 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ha', 'Happiness', 'How does Happiness 14 relate to deception detection?', 'Happiness 14 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ha', 'Happiness', 'What is one conflicting or amplifying behavior for Happiness 14?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Happiness 14 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fl', 'Flushing', 'What does the Flushing 15 behavior typically indicate?', 'The Flushing 15 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fl', 'Flushing', 'When might Flushing 15 appear during an interview?', 'Flushing 15 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fl', 'Flushing', 'What body region is primarily involved in Flushing 15?', 'Flushing 15 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fl', 'Flushing', 'How does Flushing 15 relate to deception detection?', 'Flushing 15 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fl', 'Flushing', 'What is one conflicting or amplifying behavior for Flushing 15?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Flushing 15 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hb', 'Head Back', 'What does the Head Back 16 behavior typically indicate?', 'The Head Back 16 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hb', 'Head Back', 'When might Head Back 16 appear during an interview?', 'Head Back 16 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hb', 'Head Back', 'What body region is primarily involved in Head Back 16?', 'Head Back 16 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hb', 'Head Back', 'How does Head Back 16 relate to deception detection?', 'Head Back 16 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hb', 'Head Back', 'What is one conflicting or amplifying behavior for Head Back 16?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Head Back 16 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lr', 'Lip retraction', 'What does the Lip retraction 17 behavior typically indicate?', 'The Lip retraction 17 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lr', 'Lip retraction', 'When might Lip retraction 17 appear during an interview?', 'Lip retraction 17 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lr', 'Lip retraction', 'What body region is primarily involved in Lip retraction 17?', 'Lip retraction 17 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lr', 'Lip retraction', 'How does Lip retraction 17 relate to deception detection?', 'Lip retraction 17 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lr', 'Lip retraction', 'What is one conflicting or amplifying behavior for Lip retraction 17?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Lip retraction 17 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ot', 'Orbit Tension', 'What does the Orbit Tension 18 behavior typically indicate?', 'The Orbit Tension 18 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ot', 'Orbit Tension', 'When might Orbit Tension 18 appear during an interview?', 'Orbit Tension 18 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ot', 'Orbit Tension', 'What body region is primarily involved in Orbit Tension 18?', 'Orbit Tension 18 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ot', 'Orbit Tension', 'How does Orbit Tension 18 relate to deception detection?', 'Orbit Tension 18 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ot', 'Orbit Tension', 'What is one conflicting or amplifying behavior for Orbit Tension 18?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Orbit Tension 18 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bn', 'Eye Brow Narrow', 'What does the Eye Brow Narrow 19 behavior typically indicate?', 'The Eye Brow Narrow 19 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bn', 'Eye Brow Narrow', 'When might Eye Brow Narrow 19 appear during an interview?', 'Eye Brow Narrow 19 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bn', 'Eye Brow Narrow', 'What body region is primarily involved in Eye Brow Narrow 19?', 'Eye Brow Narrow 19 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bn', 'Eye Brow Narrow', 'How does Eye Brow Narrow 19 relate to deception detection?', 'Eye Brow Narrow 19 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bn', 'Eye Brow Narrow', 'What is one conflicting or amplifying behavior for Eye Brow Narrow 19?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Eye Brow Narrow 19 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Vh', 'Ventilation', 'What does the Ventilation 20 behavior typically indicate?', 'The Ventilation 20 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Vh', 'Ventilation', 'When might Ventilation 20 appear during an interview?', 'Ventilation 20 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Vh', 'Ventilation', 'What body region is primarily involved in Ventilation 20?', 'Ventilation 20 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Vh', 'Ventilation', 'How does Ventilation 20 relate to deception detection?', 'Ventilation 20 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Vh', 'Ventilation', 'What is one conflicting or amplifying behavior for Ventilation 20?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Ventilation 20 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Aa', 'Adams Apple', 'What does the Adams Apple 21 behavior typically indicate?', 'The Adams Apple 21 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Aa', 'Adams Apple', 'When might Adams Apple 21 appear during an interview?', 'Adams Apple 21 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Aa', 'Adams Apple', 'What body region is primarily involved in Adams Apple 21?', 'Adams Apple 21 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Aa', 'Adams Apple', 'How does Adams Apple 21 relate to deception detection?', 'Adams Apple 21 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Aa', 'Adams Apple', 'What is one conflicting or amplifying behavior for Adams Apple 21?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Adams Apple 21 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gg', 'Guiding', 'What does the Guiding 22 behavior typically indicate?', 'The Guiding 22 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gg', 'Guiding', 'When might Guiding 22 appear during an interview?', 'Guiding 22 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gg', 'Guiding', 'What body region is primarily involved in Guiding 22?', 'Guiding 22 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gg', 'Guiding', 'How does Guiding 22 relate to deception detection?', 'Guiding 22 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gg', 'Guiding', 'What is one conflicting or amplifying behavior for Guiding 22?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Guiding 22 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bg', 'Baton', 'What does the Baton 23 behavior typically indicate?', 'The Baton 23 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bg', 'Baton', 'When might Baton 23 appear during an interview?', 'Baton 23 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bg', 'Baton', 'What body region is primarily involved in Baton 23?', 'Baton 23 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bg', 'Baton', 'How does Baton 23 relate to deception detection?', 'Baton 23 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bg', 'Baton', 'What is one conflicting or amplifying behavior for Baton 23?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Baton 23 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ye', 'Vertical Shake', 'What does the Vertical Shake 24 behavior typically indicate?', 'The Vertical Shake 24 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ye', 'Vertical Shake', 'When might Vertical Shake 24 appear during an interview?', 'Vertical Shake 24 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ye', 'Vertical Shake', 'What body region is primarily involved in Vertical Shake 24?', 'Vertical Shake 24 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ye', 'Vertical Shake', 'How does Vertical Shake 24 relate to deception detection?', 'Vertical Shake 24 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ye', 'Vertical Shake', 'What is one conflicting or amplifying behavior for Vertical Shake 24?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Vertical Shake 24 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hs', 'Head Sup', 'What does the Head Sup 25 behavior typically indicate?', 'The Head Sup 25 behavior usually reflects a specific emotional or behavioral state based on context and posture.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hs', 'Head Sup', 'When might Head Sup 25 appear during an interview?', 'Head Sup 25 often appears when the subject is responding to stress, deception, or emotional triggers.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hs', 'Head Sup', 'What body region is primarily involved in Head Sup 25?', 'Head Sup 25 usually involves the head, hands, shoulders, or torso depending on its classification in the BToE.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hs', 'Head Sup', 'How does Head Sup 25 relate to deception detection?', 'Head Sup 25 is rated on the Deception Scale and can support analysis when grouped with other high-rated behaviors.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hs', 'Head Sup', 'What is one conflicting or amplifying behavior for Head Sup 25?', 'A conflicting or amplifying gesture may reinforce or contradict the meaning of Head Sup 25 in context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sp', 'Suprise', 'What does the Suprise 26 gesture typically represent?', 'The Suprise 26 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sp', 'Suprise', 'In what context is Suprise 26 most likely to appear?', 'Suprise 26 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sp', 'Suprise', 'How is Suprise 26 identified in the BToE?', 'Suprise 26 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sp', 'Suprise', 'What should be considered when evaluating Suprise 26?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Suprise 26 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sp', 'Suprise', 'What might contradict or confirm Suprise 26?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Suprise 26.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Br', 'Blink Rate', 'What does the Blink Rate 27 gesture typically represent?', 'The Blink Rate 27 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Br', 'Blink Rate', 'In what context is Blink Rate 27 most likely to appear?', 'Blink Rate 27 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Br', 'Blink Rate', 'How is Blink Rate 27 identified in the BToE?', 'Blink Rate 27 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Br', 'Blink Rate', 'What should be considered when evaluating Blink Rate 27?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Blink Rate 27 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Br', 'Blink Rate', 'What might contradict or confirm Blink Rate 27?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Blink Rate 27.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pd', 'Pupil Dilation', 'What does the Pupil Dilation 28 gesture typically represent?', 'The Pupil Dilation 28 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pd', 'Pupil Dilation', 'In what context is Pupil Dilation 28 most likely to appear?', 'Pupil Dilation 28 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pd', 'Pupil Dilation', 'How is Pupil Dilation 28 identified in the BToE?', 'Pupil Dilation 28 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pd', 'Pupil Dilation', 'What should be considered when evaluating Pupil Dilation 28?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Pupil Dilation 28 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pd', 'Pupil Dilation', 'What might contradict or confirm Pupil Dilation 28?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Pupil Dilation 28.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sq', 'Squint', 'What does the Squint 29 gesture typically represent?', 'The Squint 29 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sq', 'Squint', 'In what context is Squint 29 most likely to appear?', 'Squint 29 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sq', 'Squint', 'How is Squint 29 identified in the BToE?', 'Squint 29 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sq', 'Squint', 'What should be considered when evaluating Squint 29?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Squint 29 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sq', 'Squint', 'What might contradict or confirm Squint 29?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Squint 29.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sh', 'Shrug', 'What does the Shrug 30 gesture typically represent?', 'The Shrug 30 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sh', 'Shrug', 'In what context is Shrug 30 most likely to appear?', 'Shrug 30 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sh', 'Shrug', 'How is Shrug 30 identified in the BToE?', 'Shrug 30 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sh', 'Shrug', 'What should be considered when evaluating Shrug 30?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Shrug 30 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sh', 'Shrug', 'What might contradict or confirm Shrug 30?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Shrug 30.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sa', 'Sadness', 'What does the Sadness 31 gesture typically represent?', 'The Sadness 31 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sa', 'Sadness', 'In what context is Sadness 31 most likely to appear?', 'Sadness 31 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sa', 'Sadness', 'How is Sadness 31 identified in the BToE?', 'Sadness 31 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sa', 'Sadness', 'What should be considered when evaluating Sadness 31?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Sadness 31 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sa', 'Sadness', 'What might contradict or confirm Sadness 31?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Sadness 31.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Dg', 'Disgust', 'What does the Disgust 32 gesture typically represent?', 'The Disgust 32 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Dg', 'Disgust', 'In what context is Disgust 32 most likely to appear?', 'Disgust 32 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Dg', 'Disgust', 'How is Disgust 32 identified in the BToE?', 'Disgust 32 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Dg', 'Disgust', 'What should be considered when evaluating Disgust 32?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Disgust 32 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Dg', 'Disgust', 'What might contradict or confirm Disgust 32?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Disgust 32.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fr', 'Fear', 'What does the Fear 33 gesture typically represent?', 'The Fear 33 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fr', 'Fear', 'In what context is Fear 33 most likely to appear?', 'Fear 33 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fr', 'Fear', 'How is Fear 33 identified in the BToE?', 'Fear 33 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fr', 'Fear', 'What should be considered when evaluating Fear 33?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Fear 33 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fr', 'Fear', 'What might contradict or confirm Fear 33?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Fear 33.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Co', 'Contempt', 'What does the Contempt 34 gesture typically represent?', 'The Contempt 34 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Co', 'Contempt', 'In what context is Contempt 34 most likely to appear?', 'Contempt 34 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Co', 'Contempt', 'How is Contempt 34 identified in the BToE?', 'Contempt 34 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Co', 'Contempt', 'What should be considered when evaluating Contempt 34?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Contempt 34 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Co', 'Contempt', 'What might contradict or confirm Contempt 34?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Contempt 34.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ag', 'Anger', 'What does the Anger 35 gesture typically represent?', 'The Anger 35 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ag', 'Anger', 'In what context is Anger 35 most likely to appear?', 'Anger 35 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ag', 'Anger', 'How is Anger 35 identified in the BToE?', 'Anger 35 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ag', 'Anger', 'What should be considered when evaluating Anger 35?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Anger 35 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ag', 'Anger', 'What might contradict or confirm Anger 35?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Anger 35.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pr', 'Protecting', 'What does the Protecting 36 gesture typically represent?', 'The Protecting 36 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pr', 'Protecting', 'In what context is Protecting 36 most likely to appear?', 'Protecting 36 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pr', 'Protecting', 'How is Protecting 36 identified in the BToE?', 'Protecting 36 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pr', 'Protecting', 'What should be considered when evaluating Protecting 36?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Protecting 36 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pr', 'Protecting', 'What might contradict or confirm Protecting 36?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Protecting 36.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sw', 'Swallow', 'What does the Swallow 37 gesture typically represent?', 'The Swallow 37 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sw', 'Swallow', 'In what context is Swallow 37 most likely to appear?', 'Swallow 37 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sw', 'Swallow', 'How is Swallow 37 identified in the BToE?', 'Swallow 37 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sw', 'Swallow', 'What should be considered when evaluating Swallow 37?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Swallow 37 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sw', 'Swallow', 'What might contradict or confirm Swallow 37?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Swallow 37.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ec', 'Elbow Close', 'What does the Elbow Close 38 gesture typically represent?', 'The Elbow Close 38 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ec', 'Elbow Close', 'In what context is Elbow Close 38 most likely to appear?', 'Elbow Close 38 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ec', 'Elbow Close', 'How is Elbow Close 38 identified in the BToE?', 'Elbow Close 38 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ec', 'Elbow Close', 'What should be considered when evaluating Elbow Close 38?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Elbow Close 38 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ec', 'Elbow Close', 'What might contradict or confirm Elbow Close 38?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Elbow Close 38.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ss', 'Single Shrug', 'What does the Single Shrug 39 gesture typically represent?', 'The Single Shrug 39 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ss', 'Single Shrug', 'In what context is Single Shrug 39 most likely to appear?', 'Single Shrug 39 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ss', 'Single Shrug', 'How is Single Shrug 39 identified in the BToE?', 'Single Shrug 39 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ss', 'Single Shrug', 'What should be considered when evaluating Single Shrug 39?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Single Shrug 39 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ss', 'Single Shrug', 'What might contradict or confirm Single Shrug 39?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Single Shrug 39.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('De', 'Digit Extension', 'What does the Digit Extension 40 gesture typically represent?', 'The Digit Extension 40 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('De', 'Digit Extension', 'In what context is Digit Extension 40 most likely to appear?', 'Digit Extension 40 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('De', 'Digit Extension', 'How is Digit Extension 40 identified in the BToE?', 'Digit Extension 40 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('De', 'Digit Extension', 'What should be considered when evaluating Digit Extension 40?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Digit Extension 40 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('De', 'Digit Extension', 'What might contradict or confirm Digit Extension 40?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Digit Extension 40.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pe', 'Palm Exposed', 'What does the Palm Exposed 41 gesture typically represent?', 'The Palm Exposed 41 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pe', 'Palm Exposed', 'In what context is Palm Exposed 41 most likely to appear?', 'Palm Exposed 41 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pe', 'Palm Exposed', 'How is Palm Exposed 41 identified in the BToE?', 'Palm Exposed 41 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pe', 'Palm Exposed', 'What should be considered when evaluating Palm Exposed 41?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Palm Exposed 41 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pe', 'Palm Exposed', 'What might contradict or confirm Palm Exposed 41?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Palm Exposed 41.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cs', 'Chin Stroke', 'What does the Chin Stroke 42 gesture typically represent?', 'The Chin Stroke 42 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cs', 'Chin Stroke', 'In what context is Chin Stroke 42 most likely to appear?', 'Chin Stroke 42 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cs', 'Chin Stroke', 'How is Chin Stroke 42 identified in the BToE?', 'Chin Stroke 42 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cs', 'Chin Stroke', 'What should be considered when evaluating Chin Stroke 42?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Chin Stroke 42 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cs', 'Chin Stroke', 'What might contradict or confirm Chin Stroke 42?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Chin Stroke 42.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pc', 'Pupil Constriction', 'What does the Pupil Constriction 43 gesture typically represent?', 'The Pupil Constriction 43 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pc', 'Pupil Constriction', 'In what context is Pupil Constriction 43 most likely to appear?', 'Pupil Constriction 43 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pc', 'Pupil Constriction', 'How is Pupil Constriction 43 identified in the BToE?', 'Pupil Constriction 43 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pc', 'Pupil Constriction', 'What should be considered when evaluating Pupil Constriction 43?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Pupil Constriction 43 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pc', 'Pupil Constriction', 'What might contradict or confirm Pupil Constriction 43?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Pupil Constriction 43.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Eo', 'Elbow Out', 'What does the Elbow Out 44 gesture typically represent?', 'The Elbow Out 44 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Eo', 'Elbow Out', 'In what context is Elbow Out 44 most likely to appear?', 'Elbow Out 44 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Eo', 'Elbow Out', 'How is Elbow Out 44 identified in the BToE?', 'Elbow Out 44 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Eo', 'Elbow Out', 'What should be considered when evaluating Elbow Out 44?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Elbow Out 44 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Eo', 'Elbow Out', 'What might contradict or confirm Elbow Out 44?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Elbow Out 44.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ps', 'Posture', 'What does the Posture 45 gesture typically represent?', 'The Posture 45 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ps', 'Posture', 'In what context is Posture 45 most likely to appear?', 'Posture 45 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ps', 'Posture', 'How is Posture 45 identified in the BToE?', 'Posture 45 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ps', 'Posture', 'What should be considered when evaluating Posture 45?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Posture 45 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ps', 'Posture', 'What might contradict or confirm Posture 45?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Posture 45.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('No', 'No', 'What does the No 46 gesture typically represent?', 'The No 46 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('No', 'No', 'In what context is No 46 most likely to appear?', 'No 46 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('No', 'No', 'How is No 46 identified in the BToE?', 'No 46 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('No', 'No', 'What should be considered when evaluating No 46?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate No 46 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('No', 'No', 'What might contradict or confirm No 46?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of No 46.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lf', 'Lock Finger', 'What does the Lock Finger 47 gesture typically represent?', 'The Lock Finger 47 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lf', 'Lock Finger', 'In what context is Lock Finger 47 most likely to appear?', 'Lock Finger 47 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lf', 'Lock Finger', 'How is Lock Finger 47 identified in the BToE?', 'Lock Finger 47 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lf', 'Lock Finger', 'What should be considered when evaluating Lock Finger 47?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Lock Finger 47 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lf', 'Lock Finger', 'What might contradict or confirm Lock Finger 47?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Lock Finger 47.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('St', 'Steeple', 'What does the Steeple 48 gesture typically represent?', 'The Steeple 48 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('St', 'Steeple', 'In what context is Steeple 48 most likely to appear?', 'Steeple 48 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('St', 'Steeple', 'How is Steeple 48 identified in the BToE?', 'Steeple 48 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('St', 'Steeple', 'What should be considered when evaluating Steeple 48?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Steeple 48 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('St', 'Steeple', 'What might contradict or confirm Steeple 48?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Steeple 48.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bh', 'Behind Head', 'What does the Behind Head 49 gesture typically represent?', 'The Behind Head 49 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bh', 'Behind Head', 'In what context is Behind Head 49 most likely to appear?', 'Behind Head 49 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bh', 'Behind Head', 'How is Behind Head 49 identified in the BToE?', 'Behind Head 49 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bh', 'Behind Head', 'What should be considered when evaluating Behind Head 49?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Behind Head 49 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bh', 'Behind Head', 'What might contradict or confirm Behind Head 49?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Behind Head 49.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ah', 'Arms-Hips', 'What does the Arms-Hips 50 gesture typically represent?', 'The Arms-Hips 50 gesture represents a specific emotional state or intent based on posture, movement, and context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ah', 'Arms-Hips', 'In what context is Arms-Hips 50 most likely to appear?', 'Arms-Hips 50 appears during interview situations where stress, anxiety, or assertiveness is elevated.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ah', 'Arms-Hips', 'How is Arms-Hips 50 identified in the BToE?', 'Arms-Hips 50 is identified using symbol codes, behavior type, and associated body region on the BToE chart.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ah', 'Arms-Hips', 'What should be considered when evaluating Arms-Hips 50?', 'Factors like cultural background, deception rating, and accompanying gestures help evaluate Arms-Hips 50 accurately.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ah', 'Arms-Hips', 'What might contradict or confirm Arms-Hips 50?', 'Conflicting or confirming gestures from other BToE cells are used to validate the interpretation of Arms-Hips 50.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Shg', 'Self-Hug', 'What emotional signal is usually conveyed by Self-Hug 51?', 'Self-Hug 51 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Shg', 'Self-Hug', 'What are common body cues associated with Self-Hug 51?', 'Self-Hug 51 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Shg', 'Self-Hug', 'Why is Self-Hug 51 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Shg', 'Self-Hug', 'What contextual clues increase the reliability of Self-Hug 51?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Self-Hug 51.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Shg', 'Self-Hug', 'How might Self-Hug 51 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Self-Hug 51 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bb', 'Arms Behind Back', 'What emotional signal is usually conveyed by Arms Behind Back 52?', 'Arms Behind Back 52 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bb', 'Arms Behind Back', 'What are common body cues associated with Arms Behind Back 52?', 'Arms Behind Back 52 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bb', 'Arms Behind Back', 'Why is Arms Behind Back 52 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bb', 'Arms Behind Back', 'What contextual clues increase the reliability of Arms Behind Back 52?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Arms Behind Back 52.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bb', 'Arms Behind Back', 'How might Arms Behind Back 52 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Arms Behind Back 52 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cr', 'Const Raise', 'What emotional signal is usually conveyed by Const Raise 53?', 'Const Raise 53 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cr', 'Const Raise', 'What are common body cues associated with Const Raise 53?', 'Const Raise 53 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cr', 'Const Raise', 'Why is Const Raise 53 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cr', 'Const Raise', 'What contextual clues increase the reliability of Const Raise 53?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Const Raise 53.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cr', 'Const Raise', 'How might Const Raise 53 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Const Raise 53 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wp', 'Single Wrap', 'What emotional signal is usually conveyed by Single Wrap 54?', 'Single Wrap 54 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wp', 'Single Wrap', 'What are common body cues associated with Single Wrap 54?', 'Single Wrap 54 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wp', 'Single Wrap', 'Why is Single Wrap 54 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wp', 'Single Wrap', 'What contextual clues increase the reliability of Single Wrap 54?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Single Wrap 54.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wp', 'Single Wrap', 'How might Single Wrap 54 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Single Wrap 54 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fz', 'Freeze', 'What emotional signal is usually conveyed by Freeze 55?', 'Freeze 55 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fz', 'Freeze', 'What are common body cues associated with Freeze 55?', 'Freeze 55 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fz', 'Freeze', 'Why is Freeze 55 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fz', 'Freeze', 'What contextual clues increase the reliability of Freeze 55?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Freeze 55.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fz', 'Freeze', 'How might Freeze 55 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Freeze 55 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ft', 'Facial Touch', 'What emotional signal is usually conveyed by Facial Touch 56?', 'Facial Touch 56 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ft', 'Facial Touch', 'What are common body cues associated with Facial Touch 56?', 'Facial Touch 56 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ft', 'Facial Touch', 'Why is Facial Touch 56 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ft', 'Facial Touch', 'What contextual clues increase the reliability of Facial Touch 56?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Facial Touch 56.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ft', 'Facial Touch', 'How might Facial Touch 56 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Facial Touch 56 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ttc', 'Throat Clasp', 'What emotional signal is usually conveyed by Throat Clasp 57?', 'Throat Clasp 57 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ttc', 'Throat Clasp', 'What are common body cues associated with Throat Clasp 57?', 'Throat Clasp 57 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ttc', 'Throat Clasp', 'Why is Throat Clasp 57 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ttc', 'Throat Clasp', 'What contextual clues increase the reliability of Throat Clasp 57?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Throat Clasp 57.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ttc', 'Throat Clasp', 'How might Throat Clasp 57 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Throat Clasp 57 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ia', 'Arms In Air', 'What emotional signal is usually conveyed by Arms In Air 58?', 'Arms In Air 58 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ia', 'Arms In Air', 'What are common body cues associated with Arms In Air 58?', 'Arms In Air 58 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ia', 'Arms In Air', 'Why is Arms In Air 58 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ia', 'Arms In Air', 'What contextual clues increase the reliability of Arms In Air 58?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Arms In Air 58.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ia', 'Arms In Air', 'How might Arms In Air 58 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Arms In Air 58 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fig.4', '4', 'What emotional signal is usually conveyed by 4 59?', '4 59 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fig.4', '4', 'What are common body cues associated with 4 59?', '4 59 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fig.4', '4', 'Why is 4 59 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fig.4', '4', 'What contextual clues increase the reliability of 4 59?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting 4 59.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fig.4', '4', 'How might 4 59 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how 4 59 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tlt', 'Tilt', 'What emotional signal is usually conveyed by Tilt 60?', 'Tilt 60 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tlt', 'Tilt', 'What are common body cues associated with Tilt 60?', 'Tilt 60 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tlt', 'Tilt', 'Why is Tilt 60 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tlt', 'Tilt', 'What contextual clues increase the reliability of Tilt 60?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Tilt 60.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tlt', 'Tilt', 'How might Tilt 60 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Tilt 60 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ff', 'Facing', 'What emotional signal is usually conveyed by Facing 61?', 'Facing 61 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ff', 'Facing', 'What are common body cues associated with Facing 61?', 'Facing 61 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ff', 'Facing', 'Why is Facing 61 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ff', 'Facing', 'What contextual clues increase the reliability of Facing 61?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Facing 61.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ff', 'Facing', 'How might Facing 61 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Facing 61 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Po', 'Pockets', 'What emotional signal is usually conveyed by Pockets 62?', 'Pockets 62 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Po', 'Pockets', 'What are common body cues associated with Pockets 62?', 'Pockets 62 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Po', 'Pockets', 'Why is Pockets 62 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Po', 'Pockets', 'What contextual clues increase the reliability of Pockets 62?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Pockets 62.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Po', 'Pockets', 'How might Pockets 62 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Pockets 62 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tch', 'Chest Touch', 'What emotional signal is usually conveyed by Chest Touch 63?', 'Chest Touch 63 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tch', 'Chest Touch', 'What are common body cues associated with Chest Touch 63?', 'Chest Touch 63 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tch', 'Chest Touch', 'Why is Chest Touch 63 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tch', 'Chest Touch', 'What contextual clues increase the reliability of Chest Touch 63?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Chest Touch 63.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tch', 'Chest Touch', 'How might Chest Touch 63 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Chest Touch 63 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('DC', 'Double Cross', 'What emotional signal is usually conveyed by Double Cross 64?', 'Double Cross 64 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('DC', 'Double Cross', 'What are common body cues associated with Double Cross 64?', 'Double Cross 64 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('DC', 'Double Cross', 'Why is Double Cross 64 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('DC', 'Double Cross', 'What contextual clues increase the reliability of Double Cross 64?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Double Cross 64.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('DC', 'Double Cross', 'How might Double Cross 64 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Double Cross 64 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tp', 'Tapping', 'What emotional signal is usually conveyed by Tapping 65?', 'Tapping 65 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tp', 'Tapping', 'What are common body cues associated with Tapping 65?', 'Tapping 65 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tp', 'Tapping', 'Why is Tapping 65 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tp', 'Tapping', 'What contextual clues increase the reliability of Tapping 65?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Tapping 65.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Tp', 'Tapping', 'How might Tapping 65 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Tapping 65 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fi', 'Fidgeting', 'What emotional signal is usually conveyed by Fidgeting 66?', 'Fidgeting 66 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fi', 'Fidgeting', 'What are common body cues associated with Fidgeting 66?', 'Fidgeting 66 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fi', 'Fidgeting', 'Why is Fidgeting 66 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fi', 'Fidgeting', 'What contextual clues increase the reliability of Fidgeting 66?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Fidgeting 66.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fi', 'Fidgeting', 'How might Fidgeting 66 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Fidgeting 66 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Grs', 'Grasping x2', 'What emotional signal is usually conveyed by Grasping x2 67?', 'Grasping x2 67 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Grs', 'Grasping x2', 'What are common body cues associated with Grasping x2 67?', 'Grasping x2 67 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Grs', 'Grasping x2', 'Why is Grasping x2 67 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Grs', 'Grasping x2', 'What contextual clues increase the reliability of Grasping x2 67?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Grasping x2 67.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Grs', 'Grasping x2', 'How might Grasping x2 67 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Grasping x2 67 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bon', 'Back of Neck', 'What emotional signal is usually conveyed by Back of Neck 68?', 'Back of Neck 68 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bon', 'Back of Neck', 'What are common body cues associated with Back of Neck 68?', 'Back of Neck 68 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bon', 'Back of Neck', 'Why is Back of Neck 68 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bon', 'Back of Neck', 'What contextual clues increase the reliability of Back of Neck 68?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Back of Neck 68.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bon', 'Back of Neck', 'How might Back of Neck 68 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Back of Neck 68 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lp', 'Lint Picking', 'What emotional signal is usually conveyed by Lint Picking 69?', 'Lint Picking 69 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lp', 'Lint Picking', 'What are common body cues associated with Lint Picking 69?', 'Lint Picking 69 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lp', 'Lint Picking', 'Why is Lint Picking 69 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lp', 'Lint Picking', 'What contextual clues increase the reliability of Lint Picking 69?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Lint Picking 69.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lp', 'Lint Picking', 'How might Lint Picking 69 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Lint Picking 69 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wf', 'Wrist-forehead', 'What emotional signal is usually conveyed by Wrist-forehead 70?', 'Wrist-forehead 70 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wf', 'Wrist-forehead', 'What are common body cues associated with Wrist-forehead 70?', 'Wrist-forehead 70 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wf', 'Wrist-forehead', 'Why is Wrist-forehead 70 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wf', 'Wrist-forehead', 'What contextual clues increase the reliability of Wrist-forehead 70?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Wrist-forehead 70.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wf', 'Wrist-forehead', 'How might Wrist-forehead 70 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Wrist-forehead 70 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bar', 'Barrier', 'What emotional signal is usually conveyed by Barrier 71?', 'Barrier 71 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bar', 'Barrier', 'What are common body cues associated with Barrier 71?', 'Barrier 71 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bar', 'Barrier', 'Why is Barrier 71 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bar', 'Barrier', 'What contextual clues increase the reliability of Barrier 71?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Barrier 71.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bar', 'Barrier', 'How might Barrier 71 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Barrier 71 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bc', 'Barrier Cross', 'What emotional signal is usually conveyed by Barrier Cross 72?', 'Barrier Cross 72 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bc', 'Barrier Cross', 'What are common body cues associated with Barrier Cross 72?', 'Barrier Cross 72 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bc', 'Barrier Cross', 'Why is Barrier Cross 72 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bc', 'Barrier Cross', 'What contextual clues increase the reliability of Barrier Cross 72?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Barrier Cross 72.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bc', 'Barrier Cross', 'How might Barrier Cross 72 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Barrier Cross 72 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pdn', 'Palms Down', 'What emotional signal is usually conveyed by Palms Down 73?', 'Palms Down 73 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pdn', 'Palms Down', 'What are common body cues associated with Palms Down 73?', 'Palms Down 73 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pdn', 'Palms Down', 'Why is Palms Down 73 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pdn', 'Palms Down', 'What contextual clues increase the reliability of Palms Down 73?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Palms Down 73.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pdn', 'Palms Down', 'How might Palms Down 73 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Palms Down 73 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gpr', 'Genital Pr?', 'What emotional signal is usually conveyed by Genital Pr? 74?', 'Genital Pr? 74 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gpr', 'Genital Pr?', 'What are common body cues associated with Genital Pr? 74?', 'Genital Pr? 74 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gpr', 'Genital Pr?', 'Why is Genital Pr? 74 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gpr', 'Genital Pr?', 'What contextual clues increase the reliability of Genital Pr? 74?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Genital Pr? 74.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gpr', 'Genital Pr?', 'How might Genital Pr? 74 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Genital Pr? 74 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hu', 'Hushing', 'What emotional signal is usually conveyed by Hushing 75?', 'Hushing 75 typically reflects emotions such as fear, confidence, doubt, or submission depending on context.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hu', 'Hushing', 'What are common body cues associated with Hushing 75?', 'Hushing 75 may involve posture, hand position, facial expressions, or limb placement as observable cues.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hu', 'Hushing', 'Why is Hushing 75 important in behavioral analysis?', 'It serves as an indicator of a subject''s internal emotional state, useful during interviews and interrogations.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hu', 'Hushing', 'What contextual clues increase the reliability of Hushing 75?', 'Co-occurring behaviors, timing in the deception phase, and cultural norms enhance the accuracy of interpreting Hushing 75.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hu', 'Hushing', 'How might Hushing 75 vary across individuals?', 'Physical condition, cultural habits, or psychological state can influence how Hushing 75 is displayed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ge', 'Groin Expose', 'What is a common interpretation of Groin Expose 76 behavior?', 'Groin Expose 76 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ge', 'Groin Expose', 'When observed in interviews, what does Groin Expose 76 suggest?', 'Groin Expose 76 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ge', 'Groin Expose', 'What is the significance of posture or motion in Groin Expose 76?', 'Postural alignment and motion in Groin Expose 76 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ge', 'Groin Expose', 'Which deception timeframe best captures Groin Expose 76?', 'Depending on context, Groin Expose 76 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ge', 'Groin Expose', 'What environmental or internal factors affect Groin Expose 76?', 'Room temperature, emotional state, or proximity can all alter how Groin Expose 76 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lg', 'Leg Crossing', 'What is a common interpretation of Leg Crossing 77 behavior?', 'Leg Crossing 77 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lg', 'Leg Crossing', 'When observed in interviews, what does Leg Crossing 77 suggest?', 'Leg Crossing 77 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lg', 'Leg Crossing', 'What is the significance of posture or motion in Leg Crossing 77?', 'Postural alignment and motion in Leg Crossing 77 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lg', 'Leg Crossing', 'Which deception timeframe best captures Leg Crossing 77?', 'Depending on context, Leg Crossing 77 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Lg', 'Leg Crossing', 'What environmental or internal factors affect Leg Crossing 77?', 'Room temperature, emotional state, or proximity can all alter how Leg Crossing 77 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Agg', 'Toes Up', 'What is a common interpretation of Toes Up 78 behavior?', 'Toes Up 78 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Agg', 'Toes Up', 'When observed in interviews, what does Toes Up 78 suggest?', 'Toes Up 78 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Agg', 'Toes Up', 'What is the significance of posture or motion in Toes Up 78?', 'Postural alignment and motion in Toes Up 78 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Agg', 'Toes Up', 'Which deception timeframe best captures Toes Up 78?', 'Depending on context, Toes Up 78 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Agg', 'Toes Up', 'What environmental or internal factors affect Toes Up 78?', 'Room temperature, emotional state, or proximity can all alter how Toes Up 78 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bre', 'Breath Rate', 'What is a common interpretation of Breath Rate 79 behavior?', 'Breath Rate 79 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bre', 'Breath Rate', 'When observed in interviews, what does Breath Rate 79 suggest?', 'Breath Rate 79 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bre', 'Breath Rate', 'What is the significance of posture or motion in Breath Rate 79?', 'Postural alignment and motion in Breath Rate 79 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bre', 'Breath Rate', 'Which deception timeframe best captures Breath Rate 79?', 'Depending on context, Breath Rate 79 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bre', 'Breath Rate', 'What environmental or internal factors affect Breath Rate 79?', 'Room temperature, emotional state, or proximity can all alter how Breath Rate 79 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fc', 'Torso Facing', 'What is a common interpretation of Torso Facing 80 behavior?', 'Torso Facing 80 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fc', 'Torso Facing', 'When observed in interviews, what does Torso Facing 80 suggest?', 'Torso Facing 80 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fc', 'Torso Facing', 'What is the significance of posture or motion in Torso Facing 80?', 'Postural alignment and motion in Torso Facing 80 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fc', 'Torso Facing', 'Which deception timeframe best captures Torso Facing 80?', 'Depending on context, Torso Facing 80 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fc', 'Torso Facing', 'What environmental or internal factors affect Torso Facing 80?', 'Room temperature, emotional state, or proximity can all alter how Torso Facing 80 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pt', 'Posture Tilt', 'What is a common interpretation of Posture Tilt 81 behavior?', 'Posture Tilt 81 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pt', 'Posture Tilt', 'When observed in interviews, what does Posture Tilt 81 suggest?', 'Posture Tilt 81 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pt', 'Posture Tilt', 'What is the significance of posture or motion in Posture Tilt 81?', 'Postural alignment and motion in Posture Tilt 81 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pt', 'Posture Tilt', 'Which deception timeframe best captures Posture Tilt 81?', 'Depending on context, Posture Tilt 81 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pt', 'Posture Tilt', 'What environmental or internal factors affect Posture Tilt 81?', 'Room temperature, emotional state, or proximity can all alter how Posture Tilt 81 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kh', 'Knee Hug', 'What is a common interpretation of Knee Hug 82 behavior?', 'Knee Hug 82 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kh', 'Knee Hug', 'When observed in interviews, what does Knee Hug 82 suggest?', 'Knee Hug 82 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kh', 'Knee Hug', 'What is the significance of posture or motion in Knee Hug 82?', 'Postural alignment and motion in Knee Hug 82 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kh', 'Knee Hug', 'Which deception timeframe best captures Knee Hug 82?', 'Depending on context, Knee Hug 82 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kh', 'Knee Hug', 'What environmental or internal factors affect Knee Hug 82?', 'Room temperature, emotional state, or proximity can all alter how Knee Hug 82 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Df', 'Digit Flex', 'What is a common interpretation of Digit Flex 83 behavior?', 'Digit Flex 83 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Df', 'Digit Flex', 'When observed in interviews, what does Digit Flex 83 suggest?', 'Digit Flex 83 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Df', 'Digit Flex', 'What is the significance of posture or motion in Digit Flex 83?', 'Postural alignment and motion in Digit Flex 83 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Df', 'Digit Flex', 'Which deception timeframe best captures Digit Flex 83?', 'Depending on context, Digit Flex 83 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Df', 'Digit Flex', 'What environmental or internal factors affect Digit Flex 83?', 'Room temperature, emotional state, or proximity can all alter how Digit Flex 83 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bi', 'Binding', 'What is a common interpretation of Binding 84 behavior?', 'Binding 84 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bi', 'Binding', 'When observed in interviews, what does Binding 84 suggest?', 'Binding 84 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bi', 'Binding', 'What is the significance of posture or motion in Binding 84?', 'Postural alignment and motion in Binding 84 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bi', 'Binding', 'Which deception timeframe best captures Binding 84?', 'Depending on context, Binding 84 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bi', 'Binding', 'What environmental or internal factors affect Binding 84?', 'Room temperature, emotional state, or proximity can all alter how Binding 84 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('La', 'Lock Ankle', 'What is a common interpretation of Lock Ankle 85 behavior?', 'Lock Ankle 85 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('La', 'Lock Ankle', 'When observed in interviews, what does Lock Ankle 85 suggest?', 'Lock Ankle 85 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('La', 'Lock Ankle', 'What is the significance of posture or motion in Lock Ankle 85?', 'Postural alignment and motion in Lock Ankle 85 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('La', 'Lock Ankle', 'Which deception timeframe best captures Lock Ankle 85?', 'Depending on context, Lock Ankle 85 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('La', 'Lock Ankle', 'What environmental or internal factors affect Lock Ankle 85?', 'Room temperature, emotional state, or proximity can all alter how Lock Ankle 85 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gm', 'Grooming', 'What is a common interpretation of Grooming 86 behavior?', 'Grooming 86 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gm', 'Grooming', 'When observed in interviews, what does Grooming 86 suggest?', 'Grooming 86 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gm', 'Grooming', 'What is the significance of posture or motion in Grooming 86?', 'Postural alignment and motion in Grooming 86 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gm', 'Grooming', 'Which deception timeframe best captures Grooming 86?', 'Depending on context, Grooming 86 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gm', 'Grooming', 'What environmental or internal factors affect Grooming 86?', 'Room temperature, emotional state, or proximity can all alter how Grooming 86 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Thc', 'Thigh Clasp', 'What is a common interpretation of Thigh Clasp 87 behavior?', 'Thigh Clasp 87 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Thc', 'Thigh Clasp', 'When observed in interviews, what does Thigh Clasp 87 suggest?', 'Thigh Clasp 87 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Thc', 'Thigh Clasp', 'What is the significance of posture or motion in Thigh Clasp 87?', 'Postural alignment and motion in Thigh Clasp 87 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Thc', 'Thigh Clasp', 'Which deception timeframe best captures Thigh Clasp 87?', 'Depending on context, Thigh Clasp 87 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Thc', 'Thigh Clasp', 'What environmental or internal factors affect Thigh Clasp 87?', 'Room temperature, emotional state, or proximity can all alter how Thigh Clasp 87 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wt', 'Wrist Touch', 'What is a common interpretation of Wrist Touch 88 behavior?', 'Wrist Touch 88 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wt', 'Wrist Touch', 'When observed in interviews, what does Wrist Touch 88 suggest?', 'Wrist Touch 88 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wt', 'Wrist Touch', 'What is the significance of posture or motion in Wrist Touch 88?', 'Postural alignment and motion in Wrist Touch 88 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wt', 'Wrist Touch', 'Which deception timeframe best captures Wrist Touch 88?', 'Depending on context, Wrist Touch 88 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wt', 'Wrist Touch', 'What environmental or internal factors affect Wrist Touch 88?', 'Room temperature, emotional state, or proximity can all alter how Wrist Touch 88 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ip', 'Inward Toe Point?', 'What is a common interpretation of Inward Toe Point? 89 behavior?', 'Inward Toe Point? 89 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ip', 'Inward Toe Point?', 'When observed in interviews, what does Inward Toe Point? 89 suggest?', 'Inward Toe Point? 89 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ip', 'Inward Toe Point?', 'What is the significance of posture or motion in Inward Toe Point? 89?', 'Postural alignment and motion in Inward Toe Point? 89 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ip', 'Inward Toe Point?', 'Which deception timeframe best captures Inward Toe Point? 89?', 'Depending on context, Inward Toe Point? 89 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ip', 'Inward Toe Point?', 'What environmental or internal factors affect Inward Toe Point? 89?', 'Room temperature, emotional state, or proximity can all alter how Inward Toe Point? 89 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Er', 'Eyelid Rub', 'What is a common interpretation of Eyelid Rub 90 behavior?', 'Eyelid Rub 90 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Er', 'Eyelid Rub', 'When observed in interviews, what does Eyelid Rub 90 suggest?', 'Eyelid Rub 90 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Er', 'Eyelid Rub', 'What is the significance of posture or motion in Eyelid Rub 90?', 'Postural alignment and motion in Eyelid Rub 90 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Er', 'Eyelid Rub', 'Which deception timeframe best captures Eyelid Rub 90?', 'Depending on context, Eyelid Rub 90 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Er', 'Eyelid Rub', 'What environmental or internal factors affect Eyelid Rub 90?', 'Room temperature, emotional state, or proximity can all alter how Eyelid Rub 90 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kc', 'Knee Clasp', 'What is a common interpretation of Knee Clasp 91 behavior?', 'Knee Clasp 91 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kc', 'Knee Clasp', 'When observed in interviews, what does Knee Clasp 91 suggest?', 'Knee Clasp 91 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kc', 'Knee Clasp', 'What is the significance of posture or motion in Knee Clasp 91?', 'Postural alignment and motion in Knee Clasp 91 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kc', 'Knee Clasp', 'Which deception timeframe best captures Knee Clasp 91?', 'Depending on context, Knee Clasp 91 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Kc', 'Knee Clasp', 'What environmental or internal factors affect Knee Clasp 91?', 'Room temperature, emotional state, or proximity can all alter how Knee Clasp 91 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fw', 'Foot Withdraw', 'What is a common interpretation of Foot Withdraw 92 behavior?', 'Foot Withdraw 92 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fw', 'Foot Withdraw', 'When observed in interviews, what does Foot Withdraw 92 suggest?', 'Foot Withdraw 92 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fw', 'Foot Withdraw', 'What is the significance of posture or motion in Foot Withdraw 92?', 'Postural alignment and motion in Foot Withdraw 92 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fw', 'Foot Withdraw', 'Which deception timeframe best captures Foot Withdraw 92?', 'Depending on context, Foot Withdraw 92 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fw', 'Foot Withdraw', 'What environmental or internal factors affect Foot Withdraw 92?', 'Room temperature, emotional state, or proximity can all alter how Foot Withdraw 92 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fns', 'Finger-Nose', 'What is a common interpretation of Finger-Nose 93 behavior?', 'Finger-Nose 93 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fns', 'Finger-Nose', 'When observed in interviews, what does Finger-Nose 93 suggest?', 'Finger-Nose 93 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fns', 'Finger-Nose', 'What is the significance of posture or motion in Finger-Nose 93?', 'Postural alignment and motion in Finger-Nose 93 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fns', 'Finger-Nose', 'Which deception timeframe best captures Finger-Nose 93?', 'Depending on context, Finger-Nose 93 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Fns', 'Finger-Nose', 'What environmental or internal factors affect Finger-Nose 93?', 'Room temperature, emotional state, or proximity can all alter how Finger-Nose 93 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Opi', 'Other''s Property', 'What is a common interpretation of Other''s Property 94 behavior?', 'Other''s Property 94 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Opi', 'Other''s Property', 'When observed in interviews, what does Other''s Property 94 suggest?', 'Other''s Property 94 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Opi', 'Other''s Property', 'What is the significance of posture or motion in Other''s Property 94?', 'Postural alignment and motion in Other''s Property 94 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Opi', 'Other''s Property', 'Which deception timeframe best captures Other''s Property 94?', 'Depending on context, Other''s Property 94 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Opi', 'Other''s Property', 'What environmental or internal factors affect Other''s Property 94?', 'Room temperature, emotional state, or proximity can all alter how Other''s Property 94 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oi', 'Object Insertion', 'What is a common interpretation of Object Insertion 95 behavior?', 'Object Insertion 95 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oi', 'Object Insertion', 'When observed in interviews, what does Object Insertion 95 suggest?', 'Object Insertion 95 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oi', 'Object Insertion', 'What is the significance of posture or motion in Object Insertion 95?', 'Postural alignment and motion in Object Insertion 95 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oi', 'Object Insertion', 'Which deception timeframe best captures Object Insertion 95?', 'Depending on context, Object Insertion 95 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oi', 'Object Insertion', 'What environmental or internal factors affect Object Insertion 95?', 'Room temperature, emotional state, or proximity can all alter how Object Insertion 95 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sr', 'Shoe Removal', 'What is a common interpretation of Shoe Removal 96 behavior?', 'Shoe Removal 96 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sr', 'Shoe Removal', 'When observed in interviews, what does Shoe Removal 96 suggest?', 'Shoe Removal 96 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sr', 'Shoe Removal', 'What is the significance of posture or motion in Shoe Removal 96?', 'Postural alignment and motion in Shoe Removal 96 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sr', 'Shoe Removal', 'Which deception timeframe best captures Shoe Removal 96?', 'Depending on context, Shoe Removal 96 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Sr', 'Shoe Removal', 'What environmental or internal factors affect Shoe Removal 96?', 'Room temperature, emotional state, or proximity can all alter how Shoe Removal 96 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('BeC', 'Belonging Carelessness', 'What is a common interpretation of Belonging Carelessness 97 behavior?', 'Belonging Carelessness 97 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('BeC', 'Belonging Carelessness', 'When observed in interviews, what does Belonging Carelessness 97 suggest?', 'Belonging Carelessness 97 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('BeC', 'Belonging Carelessness', 'What is the significance of posture or motion in Belonging Carelessness 97?', 'Postural alignment and motion in Belonging Carelessness 97 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('BeC', 'Belonging Carelessness', 'Which deception timeframe best captures Belonging Carelessness 97?', 'Depending on context, Belonging Carelessness 97 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('BeC', 'Belonging Carelessness', 'What environmental or internal factors affect Belonging Carelessness 97?', 'Room temperature, emotional state, or proximity can all alter how Belonging Carelessness 97 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wc', 'Watch Check', 'What is a common interpretation of Watch Check 98 behavior?', 'Watch Check 98 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wc', 'Watch Check', 'When observed in interviews, what does Watch Check 98 suggest?', 'Watch Check 98 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wc', 'Watch Check', 'What is the significance of posture or motion in Watch Check 98?', 'Postural alignment and motion in Watch Check 98 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wc', 'Watch Check', 'Which deception timeframe best captures Watch Check 98?', 'Depending on context, Watch Check 98 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Wc', 'Watch Check', 'What environmental or internal factors affect Watch Check 98?', 'Room temperature, emotional state, or proximity can all alter how Watch Check 98 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jb', 'Jacket Button', 'What is a common interpretation of Jacket Button 99 behavior?', 'Jacket Button 99 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jb', 'Jacket Button', 'When observed in interviews, what does Jacket Button 99 suggest?', 'Jacket Button 99 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jb', 'Jacket Button', 'What is the significance of posture or motion in Jacket Button 99?', 'Postural alignment and motion in Jacket Button 99 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jb', 'Jacket Button', 'Which deception timeframe best captures Jacket Button 99?', 'Depending on context, Jacket Button 99 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jb', 'Jacket Button', 'What environmental or internal factors affect Jacket Button 99?', 'Room temperature, emotional state, or proximity can all alter how Jacket Button 99 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cc', 'Covering (pull)', 'What is a common interpretation of Covering (pull) 100 behavior?', 'Covering (pull) 100 behavior often indicates psychological responses such as stress, deception, or dominance.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cc', 'Covering (pull)', 'When observed in interviews, what does Covering (pull) 100 suggest?', 'Covering (pull) 100 suggests a meaningful behavioral cue that should be evaluated in relation to verbal content and timing.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cc', 'Covering (pull)', 'What is the significance of posture or motion in Covering (pull) 100?', 'Postural alignment and motion in Covering (pull) 100 reveal nonverbal intentions and emotional leakage.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cc', 'Covering (pull)', 'Which deception timeframe best captures Covering (pull) 100?', 'Depending on context, Covering (pull) 100 may appear before, during, or after a subject’s verbal response.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cc', 'Covering (pull)', 'What environmental or internal factors affect Covering (pull) 100?', 'Room temperature, emotional state, or proximity can all alter how Covering (pull) 100 is expressed.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ob', 'Object Barrier', 'What key behavior does Object Barrier 101 describe?', 'Object Barrier 101 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ob', 'Object Barrier', 'In what way does Object Barrier 101 assist in deception detection?', 'Object Barrier 101 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ob', 'Object Barrier', 'What observable traits define Object Barrier 101?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ob', 'Object Barrier', 'What factors influence interpretation of Object Barrier 101?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Object Barrier 101''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ob', 'Object Barrier', 'How can Object Barrier 101 be misinterpreted?', 'Object Barrier 101 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ca', 'Chair Arms', 'What key behavior does Chair Arms 102 describe?', 'Chair Arms 102 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ca', 'Chair Arms', 'In what way does Chair Arms 102 assist in deception detection?', 'Chair Arms 102 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ca', 'Chair Arms', 'What observable traits define Chair Arms 102?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ca', 'Chair Arms', 'What factors influence interpretation of Chair Arms 102?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Chair Arms 102''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ca', 'Chair Arms', 'How can Chair Arms 102 be misinterpreted?', 'Chair Arms 102 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gs', 'Groin Shield', 'What key behavior does Groin Shield 103 describe?', 'Groin Shield 103 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gs', 'Groin Shield', 'In what way does Groin Shield 103 assist in deception detection?', 'Groin Shield 103 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gs', 'Groin Shield', 'What observable traits define Groin Shield 103?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gs', 'Groin Shield', 'What factors influence interpretation of Groin Shield 103?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Groin Shield 103''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Gs', 'Groin Shield', 'How can Groin Shield 103 be misinterpreted?', 'Groin Shield 103 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bs', 'Belongings Security Check', 'What key behavior does Belongings Security Check 104 describe?', 'Belongings Security Check 104 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bs', 'Belongings Security Check', 'In what way does Belongings Security Check 104 assist in deception detection?', 'Belongings Security Check 104 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bs', 'Belongings Security Check', 'What observable traits define Belongings Security Check 104?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bs', 'Belongings Security Check', 'What factors influence interpretation of Belongings Security Check 104?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Belongings Security Check 104''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Bs', 'Belongings Security Check', 'How can Belongings Security Check 104 be misinterpreted?', 'Belongings Security Check 104 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ftb', 'Fists-Table', 'What key behavior does Fists-Table 105 describe?', 'Fists-Table 105 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ftb', 'Fists-Table', 'In what way does Fists-Table 105 assist in deception detection?', 'Fists-Table 105 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ftb', 'Fists-Table', 'What observable traits define Fists-Table 105?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ftb', 'Fists-Table', 'What factors influence interpretation of Fists-Table 105?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Fists-Table 105''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Ftb', 'Fists-Table', 'How can Fists-Table 105 be misinterpreted?', 'Fists-Table 105 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oc', 'Object Concealment', 'What key behavior does Object Concealment 106 describe?', 'Object Concealment 106 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oc', 'Object Concealment', 'In what way does Object Concealment 106 assist in deception detection?', 'Object Concealment 106 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oc', 'Object Concealment', 'What observable traits define Object Concealment 106?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oc', 'Object Concealment', 'What factors influence interpretation of Object Concealment 106?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Object Concealment 106''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oc', 'Object Concealment', 'How can Object Concealment 106 be misinterpreted?', 'Object Concealment 106 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jp', 'Jewelry Play', 'What key behavior does Jewelry Play 107 describe?', 'Jewelry Play 107 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jp', 'Jewelry Play', 'In what way does Jewelry Play 107 assist in deception detection?', 'Jewelry Play 107 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jp', 'Jewelry Play', 'What observable traits define Jewelry Play 107?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jp', 'Jewelry Play', 'What factors influence interpretation of Jewelry Play 107?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Jewelry Play 107''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Jp', 'Jewelry Play', 'How can Jewelry Play 107 be misinterpreted?', 'Jewelry Play 107 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cl', 'Chair legs', 'What key behavior does Chair legs 108 describe?', 'Chair legs 108 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cl', 'Chair legs', 'In what way does Chair legs 108 assist in deception detection?', 'Chair legs 108 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cl', 'Chair legs', 'What observable traits define Chair legs 108?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cl', 'Chair legs', 'What factors influence interpretation of Chair legs 108?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Chair legs 108''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Cl', 'Chair legs', 'How can Chair legs 108 be misinterpreted?', 'Chair legs 108 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hes', 'Hesitancy', 'What key behavior does Hesitancy 109 describe?', 'Hesitancy 109 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hes', 'Hesitancy', 'In what way does Hesitancy 109 assist in deception detection?', 'Hesitancy 109 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hes', 'Hesitancy', 'What observable traits define Hesitancy 109?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hes', 'Hesitancy', 'What factors influence interpretation of Hesitancy 109?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Hesitancy 109''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Hes', 'Hesitancy', 'How can Hesitancy 109 be misinterpreted?', 'Hesitancy 109 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Psd', 'Psychological Distance', 'What key behavior does Psychological Distance 110 describe?', 'Psychological Distance 110 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Psd', 'Psychological Distance', 'In what way does Psychological Distance 110 assist in deception detection?', 'Psychological Distance 110 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Psd', 'Psychological Distance', 'What observable traits define Psychological Distance 110?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Psd', 'Psychological Distance', 'What factors influence interpretation of Psychological Distance 110?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Psychological Distance 110''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Psd', 'Psychological Distance', 'How can Psychological Distance 110 be misinterpreted?', 'Psychological Distance 110 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Rip', 'Rise-Pitch', 'What key behavior does Rise-Pitch 111 describe?', 'Rise-Pitch 111 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Rip', 'Rise-Pitch', 'In what way does Rise-Pitch 111 assist in deception detection?', 'Rise-Pitch 111 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Rip', 'Rise-Pitch', 'What observable traits define Rise-Pitch 111?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Rip', 'Rise-Pitch', 'What factors influence interpretation of Rise-Pitch 111?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Rise-Pitch 111''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Rip', 'Rise-Pitch', 'How can Rise-Pitch 111 be misinterpreted?', 'Rise-Pitch 111 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Spd', 'Increase Speed', 'What key behavior does Increase Speed 112 describe?', 'Increase Speed 112 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Spd', 'Increase Speed', 'In what way does Increase Speed 112 assist in deception detection?', 'Increase Speed 112 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Spd', 'Increase Speed', 'What observable traits define Increase Speed 112?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Spd', 'Increase Speed', 'What factors influence interpretation of Increase Speed 112?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Increase Speed 112''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Spd', 'Increase Speed', 'How can Increase Speed 112 be misinterpreted?', 'Increase Speed 112 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('NA', 'Non-Answer', 'What key behavior does Non-Answer 113 describe?', 'Non-Answer 113 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('NA', 'Non-Answer', 'In what way does Non-Answer 113 assist in deception detection?', 'Non-Answer 113 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('NA', 'Non-Answer', 'What observable traits define Non-Answer 113?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('NA', 'Non-Answer', 'What factors influence interpretation of Non-Answer 113?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Non-Answer 113''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('NA', 'Non-Answer', 'How can Non-Answer 113 be misinterpreted?', 'Non-Answer 113 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Prn', 'Pronoun Absent', 'What key behavior does Pronoun Absent 114 describe?', 'Pronoun Absent 114 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Prn', 'Pronoun Absent', 'In what way does Pronoun Absent 114 assist in deception detection?', 'Pronoun Absent 114 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Prn', 'Pronoun Absent', 'What observable traits define Pronoun Absent 114?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Prn', 'Pronoun Absent', 'What factors influence interpretation of Pronoun Absent 114?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Pronoun Absent 114''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Prn', 'Pronoun Absent', 'How can Pronoun Absent 114 be misinterpreted?', 'Pronoun Absent 114 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Res', 'Resume Statements', 'What key behavior does Resume Statements 115 describe?', 'Resume Statements 115 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Res', 'Resume Statements', 'In what way does Resume Statements 115 assist in deception detection?', 'Resume Statements 115 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Res', 'Resume Statements', 'What observable traits define Resume Statements 115?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Res', 'Resume Statements', 'What factors influence interpretation of Resume Statements 115?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Resume Statements 115''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Res', 'Resume Statements', 'How can Resume Statements 115 be misinterpreted?', 'Resume Statements 115 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Nc', 'Non-Contracting Statement', 'What key behavior does Non-Contracting Statement 116 describe?', 'Non-Contracting Statement 116 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Nc', 'Non-Contracting Statement', 'In what way does Non-Contracting Statement 116 assist in deception detection?', 'Non-Contracting Statement 116 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Nc', 'Non-Contracting Statement', 'What observable traits define Non-Contracting Statement 116?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Nc', 'Non-Contracting Statement', 'What factors influence interpretation of Non-Contracting Statement 116?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Non-Contracting Statement 116''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Nc', 'Non-Contracting Statement', 'How can Non-Contracting Statement 116 be misinterpreted?', 'Non-Contracting Statement 116 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Qr', 'Question Reversal', 'What key behavior does Question Reversal 117 describe?', 'Question Reversal 117 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Qr', 'Question Reversal', 'In what way does Question Reversal 117 assist in deception detection?', 'Question Reversal 117 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Qr', 'Question Reversal', 'What observable traits define Question Reversal 117?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Qr', 'Question Reversal', 'What factors influence interpretation of Question Reversal 117?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Question Reversal 117''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Qr', 'Question Reversal', 'How can Question Reversal 117 be misinterpreted?', 'Question Reversal 117 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Am', 'Ambiguity', 'What key behavior does Ambiguity 118 describe?', 'Ambiguity 118 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Am', 'Ambiguity', 'In what way does Ambiguity 118 assist in deception detection?', 'Ambiguity 118 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Am', 'Ambiguity', 'What observable traits define Ambiguity 118?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Am', 'Ambiguity', 'What factors influence interpretation of Ambiguity 118?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Ambiguity 118''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Am', 'Ambiguity', 'How can Ambiguity 118 be misinterpreted?', 'Ambiguity 118 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pol', 'Politeness', 'What key behavior does Politeness 119 describe?', 'Politeness 119 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pol', 'Politeness', 'In what way does Politeness 119 assist in deception detection?', 'Politeness 119 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pol', 'Politeness', 'What observable traits define Politeness 119?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pol', 'Politeness', 'What factors influence interpretation of Politeness 119?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Politeness 119''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Pol', 'Politeness', 'How can Politeness 119 be misinterpreted?', 'Politeness 119 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oa', 'Over-Apology', 'What key behavior does Over-Apology 120 describe?', 'Over-Apology 120 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oa', 'Over-Apology', 'In what way does Over-Apology 120 assist in deception detection?', 'Over-Apology 120 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oa', 'Over-Apology', 'What observable traits define Over-Apology 120?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oa', 'Over-Apology', 'What factors influence interpretation of Over-Apology 120?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Over-Apology 120''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Oa', 'Over-Apology', 'How can Over-Apology 120 be misinterpreted?', 'Over-Apology 120 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Mc', 'Mini-Confession', 'What key behavior does Mini-Confession 121 describe?', 'Mini-Confession 121 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Mc', 'Mini-Confession', 'In what way does Mini-Confession 121 assist in deception detection?', 'Mini-Confession 121 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Mc', 'Mini-Confession', 'What observable traits define Mini-Confession 121?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Mc', 'Mini-Confession', 'What factors influence interpretation of Mini-Confession 121?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Mini-Confession 121''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Mc', 'Mini-Confession', 'How can Mini-Confession 121 be misinterpreted?', 'Mini-Confession 121 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Exc', 'Exclusions', 'What key behavior does Exclusions 122 describe?', 'Exclusions 122 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Exc', 'Exclusions', 'In what way does Exclusions 122 assist in deception detection?', 'Exclusions 122 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Exc', 'Exclusions', 'What observable traits define Exclusions 122?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Exc', 'Exclusions', 'What factors influence interpretation of Exclusions 122?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Exclusions 122''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Exc', 'Exclusions', 'How can Exclusions 122 be misinterpreted?', 'Exclusions 122 can be misread if evaluated in isolation or without considering contradictory gestures.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Chr', 'Direct Chronology', 'What key behavior does Direct Chronology 123 describe?', 'Direct Chronology 123 describes a behavioral expression relevant to stress, comfort, or deception in social interaction.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Chr', 'Direct Chronology', 'In what way does Direct Chronology 123 assist in deception detection?', 'Direct Chronology 123 contributes to identifying deception when aligned with other high-rated BToE indicators.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Chr', 'Direct Chronology', 'What observable traits define Direct Chronology 123?', 'Observable traits may include movement, posture, facial expression, or hand/limb positioning.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Chr', 'Direct Chronology', 'What factors influence interpretation of Direct Chronology 123?', 'Environmental stressors, personal baseline behavior, and cultural context all influence Direct Chronology 123''s interpretation.');

INSERT INTO quiz_questions (behavior_symbol, behavior_name, question, answer)
VALUES ('Chr', 'Direct Chronology', 'How can Direct Chronology 123 be misinterpreted?', 'Direct Chronology 123 can be misread if evaluated in isolation or without considering contradictory gestures.');
