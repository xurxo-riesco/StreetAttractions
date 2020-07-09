Street Attractions
===

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Lets you report if you've seen street performers you like for anyone in the area to stop by, integrates machine learning to learn the performers favorite spots. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Entertaiment
- **Mobile:** User experience is marked by the use of camera, location, and maps. Real time data and notifications are also an enhancement of the experience
- **Story:** Everyone is welcome the app as it supports any street performers or even street art sales, since the events are free and near your real time location anyone can benefit from using the app.
- **Market:** The userbase of the app is highly scalable since it's not focus in a niche group or spefici audience
- **Habit:** The app should be pretty habbit forming as it enhances the experience of going siteseeing and stopping by performers or even adding entertaiment to any walk. The user can consume content just by stopping by or create need data by being the firsts to post a performance
- **Scope:** The stripped down should have the map working and the posibility to add data, in the future, or if time permitting, a reward system or other profile pictures could be implemented as improvement. The basic idea by itself is also well defined.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register
* User can log in
* User can post 
* User can view other posts
* User can use the map view
* User can edit his profile
* User can access details of a post including videos and pictures

**Optional Nice-to-have Stories**

* AI auto posts
* User has a favorite list
* User can follow others and not just access posts given on location

### 2. Screen Archetypes

* Register
    * User can register
* Log In
    * User can log in
* Stream
    * User can view other posts
* Map
    * User can use the map view
* Create
    * User can post
* Details
    * User can access details of a post including videos and pictures
* Profile
    * User can edit his profile

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream
* Map
* SlideOut Profile

**Flow Navigation** (Screen to Screen)

* Stream
   * Details
   * Create
* Map 
   * Details
   * Create
## Wireframes
https://www.figma.com/file/IdUodeaRXs9ybgWMVtnlmQ/Untitled?node-id=0%3A1

## Schema 
### Models
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| image author |
   | Media         | File     | Media that user posts |
   | caption       | String   | image caption by author |
   | comments      | Relation   | Relation to the comments |
   | likes         | Relation   | Relation to the likes |
   | likesCount    | Number   | number of likes for the post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   |Location| TBD | Location of the performance
   #### Category

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | Posts      | Relation   | Relation to the posts|
   #### Category

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user user (default field) |
   | Username      | String   | User's screename|
   | Password      | String   | User's password|
   | isPerformer   | Bool   | Define if user is simple user or has a performers account|
   | FollowingUsers | Relation   | Relation to the Users they are following|
   | FollowingCategories| Relation   | Relation to the Categories they are following|
      
