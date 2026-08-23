"""Generate the "CCA-F Bins & Lists" deck.

Source of truth for the content:
  ~/Documents/learning/claude-arc-exam/reference/list-membership.html
  ("Every Closed List, By Surface", built 2026-08-23)

That sheet exists because bins scored 18/28 while *membership* scored 14/28 —
the surface can be placed, but the roster cannot be produced.  This deck drills
the sheet's three levels (bin -> list -> member) in five directions so the
forward question and its inverse arrive together.

Membership was re-verified 2026-08-23 against the companion sheets
(field-inventory-domain1..5.html, enumeration-drill.html, surface-index.html,
claude-code-config.html).  Where they disagree, see the DISCREPANCIES note on
the affected list below.

AUTHORING RULE — REAL STRINGS ONLY.  Every option on every card is a string
that genuinely appears somewhere in BINS.  A wrong option is always a real
member of the *wrong* list, never an invention.  Veto cards (true non-members
such as `processing` or `mcp__server__*`) are a deliberate follow-up, kept out
of this pass so false strings are not read before the real rosters are cold.

APPEND-ONLY.  `metadata.number` is positional, and the importer keys on
(source, number).  Adding to the END of a list or bin is safe; inserting in the
middle renumbers everything after it, and a re-import would silently skip the
shifted cards.  For any mid-table edit, regenerate and run
scripts/sync_deck_cards.py (rewrites in place) instead of re-importing.
A stable `metadata.key` is emitted alongside `number` for a future rekey.

Run:  python BTE_APP_backend/scripts/gen_cca_bins_and_lists.py
Then: python -m BTE_APP_backend.scripts.import_deck_from_json \
          --json BTE_APP_backend/data/cca_bins_and_lists.json --user-id 123
"""

import hashlib
import json
import os
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "data", "cca_bins_and_lists.json")

DECK_NAME = "CCA-F Bins & Lists"
SOURCE = "cca_bins_and_lists"

# Direction values are prefixed with a digit and bins with a letter because the
# session page sorts facet values with localeCompare — the prefix is what keeps
# the dropdowns in the sheet's own order without any sorting code.
D_ROSTER = "1 - Roster (list to members)"
D_COUNT = "2 - Count"
D_TERM_LIST = "3 - Term to list"
D_TERM_BIN = "4 - Term to bin"
D_BIN_LISTS = "5 - Bin and its lists"

BIN_A = "A - API · BODY"
BIN_B = "B - MCP · PROCESS"
BIN_C = "C - Claude Code · FILE"
BIN_D = "D - Agent SDK · PROGRAM"
BIN_E = "E - No surface"

BIN_GLOSS = {
    BIN_A: "typed into a request body; it crosses the wire",
    BIN_B: "spoken between a client and a server over a transport",
    BIN_C: "typed into a config file or a CLI flag; it never crosses a wire",
    BIN_D: "a construct you instantiate in your own program",
    BIN_E: "a concept, not a string you type anywhere",
}

NUMBER_WORD = {
    2: "TWO", 3: "THREE", 4: "FOUR", 5: "FIVE",
    6: "SIX", 7: "SEVEN", 8: "EIGHT", 12: "TWELVE",
}


def L(name, members, note, collides=(), ordered=False, closed=True):
    """One closed list. `collides` names sibling lists distractors are drawn from."""
    return {
        "name": name,
        "members": list(members),
        "note": note,
        "collides": list(collides),
        "ordered": ordered,
        "closed": closed,
    }


