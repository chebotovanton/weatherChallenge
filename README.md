# Anton's notes on the submitted coding task

 1. It's a big task. There's definitely a lot to improve still, but hopefully, that's enough of a showcase of my skill set
 2. Please check the `TODO:` marks in the code to see my comments on what could be improved further

## What's done
1. Location search by name (API seems to only support full name search)
2. Location details page with current weather and forecast
3. Loading the weather icon for both current weather and forecast items
4. Adding locations to favorites
5. Search page reacts to adding/removing locations to favorites in a more or less reasonable way

## My priorities
1. I've been told this coding task is not so much about UI, so I concentrated on architecture, testability, and overall good practices
2. I tried to introduce flexibility where possible. Example: location details page items approach
3. There's a reasonable level of abstraction where needed. Example: Favorites storage implementation is hidden from its users
4. The code is more or less ready to be split into separate SPM modules

## What's not done so far
 1. I haven't had time to check things like accessibility or dark mode support
 2. No actual modules introduced to the project
 3. I've only covered 2 classes with unit tests, but this should give you an idea of how I plan to approach testing
 4. No UI/snapshot testing for the views, unfortunately
 5. I only tested it on the iOS18 iPhone 16 Pro. Some UI bugs may be there on different devices and iOS versions
 6. Localisation and styling are non-existent and would require more dependencies injected everywhere


Hope you have a good time reviewing this task!
Cheers!
