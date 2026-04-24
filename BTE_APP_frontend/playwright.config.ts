import { defineConfig, devices } from "@playwright/test";

// Phase 1 Playwright setup. Keeps the test surface minimal (single
// Chromium project, one smoke spec) — the full /walk iOS flow and study
// flow tests land when their features do.
export default defineConfig({
  testDir: "./e2e",
  timeout: 30_000,
  expect: { timeout: 5_000 },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  reporter: process.env.CI ? "dot" : "list",
  use: {
    baseURL: "http://localhost:3000",
    trace: "on-first-retry",
  },
  webServer: {
    // Next dev is fine for now; when builds stabilize, swap to
    // `next build && next start` for faster repeat runs.
    command: "npm run dev",
    url: "http://localhost:3000",
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
  ],
});
