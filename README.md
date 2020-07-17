Street Attractions
===

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
Find all the details on the progress of the app in the following document: https://docs.google.com/document/d/1-6k9EMiyZi9EFuiGj-W7SIGp9ClZ1rVFiTnw4UKUU1g/edit?usp=sharing
### Description
Lets you report if you've seen street performers you like for anyone in the area to stop by, integrates machine learning to learn the performers favorite spots. User can follow its favorites performers and categories, so they never miss out on their favorite perfomances. User can also donate money through the app if they are not carrying cash.

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
* User can see a feed of their favorites
* User can see categories and recommended posts for them
* User can use the map view
* User can edit his profile
* User can access details of a post including videos and pictures

**Optional Nice-to-have Stories**

* AI auto posts
* User has a favorite list
* User can follow others and not just access posts given on location
* Support for videos
* Supports Payout API

### 2. Screen Archetypes

* Register
    * User can register
* Log In
    * User can log in
* Stream
    * User can view other posts
* Explore
   * User can see categories
* Favorites
   * User can see stream limited to their favorites users, performers, and categories
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

* SlideOut Profile
* Stream
* Explore
* Favorites
* Map

**Flow Navigation** (Screen to Screen)

* Stream
   * Details
   * Create
* Map 
   * Details
   * Create
* Explore
   * Stream of only that category
* Favorites
   * Details
 
## Wireframes
https://www.figma.com/file/IdUodeaRXs9ybgWMVtnlmQ/Untitled?node-id=0%3A1

Screen drawings: https://drive.google.com/drive/folders/1hWSNX-2TlW5txHfIeGXf7gXeA-bHSS4u?usp=sharing

## Schema 
### Models
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| author |
   | profilePic    | File| author's profile picture |
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
   | Name      | String   | Name of the category|
   | Posts      | Relation   | Relation to the posts|
   #### Comment

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | Text      | String   | Text of the comment|
   | author      | Pointer to User   |author|
   #### Category

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user user (default field) |
   | Username      | String   | User's screename|
   | Password      | String   | User's password|
   | isPerformer   | Bool   | Define if user is simple user or has a performers account|
   | Payment name| String | Only available for performers to receive payments 
   | FollowingUsers | Relation   | Relation to the Users they are following|
   | FollowingCategories| Relation   | Relation to the Categories they are following|
   
### Networking
#### List of network requests by screen
   - Stream
      - (Read/GET) Query all posts based on user location
   - Explore
      - (Read/GET) Query all categories
   - Favorites
      - (Read/GET) Query all posts where author is favorited by user
      - (Read/GET) Query all posts where category is favorited by user
  - Details
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
      - (Create/POST) Create a new comment on a post
      - (Delete) Delete existing comment
   - Profile
      - (Create/POST) Create a new follow on a user
      - (Delete) Delete existing follow
   - Create Post Screen
      - (Create/POST) Create a new post object
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Update/PUT) Update user profile image
      - (Update/PUT) Update user location
#### Existing API 
   - Foursquare API (Search for locations to add performance to the map)
   - Payouts API (User can donate to performer in their profile )