BINS = [
    (BIN_A, [
        L("tool_choice values",
          ["auto", "any", '{type:"tool",name}', "none"],
          "`any` = must call some tool, but the model picks which. Forcing a call means "
          "stop_reason is always tool_use, never end_turn. The count is the separator: "
          "tool_choice has FOUR, permission modes have SIX.",
          collides=["Permission modes"]),
        L("stop_reason values",
          ["tool_use", "end_turn", "max_tokens", "stop_sequence", "pause_turn", "refusal"],
          "The impostors are max_tokens and refusal — both look like a finished answer. "
          "Truncated text reads as an answer, and a refusal may carry no text block at all. "
          "(model_context_window_exceeded also appears in current listings; recognition only, "
          "not one of the SIX.)",
          collides=["tool_choice values", "Permission modes"]),
        L("CLIENT tools",
          ["bash", "text_editor", "memory", "computer"],
          "Anthropic writes the schema, YOU execute. The seam is \"do I have to write a "
          "handler?\" — not \"who defined it.\" Both tool groups are API · BODY: they are "
          "entries in the request's `tools` array. Neither is PROGRAM.",
          collides=["SERVER tools"]),
        L("SERVER tools",
          ["web_search", "web_fetch", "code_execution", "tool_search", "advisor"],
          "Anthropic executes these and the results come back in the same response — you "
          "never write a handler, and there is no second round-trip. That is what \"server\" "
          "buys. Still API · BODY.",
          collides=["CLIENT tools"]),
        L("Batch statuses",
          ["in_progress", "ended"],
          "Exactly TWO. Not \"processing\", not \"complete\".",
          collides=["Batch result types"],
          ordered=True),
        L("Batch result types",
          ["succeeded", "errored", "canceled", "expired"],
          "You are billed only for `succeeded` — not for the other three. Match results back "
          "with custom_id; order is not guaranteed. The 24h figure is the expiry, not an SLA.",
          collides=["Batch statuses"]),
        L("Schema modelling",
          ["nullable", "strict: true", "input_schema", "output_config.format"],
          "`nullable` is API · BODY — a JSON-Schema keyword inside input_schema. It has no "
          "Claude Code spelling at all, and it has been misfiled to FILE twice (08-17, 08-23). "
          "DISCREPANCY: field-inventory-domain4 carries `nullable` as a technique "
          "(\"nullable over absent\") rather than a literal keyword, and flags output_config "
          "\"not re-verified — don't card until checked\". `output_format` is DEPRECATED.",
          collides=["tool_choice values"]),
    ]),

    (BIN_B, [
        L("The MCP handshake",
          ["Request `initialize` (CLIENT)",
           "Result with capabilities (SERVER)",
           "Notification `initialized` (CLIENT, last)"],
          "Skip the last one and the server declines to service real requests. The connection "
          "does not break — it just never saw the handshake complete.",
          collides=["MCP invoke methods"],
          ordered=True),
        L("MCP invoke methods",
          ["tools/call", "prompts/get", "resources/read"],
          "Only one of the three is a \"call\", and resources/read is the one that breaks the "
          "parameter pattern — it takes a **uri**, not name+arguments.",
          collides=["MCP discovery methods", "The MCP handshake"]),
        L("MCP discovery methods",
          ["tools/list", "prompts/list", "resources/list"],
          "The discovery twins of the invoke methods. Same three primitives, /list instead of "
          "call·get·read.",
          collides=["MCP invoke methods"]),
        L("MCP server flags",
          ["json_response", "stateless_http"],
          "json_response swaps the SSE envelope for ONE JSON body and changes not one byte of "
          "the payload. stateless_http stops the Mcp-Session-Id header being issued, so any "
          "replica can serve any request — routability, not speed.",
          collides=["--output-format values"]),
        L("MCP camelCase wire strings",
          ["isError", "inputSchema", "Mcp-Session-Id"],
          "camelCase on the MCP wire vs is_error / input_schema snake_case in the API body. "
          "Casing settles it before reasoning does — but it is a tie-breaker, not a law. "
          "DISCREPANCY: the source sheet titles this row \"tool-result fields\"; only isError "
          "is one. inputSchema is a tool DEFINITION field and Mcp-Session-Id is a wire header.",
          collides=["Schema modelling"]),
    ]),

    (BIN_C, [
        L("Permission modes",
          ["default", "acceptEdits", "plan", "bypassPermissions", "dontAsk", "auto"],
          "bypassPermissions fails OPEN · dontAsk fails CLOSED. Both descriptions contain the "
          "words \"never asks\" — opposites wearing one phrase. The settings-file spelling is "
          "defaultMode; the CLI spelling is --permission-mode. "
          "DISCREPANCY: surface-index.html still shows FOUR on a stale row; enumeration-drill "
          "was corrected 08-16 to SIX, which is what this deck teaches.",
          collides=["tool_choice values", "Permission rule lists"]),
        L("Permission evaluation steps",
          ["hooks", "deny", "explicit ask", "the MODE", "allow", "canUseTool"],
          "The mode is step 4 — which is *why* a deny rule still blocks under "
          "bypassPermissions: hooks, deny and explicit ask have all already run. Bypass only "
          "suppresses prompting for whatever reaches step 4. An allow match at step 5 ends the "
          "flow, which is why step 6 often never fires.",
          collides=["Permission rule lists", "Settings precedence layers"],
          ordered=True),
        L("Permission rule lists",
          ["allow", "deny", "ask"],
          "Evaluated deny → ask → allow. All layers merge into ONE pool, and deny wins from any "
          "layer, rank-independent. The same three words are also the permissionDecision values "
          "in a hook's JSON return — ask yourself whether you are writing settings or answering "
          "as a hook.",
          collides=["Permission evaluation steps", "Permission modes"],
          ordered=True),
        L("Settings precedence layers",
          ["Managed", "command-line args", "Local", "Project", "User"],
          "This governs SCALAR settings only (model, env) — override. Permissions do not use it "
          "— veto. A CLI flag is not a file, so it sits between Managed and Local, and Managed "
          "still beats it.",
          collides=["Permission evaluation steps"],
          ordered=True),
        L("Hook events that CAN block",
          ["PreToolUse", "UserPromptSubmit", "Stop", "SubagentStop", "PreCompact"],
          "Hooks are FILE, not PROCESS — they are configured in settings.json. A hook fires "
          "*around* a tool call, which is why it feels like MCP; ask where it is TYPED. Stop "
          "gates the EXIT, so blocking it forces continuation. The name is an inversion trap.",
          collides=["Hook events that CANNOT block"]),
        L("Hook events that CANNOT block",
          ["PostToolUse", "Notification", "SessionStart", "SessionEnd"],
          "PostToolUse feeds a reason back — the tool already ran. SessionStart injects context "
          "instead of blocking.",
          collides=["Hook events that CAN block"]),
        L("Hook exit codes",
          ["2 = block, reason to stderr, and that stderr goes back to Claude",
           "0 = proceed (stdout parsed as JSON if it is JSON)",
           "any other = fails OPEN, stderr to the user only"],
          "1 does not block — a buggy hook must never brick the session. The dangerous case is "
          "silent: exit 0 with nothing logged.",
          collides=["Hook JSON return — the PreToolUse nest"],
          ordered=True),
        L("Hook JSON return — the PreToolUse nest",
          ["hookSpecificOutput", "hookEventName", "permissionDecision", "permissionDecisionReason"],
          "TWO decision fields, different names, different nesting, different events: "
          "hookSpecificOutput.permissionDecision for PreToolUse ONLY; a top-level `decision` for "
          "everything else. Misspell either and nothing throws. Values are case-sensitive — "
          "\"Deny\" fails open silently, and the direction of that failure follows intent: "
          "deny + typo fails OPEN, allow + typo fails CLOSED.",
          collides=["Hook JSON return — top-level common fields", "Permission rule lists"]),
        L("Hook JSON return — top-level common fields",
          ["continue", "stopReason", "suppressOutput", "systemMessage"],
          "Top-level, valid on any event — as opposed to the PreToolUse-only fields that live "
          "nested under hookSpecificOutput. `continue` stops the whole turn; stopReason is its "
          "message.",
          collides=["Hook JSON return — the PreToolUse nest"]),
        L("--output-format values",
          ["text", "json", "stream-json"],
          "This is the ENVELOPE. --json-schema is the CONTRACT — it supplies the shape the "
          "envelope does not. Envelope alone gives you parseable output you cannot *index*. "
          "Inverted on 08-23, both halves, ninety minutes after reading them.",
          collides=["MCP server flags"]),
        L("Session continuation",
          ["--resume", "--fork-session"],
          "--resume continues the same session; --fork-session takes a COPY (fork_session in the "
          "SDK). A session is a TRANSCRIPT, not a live view — neither re-reads the filesystem, "
          "and a copy of stale is stale.",
          collides=["Context mechanisms"],
          ordered=True),
        L("Permission strings & keys",
          ["mcp__<server>__<tool>", "additionalDirectories", "defaultMode", ".mcp.json / mcpServers"],
          "MCP-flavoured words on a Claude Code surface. Double underscores in both places, one "
          "entry per tool — there is no mcp__server__* glob form.",
          collides=["Permission modes", "MCP camelCase wire strings"]),
    ]),

    (BIN_D, [
        L("AgentDefinition fields (camelCase)",
          ["description", "prompt", "tools", "model",
           "disallowedTools", "mcpServers", "maxTurns", "permissionMode"],
          "Its `tools` list governs that subagent — a broader parent allowlist is a CEILING, not "
          "a grant. Mirrors the markdown frontmatter, which is Claude Code-shaped, which is why "
          "it is camelCase inside a snake_case Python file.",
          collides=["ClaudeAgentOptions — the snake_case twins"]),
        L("ClaudeAgentOptions — the snake_case twins",
          ["disallowed_tools", "mcp_servers", "max_turns", "agents", "setting_sources"],
          "Same concepts, same Python file, different casing — a casing trap that has already "
          "cost a card. DISCREPANCY: this is NOT the full field set. surface-index.html also "
          "lists allowed_tools, permission_mode, system_prompt, model, cwd, add_dirs, env, "
          "hooks, resume, fork_session and settings. These five are the snake_case twins of "
          "AgentDefinition's camelCase fields, so this list is deliberately NOT drilled for a "
          "count.",
          collides=["AgentDefinition fields (camelCase)"],
          closed=False),
    ]),

    (BIN_E, [
        L("The agentic patterns",
          ["prompt chaining", "routing", "parallelization",
           "orchestrator-workers", "evaluator-optimizer"],
          "The separator is: are the subtasks knowable in advance? Pre-known → parallelization. "
          "Discovered per input → orchestrator-workers. Parallelism and isolated context are "
          "shared by BOTH, so neither is the tell. These have no surface — assigning one is "
          "itself the trap.",
          collides=["Context mechanisms"]),
        L("Escalation triggers",
          ["ASKED", "COVERAGE", "STUCK"],
          "Coverage has three flavours: silent (no rule) · ambiguous (unclear rule) · exceeds a "
          "stated limit (the rule says no). The third is a gap in AUTHORITY, not information.",
          collides=["Escalation NON-triggers"]),
        L("Escalation NON-triggers",
          ["difficulty / complexity", "sentiment", "self-rated confidence"],
          "Difficulty is the one that keeps going missing (08-23, twice). Hard is not blocked. "
          "Self-rated confidence samples the faculty that is already broken; sentiment measures "
          "a different variable.",
          collides=["Escalation triggers"]),
        L("Context mechanisms",
          ["compaction", "context editing", "memory tool"],
          "Side · verb · preserve-or-discard. compaction — SERVER, summarize, PRESERVES (lossy "
          "but keeps the gist). context editing — CLIENT, deletes tool_results verbatim, "
          "DISCARDS. memory tool — CLIENT, persists across sessions.",
          collides=["Session continuation", "The agentic patterns"]),
    ]),
]


