# Pokédex

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)

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

* User able to create account
* User able to login
* User able to favorite and view Pokémon
* User able to view random Pokémon
* User able to view Pokémon based on input Pokédex number
* User able to guess Pokémon by cry
* User able to guess Pokémon by name

**Optional Nice-to-have Stories**

* User able to see comptetive movesets for specific Pokémon

### 2. Screen Archetypes

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

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Pokémon favorite list
* Pokémon random display
* Pokémon display based on user input
* Pokémon display based on Pokémon cry
* Pokémon display based on Pokémon name

**Flow Navigation** (Screen to Screen)

* Login/Sign Up Screen  
   => Favorite Pokémon list Screen
* Favorite List Screen  
   => Login screen by logout  
   => Pokémon specific details page
* Random Pokemon Screen   
   => Login screen by logout
* Pokemon by Pokedex number screen   
   => Login screen by logout
* Pokemon by cry screen   
   => Login screen by logout
* Pokemon by name screen   
   => Login screen by logout
