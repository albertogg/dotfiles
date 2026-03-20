const INPUT_NEEDED_EVENTS = new Set([
  "session.idle",
  "permission.asked",
  "question.asked",
]);

function shortText(value, max = 140) {
  if (!value) return "";
  const text = String(value).replace(/\s+/g, " ").trim();
  if (text.length <= max) return text;
  return `${text.slice(0, max - 1)}...`;
}

function basename(path) {
  if (!path) return "";
  const clean = String(path).replace(/\/$/, "");
  const idx = clean.lastIndexOf("/");
  return idx === -1 ? clean : clean.slice(idx + 1);
}

function extractDetails(event) {
  const props = event?.properties ?? {};
  const type = event?.type ?? "unknown";
  const sessionID = props.sessionID ?? "";

  if (type === "session.idle") {
    return {
      sessionID,
      title: "OpenCode",
      body: "Ready for input",
    };
  }

  if (type === "permission.asked") {
    const permission = shortText(props.permission ?? "Permission request", 60);
    const pattern = shortText((props.patterns ?? []).join(", "), 80);
    const details = pattern ? `${permission}: ${pattern}` : permission;
    return {
      sessionID,
      title: "OpenCode",
      body: shortText(details || "Permission needed"),
    };
  }

  if (type === "question.asked") {
    const first = props.questions?.[0];
    const header = shortText(first?.header ?? "Question", 50);
    const question = shortText(first?.question ?? "Input needed", 90);
    return {
      sessionID,
      title: "OpenCode",
      body: `${header}: ${question}`,
    };
  }

  return {
    sessionID,
    title: "OpenCode",
    body: "Input needed",
  };
}

export const AttentionNotifyPlugin = async ({ $, directory, worktree, project }) => {
  const scriptPath = new URL("../scripts/agent-attn-notify", import.meta.url).pathname;

  return {
    event: async ({ event }) => {
      if (!INPUT_NEEDED_EVENTS.has(event?.type)) return;

      const { sessionID, title, body } = extractDetails(event);
      const repo = basename(project?.name || worktree || directory);

      try {
        await $`${scriptPath} --event ${event.type} --session ${sessionID} --title ${title} --body ${body} --repo ${repo} --cwd ${directory || ""}`;
      } catch {
        // Best effort notification only.
      }
    },
  };
};
