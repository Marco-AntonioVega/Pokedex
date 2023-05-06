# Pokédex

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Video Walkthrough](#Video-Walkthrough)
4. [Screen Archetypes](#Screen-Archetypes)
5. [Navigation](#Navigation)

## Overview
### Description
Users can use interactive Pokémon quizzes and activities to learn more about the Pokemon world.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Entertainment
- **Mobile:** This app would be primarily developed for mobile but would be just as viable on a computer.
- **Story:** Users can learn about Pokémon and take interactive quizzes.
- **Market:** Any individual could choose to use this app, but Pokémon fans may enjoy it the most.
- **Habit:** This app could be used as often or unoften as the user wants to learn and interact with Pokémon facts.
- **Scope:** First we would implement all of the interactive pages and activities, then maybe this could evolve into an application that has more informational functions rather than interactive. Some examples include incorporating databases that hold Pokémon moves, items, and strategies. A Pokémon news section is another possibility.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User able to create account
- [x] User able to login
- [x] User able to favorite and view Pokémon
- [x] User able to view random Pokémon
- [x] User able to view Pokémon based on input Pokédex number
- [x] User able to guess Pokémon by cry
- [x] User able to guess Pokémon by name

**Optional Nice-to-have Stories**

- [ ] User able to see comptetive movesets for specific Pokémon
- [ ] User able to see Pokémon moves
- [ ] User able to see Pokémon items
- [ ] User able to see Pokémon news

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<a href="https://www.loom.com/share/bfa407d1d8e742f69dc632adac537ee6">
    <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/bfa407d1d8e742f69dc632adac537ee6-with-play.gif">
</a>

## Screen Archetypes

* Login screen
   * User able to login
* Signup screen
    * User able to make new account
* Pokémon favorite list
    * User able to view favorite Pokémon list
    * User able to click on Pokémon to view info
* Random Pokémon Display
   * User able to view random Pokémon
* Pokémon Display Based on user input
    * User able to view Pokémon based on user input
* Pokemon display based on Pokémon cry
    * User able to listen to Pokémon cry
    * User able to guess Pokémon by cry
* Pokémon display based on Pokémon name
    * User able to guess Pokémon by name

## Navigation

**Tab Navigation** (Tab to Screen)

* Pokémon favorite list
* Pokémon random display
* Pokémon display based on user input
* Pokémon display based on Pokémon cry
* Pokémon display based on Pokémon name

**Flow Navigation** (Screen to Screen)

* Login/Sign Up Screen<br />
   => Favorite Pokémon list Screen
* Favorite List Screen<br />
   => Login screen by logout<br />
   => Pokémon specific details page
* Random Pokemon Screen<br />
   => Login screen by logout
* Pokemon by Pokedex number screen<br /> 
   => Login screen by logout
* Pokemon by cry screen<br />
   => Login screen by logout
* Pokemon by name screen<br />
   => Login screen by logout