# ---------------------------------------------------------------- indexes ---

LISTS = []          # every list, flattened, with its bin attached
BY_NAME = {}        # list name -> list
MEMBER_OWNER = {}   # member string -> list (must be 1:1; validate() enforces it)
LISTS_IN_BIN = {}   # bin label -> [list, ...] in sheet order

for _bin, _lists in BINS:
    LISTS_IN_BIN[_bin] = _lists
    for _l in _lists:
        _l["bin"] = _bin
        LISTS.append(_l)
        BY_NAME[_l["name"]] = _l
        for _m in _l["members"]:
            MEMBER_OWNER.setdefault(_m, _l)

BIN_LABELS = [b for b, _ in BINS]
BIN_LIST_COUNTS = sorted({len(ls) for _, ls in BINS})


def _h(key, salt=""):
    return int(hashlib.sha256((salt + "|" + key).encode("utf-8")).hexdigest(), 16)


def _shuffled(seq, key):
    """Deterministic shuffle — no `random`, so output is stable across runs."""
    return [x for _, x in sorted(((_h(key, str(i) + str(x)), x) for i, x in enumerate(seq)))]


def pick_distractors(candidates, answer, key, k=3):
    """Choose k distinct wrong options.

    Candidates are ordered by preference (colliding list first, then same bin,
    then everything else); within each preference band the order is shuffled
    deterministically so the deck does not always reach for the same twin.

    One extra rule: if any candidate is at least as long as the answer, make
    sure one is included.  Otherwise "pick the longest option" would quietly
    become a tell on cards where the true roster happens to be the wordiest.
    """
    pool, seen = [], {answer}
    for c in candidates:
        if c not in seen:
            seen.add(c)
            pool.append(c)
    if len(pool) < k:
        raise ValueError("not enough distractors for %r (have %d)" % (answer, len(pool)))
    chosen = pool[:k]
    if all(len(c) < len(answer) for c in chosen):
        longer = [c for c in pool[k:] if len(c) >= len(answer)]
        if longer:
            chosen = chosen[:-1] + [_shuffled(longer, key)[0]]
    return chosen


