# Copilot / AI Agent Instructions for Circlez

This repository is a single-file legacy frontend app. The goal of these instructions is to get an AI coding agent immediately productive with accurate, actionable details discovered in the codebase.

1) Big picture
- Single static HTML app: the entire UI + client logic lives in `legacy.html` (no build step, no server code in repo).
- UI is React pulled from CDNs (`react`, `react-dom`) and uses Supabase (client + Storage) for backend services.
- Data flows: browser JS -> Supabase REST/JS client -> Postgres tables (`profiles`, `posts`, `reactions`, `relationships`) and Storage bucket `media` (public URLs).
- Auth: Supabase OAuth (Google used in the file). Session state is handled client-side with `supabaseClient.auth`.

2) Key integration points & constants (copy from `legacy.html`)
- Supabase URL and anon key are embedded as `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
- Storage bucket: `media` (uploads use paths like `{userId}/{folder}/{timestamp}_{safeName}`).
- DB tables referenced: `profiles`, `posts`, `reactions`, `relationships`.
- Column oddities to respect when editing DB logic:
  - `username_colc` (color column on profiles)
  - `profile_photo_` (trailing underscore)
  - `avatar_url` vs `profile_photo_` (two different profile assets)
- Admin detection is a hard-coded email: `uncleizzo@gmail.com` (see `isAdmin()`).

3) Patterns & conventions to follow
- No JSX: UI is constructed with `React.createElement(...)`. When adding components, follow same style unless you switch the repo to a build pipeline (do not add a build step without owner's approval).
- Safe alerts: use `safeAlert(msg)` instead of direct `alert()` to prevent runtime errors in non-browser contexts.
- File uploads: always call `uploadToBucket(file, userId, folder)` and expect a public URL. Respect max sizes (constants defined near top):
  - `MAX_INTRO_VIDEO_BYTES = 25 * 1024 * 1024`
  - `MAX_POST_VIDEO_BYTES = 25 * 1024 * 1024`
  - `MAX_PROFILE_PHOTO_BYTES = 10 * 1024 * 1024`
  - `MAX_POST_IMAGE_BYTES = 10 * 1024 * 1024`
- Database defensive checks: code treats some PostgREST errors specially (e.g., `PGRST116`, `PGRST204`)—preserve that error handling when changing queries.
- Use `maybeSingle()`/`select(...).maybeSingle()` and `upsert(..., { onConflict: "owner_id,member_id" })` where appropriate (see `setCircleForMember`).

4) Run / debug workflow
- There is no build system. To run locally, serve the folder and open `legacy.html` in a browser. Example quick commands:

```bash
# from repo root
python3 -m http.server 8000
# then open http://localhost:8000/legacy.html
```

- Debugging: use browser DevTools console to view `console.log`/`console.error` prints. Many flows include `safeAlert` and `console.error` for failures.

5) Security & sensitive notes
- The repo currently contains a publishable Supabase anon key in `legacy.html`. Treat it as public but avoid committing server keys. If you need to rotate keys or move them into env/config, coordinate with the repo owner.
- Do not attempt to perform server-side migrations from the agent unless explicit instructions and DB credentials are provided.

6) Where to look for examples when changing behavior
- Profile creation/loading and special-case admin/verification: `loadProfile()` (search for `loadProfile` in `legacy.html`).
- Posting flow (uploads, content parsing, youtube extraction): `handlePost()` and helpers `extractYouTubeUrl()` / `getYouTubeEmbedUrl()`.
- Reactions & optimization: `loadReactionsForPosts()` uses `.in("post_id", postIds)` and builds `reactionsByPost` map structure.
- Search and circle interactions: `handleUserSearch()` and `setCircleForMember()` / `setMyCircleForUser()`.

7) Safe change guidance for agents
- Preserve the single-file runtime approach unless asked to modernize (don't introduce a bundler/JSX transform without explicit permission).
- Keep network calls and DB table names unchanged unless the change is coordinated; unit tests or integration tests are not present.
- When modifying UI strings or text flow, update only inside `legacy.html` and preserve existing element structure where possible because many UI references rely on string IDs/classes.

8) Examples to paste when proposing changes
- To add a new DB query, mirror the existing `supabaseClient.from("profiles").select(...).maybeSingle()` pattern and check for `error.code` values.
- To upload a new media file, call `const url = await uploadToBucket(file, user.id, "images");` and then include `image_url` in payload for `posts`.

If any part of the app's environment is incomplete (missing CI, migrations, or server code) tell me which area to expand. Would you like me to:
- Commit this file now and open a PR? or
- Add a tiny README with the `python3 -m http.server` run instructions as a companion file?

Please tell me if anything here is unclear or if you want additional detail for any of the sections above.