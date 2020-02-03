# WiseUp: A financial literacy app.

## Acknowledgements
The predecessor of WiseUp is QuickFin, a financial literacy app built by:
- Connor Buckley: Firebase Cloud Firestore integration with Swift.
- Emily Jin: UI design and documentation.
- Anthony Martinez: Administrative web portal and documentation.
- Sophie Wu: Administrative web portal and UI design.
- Jack Boyuan Xu: Various sign in integration with Swift. iOS frontend using UIKit.

However due to various limitations, not all of the original vision could be realized in QuickFin. **WiseUp is a further implementation and extension of the original vision of QuickFin**, built by team *"Three Wise (Wo)men"*:
- Aurora Xiao Tan: UI design facelift and backend data source.
- Frost Tianjian Xu: Virtual stocks trading feature and Python web scraper.
- Jack Boyuan Xu: Complete friend system and various bug fixes.

## Inspiration
We all have been taught how to manage our financial life in school... NOT! Financial awareness is missing in most homes and financial education is absent from most school systems throughout the US. According to Equifax, 49% of American adults who participated in the annual survey reported they don't have enough savings to cover three moths of living expenses, and an even more shocking 56% said they don't have any money left over at the end of the month. Being financially literate is one of the most important skills one should possess in life and our team, aptly named "Three Wise (Wo)men", is on a mission to popularize the essential financial knowledge in life in a fun and interactive way with our iOS application, WiseUp.

## What it does
WiseUp, at its core, is a sort of quiz application that awards users for correctly completing chapters, which are sets of questions. Each chapter has a central theme and completing them in various degrees of correctness may yield various degrees of rewards and achievements. We want to make the application fun to use not only to adults, but also to teenagers. The application is gamified as an incentive for our users to do well and compete against their friends on the leaderboard. With our in-game coin earned through answering questions correctly or competing in our Versus mode, users can buy shiny new avatars, XP/coin boosters, or even practice investing in real-world companies by buying virtual stocks.

## How we built it
We built the application entirely on the iOS platform because it is the platform we are most comfortable with. We took a purely programmatic approach to UI building and integrated quite a few Cocoapods to speed up development. Our backend is powered by Firebase Cloud Firestore which provided high-performance and extreme scalability. We have incorporated not only a traditional email/password login, but also Google Sign In and Facebook Sign In for an even smoother user experience. We retrieve our stock prices with a Python server that scrapes Yahoo Finance for price data.

## What's next for WiseUp
We plan to finish implementing the leaderboard and Versus mode, eventually releasing it to the App Store.