CARDS = []


def emit(key, direction, bin_label, list_name, prompt, answer, distractors, explanation):
    """Append one multiple-choice card, rotating the answer slot deterministically."""
    opts = list(distractors)
    if len(opts) != 3:
        raise ValueError("card %s has %d distractors" % (key, len(opts)))
    slot = _h(key, "slot") % 4
    choices = opts[:slot] + [answer] + opts[slot:]
    CARDS.append({
        "prompt": prompt,
        "answer": answer,
        "metadata": {
            "bin": bin_label,
            "direction": direction,
            "list": list_name,
            "choices": choices,
            "explanation": explanation,
            "key": key,
            "source": SOURCE,
            "number": None,   # assigned in build(), positionally
        },
    })


def roster(members):
    return " · ".join(members)


def siblings(lst):
    """Members of other lists, most-confusable first: collisions, bin, rest."""
    out = []
    for name in lst["collides"]:
        out.extend(BY_NAME[name]["members"])
    for other in LISTS_IN_BIN[lst["bin"]]:
        if other is not lst:
            out.extend(other["members"])
    for other in LISTS:
        if other is not lst:
            out.extend(other["members"])
    return [m for m in out if m not in lst["members"]]


def other_list_names(lst):
    """Other list display names, most-confusable first."""
    out = list(lst["collides"])
    out.extend(o["name"] for o in LISTS_IN_BIN[lst["bin"]] if o is not lst)
    out.extend(o["name"] for o in LISTS if o is not lst)
    return [n for n in out if n != lst["name"]]


