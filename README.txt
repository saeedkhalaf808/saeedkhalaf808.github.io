OVERLOAD: PUT IT ON GOOGLE PLAY (no Android Studio needed)

Before you start: open privacy.html in a text editor and replace YOUR-EMAIL-HERE with your real email.

PART 1: PUT THE GAME ON THE INTERNET (free)
1. Sign in at github.com. Create a new PUBLIC repository named exactly:  saeedkhalaf808.github.io
2. Click "Add file" > "Upload files". Drag in everything from this folder (index.html, manifest.webmanifest, sw.js, privacy.html and the png files).
3. Also click "Add file" > "Create new file", name it  .nojekyll  (leave it empty), and commit. (Hidden files often get skipped by uploads.)
4. Repository Settings > Pages > Build and deployment > Deploy from a branch > main, root. Save. Wait a minute or two.
5. Open https://saeedkhalaf808.github.io on your Android phone in Chrome. The game should load. Your privacy policy will be at https://saeedkhalaf808.github.io/privacy.html

PART 2: TURN IT INTO AN ANDROID APP
1. Go to pwabuilder.com, enter https://saeedkhalaf808.github.io and press Start.
2. When the report finishes, choose Package for stores > Android > Google Play.
3. Package ID: com.nih.overload (you can change it, but it can NEVER be changed after you publish). App name: Overload. Version 1.
4. Let it generate a new signing key. Download the zip.
5. KEEP THE SIGNING KEY FILE AND ITS PASSWORD SAFE FOREVER (back them up in two places). If you lose them you cannot update the app.
6. The zip contains an .aab file (this is what you upload) and an assetlinks.json file. In your GitHub repo, create the file  .well-known/assetlinks.json  and paste in the contents. This removes the browser bar so it looks like a real app.
7. If Google Play later rejects the file for targeting an old Android version, tell me and we will rebuild it with a different tool.

PART 3: GOOGLE PLAY CONSOLE
1. Create a developer account at play.google.com/console (one-off USD 25 fee, you need ID verification). Choose "Personal".
2. Create app: name Overload, Game, Free.
3. Testing > Closed testing: create a release, upload the .aab, add 12+ testers by email (they need Android phones and Gmail), and send them the opt-in link. They must stay opted in for 14 days in a row.
4. While you wait, fill in: store listing (icon-512.png, feature-graphic-1024x500.png, at least 2 screenshots taken on your phone), privacy policy URL, content rating questionnaire, Data safety form (answer: no data collected), target audience.
5. After 14 days, apply for Production access in the Play Console. Review can take several days.

LATER: ads and in-app purchases need a different build (a native wrapper such as Capacitor) because this web-app version cannot show Google AdMob ads. The game files stay the same.


ONLINE LEADERBOARD (optional, so friends can compete with each other)
By default the leaderboard shows scores saved on each person's own phone only. To make a shared one:
1. Make a free account at supabase.com and create a new project.
2. Open the SQL Editor, paste in everything from supabase-setup.sql, and press Run.
3. Go to the project settings, API section. Copy the Project URL and the public key (it may be called anon or publishable).
   Do NOT use the secret / service_role key. Never share that one.
4. In index.html, find the line:  const LB={url:'',key:''};
   and put your values between the quotes, like  const LB={url:'https://abc.supabase.co',key:'your-public-key'};
5. Upload the changed index.html to GitHub again.
Note: anyone could post a fake score, because there is no cheat protection yet. It is fine for friends.


1V1 MATCHES (needs the online leaderboard to be set up first)
Run supabase-update-1v1.sql once in the Supabase SQL Editor. Then upload the new index.html to GitHub.
One player taps Play on 1v1 > Create a match and sends the 5 letter code. The friend taps Join match and types it in.
Both play the same board for 60 seconds. The results screen shows who won once both have finished.


OPEN QUEUE FOR 1V1 (Find an opponent)
Run supabase-update-queue.sql once in the Supabase SQL Editor, then upload the new index.html to GitHub.
Players tap 1v1 > Find an opponent. The first person waits in the queue, the next person to search is paired with them,
and both get a 3 second countdown, then play the same board for 60 seconds.
