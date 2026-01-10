import { spawn } from "node:child_process";
import { watch } from "node:fs";
import { join, basename } from "node:path";

const playNotificationSound = () => {
  if (process.platform === "darwin") {
    // macOS system sound; ignore errors if afplay not available
    spawn("afplay", ["/System/Library/Sounds/Glass.aiff"], {
      stdio: "ignore",
      shell: true,
    }).on("error", () => {
      process.stdout.write("\u0007");
    });
  } else {
    process.stdout.write("\u0007");
  }
};

const cwd = process.cwd();
const assetsDir = join(cwd, "assets");
const watchTargets = [
  { dir: join(assetsDir, "css"), task: "assets:minify" },
  { dir: join(assetsDir, "js"), task: "assets:minify" },
  { dir: join(assetsDir, "images"), task: "assets:images" },
  { dir: join(cwd, "odd"), task: "assets:odd" },
  { dir: join(cwd, "xslt"), task: "assets:odd" },
  // { dir: join(cwd, "xproc"), task: "assets:odd" },
];

// Ignore generated artifacts and temp files that may retrigger assets:odd
const shouldIgnore = (fullPath = "") => {
  const base = basename(fullPath);
  return (
    base.startsWith(".") ||
    base.endsWith(".stripped.xml") ||
    base.endsWith("~") ||
    base.endsWith(".swp")
  );
};

const taskState = new Map();
const getState = (task) => {
  if (!taskState.has(task)) {
    taskState.set(task, { running: false, pending: false, debounce: null });
  }
  return taskState.get(task);
};

const runTask = (task) => {
  const state = getState(task);
  const running = state.running;
  if (running) {
    state.pending = true;
    return;
  }
  state.running = true;
  const child = spawn("npm", ["run", task], {
    stdio: "inherit",
    shell: true,
  });
  child.on("exit", () => {
    if (task === "assets:odd") {
      console.log("✅ assets:odd finished");
      playNotificationSound();
    }
    state.running = false;
    if (state.pending) {
      state.pending = false;
      runTask(task);
    }
  });
};

const scheduleTask = (task) => {
  const state = getState(task);
  if (state.debounce) clearTimeout(state.debounce);
  state.debounce = setTimeout(() => runTask(task), 200);
};

watchTargets.forEach(({ dir, task }) => {
  watch(dir, { recursive: true }, (eventType, filename) => {
    const fullPath = filename ? join(dir, filename) : "";
    if (!filename || shouldIgnore(fullPath)) return;
    if (eventType === "rename" || eventType === "change") {
      scheduleTask(task);
    }
  });
});

console.log("Watching assets for changes:");
watchTargets.forEach(({ dir }) => console.log(`- ${dir}`));