def variant_rosters(members, foreign, ordered, key):
    """Candidate WRONG rosters, most instructive first.

    Every variant is built only from real strings: either a permutation of the
    true members (wrong order, right membership) or the true roster with one or
    two members replaced by real members of a neighbouring list.
    """
    n = len(members)
    perms, swaps = [], []
    for i in range(n - 1):
        v = list(members)
        v[i], v[i + 1] = v[i + 1], v[i]
        perms.append(v)
    if n > 2:
        perms.append(members[-1:] + members[:-1])
        perms.append(members[1:] + members[:1])
        perms.append(list(reversed(members)))
    # siblings() is ordered collisions-first, then same-bin, then everything
    # else.  Shuffling the whole pool threw that away and produced options like
    # `6 canUseTool` inside a stop_reason roster — real, but from a bin the list
    # could not plausibly reach.  Shuffle only inside the confusable head.
    pool = _shuffled(foreign[:8], key) + foreign[8:]
    for i in range(n):
        for s in pool[:3]:
            v = list(members)
            v[i] = s
            swaps.append(v)
    if n >= 3 and len(pool) >= 2:
        v = list(members)
        v[0], v[n - 1] = pool[0], pool[1]
        swaps.append(v)

    ordered_first = _shuffled(perms, key) + _shuffled(swaps, key + "s")
    swaps_first = _shuffled(swaps, key) + _shuffled(perms, key + "p")
    cands = ordered_first if ordered else swaps_first

    seen, out = {tuple(members)}, []
    for v in cands:
        t = tuple(v)
        if t not in seen:
            seen.add(t)
            out.append(roster(v))
    return out


