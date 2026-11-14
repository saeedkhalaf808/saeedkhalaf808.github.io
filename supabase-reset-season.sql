-- Run this AFTER you have uploaded the new index.html to GitHub.
-- It wipes the old leaderboard, 1v1 results and queue so everyone starts fresh under the new rules.
delete from leaderboard;
delete from matches;
delete from queue;
