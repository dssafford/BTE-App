import { test, expect } from "@playwright/test";

test("home page renders without crashing", async ({ page }) => {
  const errors: string[] = [];
  page.on("pageerror", (err) => errors.push(String(err)));

  await page.goto("/");

  await expect(page).toHaveTitle(/BTE/i);
  expect(errors).toEqual([]);
});