# --------------------------------------------------------- 1 · rosters ------

for lst in LISTS:
    members, n = lst["members"], len(lst["members"])
    word = NUMBER_WORD[n]
    in_order = ", in order" if lst["ordered"] else ""
    how_many = "both" if n == 2 else "all %s" % word
    framings = [
        ("a", "%s — name %s%s." % (lst["name"], how_many, in_order)),
    ]
    if n >= 5:
        framings.append(
            ("b", "Cold recall, no sheet: the complete %s roster (%s%s)."
                  % (lst["name"], word, in_order)))
    for tag, prompt in framings:
        key = "%s/%s/roster/%s" % (lst["bin"][0], lst["name"], tag)
        emit(key, D_ROSTER, lst["bin"], lst["name"], prompt, roster(members),
             pick_distractors(variant_rosters(members, siblings(lst), lst["ordered"], key),
                              roster(members), key),
             "%s · %s. %s" % (lst["name"], lst["bin"], lst["note"]))


# ----------------------------------------------------------- 2 · counts -----

for lst in LISTS:
    if not lst["closed"]:
        continue          # ClaudeAgentOptions is a selection, not a closed roster
    n = len(lst["members"])
    cands = [len(BY_NAME[c]["members"]) for c in lst["collides"]]
    cands += [len(o["members"]) for o in LISTS_IN_BIN[lst["bin"]] if o is not lst]
    cands += [len(o["members"]) for o in LISTS if o is not lst]
    cands = [str(c) for c in cands if c != n]
    key = "%s/%s/count" % (lst["bin"][0], lst["name"])
    emit(key, D_COUNT, lst["bin"], lst["name"],
         "How many members does %s have?" % lst["name"], str(n),
         pick_distractors(_shuffled(cands, key), str(n), key),
         "%s has %s (%d). %s" % (lst["name"], NUMBER_WORD[n], n, lst["note"]))


# -------------------------------------------------- 3 · term → list ---------

# A member may legitimately sit in more than one list — `auto` is both a
# tool_choice value and a permission mode, and that pair is the sheet's headline
# collision (07-31: asked for permission modes, produced the tool_choice four).
# A plain "which list?" card would be unanswerable for it, so those members get
# a pair card instead, filed in their own facet bucket rather than faked into
# one bin.
HOMES = {}
for lst in LISTS:
    for member in lst["members"]:
        HOMES.setdefault(member, []).append(lst)

COLLISION_BIN = "Z - collision (two bins)"
COLLISION_LIST = "z - collision (two lists)"


def pair_variants(true_pair, foreign, key):
    """Wrong PAIRS, each built from real names only."""
    out = []
    for s in _shuffled(foreign, key):
        out.append([true_pair[0], s])
        out.append([s, true_pair[1]])
    seen, res = {tuple(true_pair)}, []
    for v in out:
        if v[0] == v[1]:
            continue
        t = tuple(v)
        if t not in seen:
            seen.add(t)
            res.append(" + ".join(v))
    return res


def bin_distractor_pool(lst):
    """Other bins, the one its collisions live on first."""
    out = [BY_NAME[c]["bin"] for c in lst["collides"]]
    out += BIN_LABELS
    return [b for b in out if b != lst["bin"]]


for member, homes in HOMES.items():
    if len(homes) == 1:
        lst = homes[0]
        key = "%s/%s/term-list/%s" % (lst["bin"][0], lst["name"], member)
        emit(key, D_TERM_LIST, lst["bin"], lst["name"],
             "`%s` — which list is it a member of?" % member, lst["name"],
             pick_distractors(other_list_names(lst), lst["name"], key),
             "`%s` belongs to %s, on %s. %s"
             % (member, lst["name"], lst["bin"], lst["note"]))
        continue

    names = [l["name"] for l in homes]
    answer = " + ".join(names)
    foreign = [o["name"] for o in LISTS if o["name"] not in names]
    key = "collision/term-list/%s" % member
    emit(key, D_TERM_LIST, COLLISION_BIN, COLLISION_LIST,
         "`%s` belongs to TWO different lists. Which two?" % member, answer,
         pick_distractors(pair_variants(names, foreign, key), answer, key),
         "`%s` is in both %s — one word, two roles. %s"
         % (member, " and ".join(names),
            " ".join(BY_NAME[n]["note"] for n in names)[:420]))


