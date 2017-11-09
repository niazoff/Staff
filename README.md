

Staff is an iOS app that fetches and displays the first page of videos in the [Vimeo Staff Picks channel](https://developer.vimeo.com/api/endpoints) ❤️. I inherited it as "BogusCode" and my task was to

> elevate it to [my] own standard of quality. Correct all of the issues [I] see, refactor as [I] see fit, and make BogusCode clean, clear, performant and scalable.

and to create

> * A bug-free app that displays the Staff Picks list
> * Architectural clarity, architecture that can scale
> * Clean, clear, and communicative UI

From the outset I knew I wanted (and needed) to create an app that was future-proof and scalable. One that can adapt to API changes and additional features I would want to add down the road. One of my first steps was to incorporate the new `Codable` protocol so that JSON would be able to be parsed safely, efficiently and cleanly. This, joined with a new `Video` object to keep things more organized and architecturally stable, replaced simply accessing the raw JSON data and creating cells out of it.

I strongly believe in keeping view controllers as simple and short as possible. This avoids the notorious massive view controller problem. Although keeping with MVC standards, I've spread out code as much as possible. Besides taking out JSON parsing, which is now mostly done behind the scenes as explained above, a new `APIHelper` struct was created to handle API properties and methods. With these changes I was able to check off most of my list but I wanted to do more.

Search was obviously something I knew right away needed to be added. I used `UISearchController` and the `UISearchResultsUpdating` protocol to filter the video data and reload with the proper data. I also added the video's user's name, the amount of views if available and the amount of likes in each cell. The final result is a beutiful app that is clean, architecturally stable 🏛 and a pleasure to use 😊.