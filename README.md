# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Notes

* Associating the messages to the game may be too light an approach; some more robust 
  could be to associate 2 messages to each **round**. But then the Round would be 
  even more split, with all its attributes in duplicates, one for the Earther and 
  one for the Explorer (`earther_message`, `earther_hand`, `explorer_message`, etc.) 
  Which would indicate that even more splitting and shuffling of associations could be 
  necessary (e.g. with a `Role` join model between `Game` and `Player`). These are just 
  thoughts, and going down this rabbit hole is not a priority for now.

* Please install mailcatcher in dev