# --------------------------------------------------- 4 · term → bin ---------

for member, homes in HOMES.items():
    bins = []
    for l in homes:
        if l["bin"] not in bins:
            bins.append(l["bin"])

    if len(bins) == 1:
        lst = homes[0]
        where = " and ".join(l["name"] for l in homes)
        key = "%s/%s/term-bin/%s" % (lst["bin"][0], lst["name"], member)
        emit(key, D_TERM_BIN, lst["bin"], lst["name"],
             "`%s` — which surface does it live on?" % member, lst["bin"],
             pick_distractors(bin_distractor_pool(lst), lst["bin"], key),
             "`%s` is a member of %s, which is %s — %s. %s"
             % (member, where, lst["bin"], BIN_GLOSS[lst["bin"]], lst["note"]))
        continue

    answer = " + ".join(bins)
    foreign = [b for b in BIN_LABELS if b not in bins]
    key = "collision/term-bin/%s" % member
    emit(key, D_TERM_BIN, COLLISION_BIN, COLLISION_LIST,
         "`%s` sits in two lists, and those lists are on two DIFFERENT surfaces. "
         "Which two?" % member, answer,
         pick_distractors(pair_variants(bins, foreign, key), answer, key),
         "`%s` is in %s. Where you TYPE it is the disambiguator: %s is %s, while "
         "%s is %s."
         % (member, " and ".join(l["name"] for l in homes),
            bins[0], BIN_GLOSS[bins[0]], bins[1], BIN_GLOSS[bins[1]]))


# ------------------------------------------------ 5 · bin ↔ its lists -------

for lst in LISTS:
    key = "%s/%s/list-bin" % (lst["bin"][0], lst["name"])
    emit(key, D_BIN_LISTS, lst["bin"], lst["name"],
         "%s — which bin does the sheet file it under?" % lst["name"], lst["bin"],
         pick_distractors(bin_distractor_pool(lst), lst["bin"], key),
         "%s is %s — %s. %s" % (lst["name"], lst["bin"], BIN_GLOSS[lst["bin"]], lst["note"]))

for bin_label, bin_lists in BINS:
    names = [l["name"] for l in bin_lists]
    foreign = [l["name"] for l in LISTS if l["bin"] != bin_label]
    key = "%s/inventory" % bin_label[0]
    emit(key, D_BIN_LISTS, bin_label, "(whole bin)",
         "%s hosts %s closed lists. Which set is the complete inventory?"
         % (bin_label, NUMBER_WORD[len(names)]),
         roster(names),
         pick_distractors(variant_rosters(names, foreign, False, key), roster(names), key),
         "%s — %s. The %s lists are: %s."
         % (bin_label, BIN_GLOSS[bin_label], NUMBER_WORD[len(names)].lower(), roster(names)))

    key = "%s/inventory-count" % bin_label[0]
    others = [str(c) for c in BIN_LIST_COUNTS if c != len(names)]
    emit(key, D_BIN_LISTS, bin_label, "(whole bin)",
         "How many closed lists does the sheet catalogue on %s?" % bin_label,
         str(len(names)),
         pick_distractors(_shuffled(others, key), str(len(names)), key),
         "%s carries %s lists. Across all five bins: %s."
         % (bin_label, NUMBER_WORD[len(names)],
            " · ".join("%s %d" % (b[0], len(ls)) for b, ls in BINS)))


# ------------------------------------------------------- build & validate ---

# Every atom a card option is allowed to be made of.  Nothing else may appear
# anywhere in the deck — that is the "real strings only" rule, enforced.
REAL_ATOMS = set(BIN_LABELS)
REAL_ATOMS |= {l["name"] for l in LISTS}
REAL_ATOMS |= set(MEMBER_OWNER)
REAL_ATOMS |= {str(len(l["members"])) for l in LISTS}
REAL_ATOMS |= {str(c) for c in BIN_LIST_COUNTS}


