<h1 align="left">Backend for <a href="https://en.wikipedia.org/wiki/Alias_(board_game)" target="_blank">Alias </a>game</h1>
<h3 align="left">All requests except the first one require authorization</h3>
<h2 align="left">Main functions</h2>

1. User registration - http://127.0.0.1:8080/users/register [POST]
```
{
    "username": "stan",
    "email": "stan@stan.com",
    "password": "stan"
}
```

2. User authorization by login and password - .../users/auth [PUT]
```
{
    "login_status": true
}
```

3. Join an open room - .../rooms/enter [POST]
```
{
    "room_id": ...
}
```
4. Join a room by code - .../rooms/inv_code [POST]
```
{
    "invitation_code": "five"
}
```
5. Create a room - .../rooms/create [POST]
```
{
    "is_private": true,
    "invitation_code": "ten",
    "received_points": 5,
    "game_status": false
}
```
6. Create a team in a room (only for admin) - .../teams/create [POST]

With automatic points replenishment of 0 units
```
{
    "roomID": "room_UUID",
    "name": "s",
    "points": 0
}
```
7. Start a game session (admin) - .../rooms/startGame/*room_UUID [PUT]
8. Pause a game session (admin) - .../pauseGame/*room_UUID [PUT]
9. Change the number of teams (admin) - .../teams/*room_UUID [DELETE]

Delete all and start over apparently

10. Remove a player from a room/team (admin)

Room - .../participants/fromRoom/*room_UUID [DELETE]

Team - .../fromTeam/*team_UUID [DELETE]

By himself - .../participants/fromRoomSelf/*id [DELETE]

11. Give admin rights to a player (admin) - .../participants/role [PUT]
```
{
    "participant_id": "000",
    "role": "admin"
}
```
12. Delete a room (admin) - .../rooms/*room_UUID [DELETE]
13. Join a team in a room - .../teams/enter [PUT]
```
{
    "teamID": "*team_UUID"
}
```
14. Change the number of points awarded per round (room points) - .../rooms/points/*room_UUID [PUT]
```
{
    "points": 10
}
```
15. Each team should play against every other team - Included in START GAME
16. Delete user (account) - .../users/*user_id* [DELETE]
17. Create few teams (admin) - .../teams/fewCreate/*roomID [POST]
18. Add points to team - .../teams/addPoints/*teamID [PUT]
19. Delete all teams in room (admin) - .../teams/*room_id [DELETE]
20. Enter room - .../rooms/enter [POST]
21. Enter room via invitation code - .../rooms/*inv_code [POST]
22. Make room private (for room founder) - .../rooms/makePrivate/*roomID [PUT]
23. Get all open rooms - .../rooms/open [GET]
24. Get all users without team in room - .../rooms/noTeamUsers/*roomID [GET]
25. Get all users of each team - .../rooms/allUsersOfEachTeam/*roomID [GET]
26. Get points of room - .../rooms/points/*roomID [GET]
27. Get inv code & count of team in room - .../rooms/settings/*roomID [GET]

<h2 align="left">Secondary functions</h2>

1. Get a list of open rooms - .../rooms/open [GET]
2. Get a list of teams in a room - .../teams/*room_UUID [GET]
3. Get a list of users in a team - .../teams/users/*team_UUID [GET]
4. Get words for the game --
5. Resume the game - .../rooms/resumeGame/*room_UUID [PUT]
6. Enter team - .../teams/*enter route [PUT]
7. Start the game - .../rooms/startGame/*roomID [PUT]
8. Pause the game - .../rooms/pauseGame/*roomID [PUT]