def build():
    for i, card in enumerate(CARDS, start=1):
        card["metadata"]["number"] = i
    return {
        "deck_name": DECK_NAME,
        "match_strategy": "multi_choice",
        "render_config": {"fields": ["bin", "direction", "list"]},
        "cards": CARDS,
    }


def validate(deck):
    errors = []
    cards = deck["cards"]

    # A member in exactly two lists is handled by the pair cards above.  Three
    # or more would break their "which two?" phrasing, so that is a hard error.
    for member, homes in HOMES.items():
        if len(homes) > 2:
            errors.append("member %r is in %d lists (%s) — the pair cards only "
                          "handle two" % (member, len(homes),
                                          ", ".join(l["name"] for l in homes)))

    seen_prompts = set()
    for c in cards:
        m = c["metadata"]
        where = "#%s %s" % (m["number"], m["key"])
        ch = m["choices"]
        if len(ch) != 4:
            errors.append("%s: %d choices" % (where, len(ch)))
        if len(set(ch)) != len(ch):
            errors.append("%s: duplicate choices" % where)
        if any(not isinstance(x, str) or not x.strip() for x in ch):
            errors.append("%s: blank choice" % where)
        if c["answer"] not in ch:
            errors.append("%s: answer not among choices" % where)
        if not m["explanation"].strip():
            errors.append("%s: empty explanation" % where)
        if c["prompt"] in seen_prompts:
            errors.append("%s: duplicate prompt" % where)
        seen_prompts.add(c["prompt"])

        for opt in ch:
            if opt in REAL_ATOMS:
                continue
            for half in opt.split(" + "):
                if half in REAL_ATOMS:
                    continue
                for atom in half.split(" · "):
                    if atom not in REAL_ATOMS:
                        errors.append("%s: FABRICATED string %r in option %r"
                                      % (where, atom, opt))

    for c in cards:
        m = c["metadata"]
        if m["direction"] == D_COUNT:
            if c["answer"] != str(len(BY_NAME[m["list"]]["members"])):
                errors.append("%s: count disagrees with its own roster" % m["key"])

    return errors


if __name__ == "__main__":
    deck = build()
    cards = deck["cards"]

    with open(OUT, "w", encoding="utf-8") as fh:
        json.dump(deck, fh, indent=2, ensure_ascii=False)
        fh.write("\n")

    print("wrote %s" % os.path.normpath(OUT))
    slots = sum(len(l["members"]) for l in LISTS)
    print("cards: %d   (%d bins, %d lists, %d member slots / %d distinct strings)"
          % (len(cards), len(BINS), len(LISTS), slots, len(HOMES)))

    print("\nby bin:")
    for b, n in sorted(Counter(c["metadata"]["bin"] for c in cards).items()):
        print("  %-26s %4d" % (b, n))
    print("by direction:")
    for d, n in sorted(Counter(c["metadata"]["direction"] for c in cards).items()):
        print("  %-30s %4d" % (d, n))

    spread = Counter(c["metadata"]["choices"].index(c["answer"]) for c in cards)
    print("\nanswer slot: %s   (even would be %.1f each)"
          % (dict(sorted(spread.items())), len(cards) / 4))

    # A tie on length is not a tell you can act on, so only STRICTLY-longest
    # answers leak.  Ties are reported separately for visibility.
    strict = sum(1 for c in cards
                 if all(len(c["answer"]) > len(x)
                        for x in c["metadata"]["choices"] if x != c["answer"]))
    tied = sum(1 for c in cards
               if len(c["answer"]) == max(len(x) for x in c["metadata"]["choices"]))
    print("longest-option leak: strictly longest %d/%d (chance %.1f) · incl. ties %d"
          % (strict, len(cards), len(cards) / 4, tied))

    errs = validate(deck)
    if errs:
        print("\nVALIDATION FAILED — %d problem(s):" % len(errs))
        for e in errs[:40]:
            print("  " + e)
        if len(errs) > 40:
            print("  ... and %d more" % (len(errs) - 40))
    else:
        print("\nvalidation: OK")
