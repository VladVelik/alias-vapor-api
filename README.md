<h1 align="left">Backend for <a href="https://en.wikipedia.org/wiki/Alias_(board_game)" target="_blank">Alias </a>game</h1>

<h2 align="left">Main functions</h2>

1. User registration - http://127.0.0.1:8080/users/register
```
{
    "username": "stan",
    "email": "stan@stan.com",
    "password": "stan"
}
```

2. User authorization by login and password - http://127.0.0.1:8080/users/auth
```
{
    "login_status": true
}
```

3. Join an open room - http://127.0.0.1:8080/rooms/enter
```
{
    "room_id": ...
}
```
4. Join a room by code - http://127.0.0.1:8080/rooms/inv_code
```
{
    "invitation_code": "five"
}
```
5. Create a room - http://127.0.0.1:8080/rooms/create
```
{
    "is_private": true,
    "invitation_code": "ten",
    "received_points": 5,
    "game_status": false
}
```
6. Create a team in a room (only for admin) - http://127.0.0.1:8080/teams/create

With automatic points replenishment of 0 units
```
{
    "roomID": "FE6D46F6-0D05-493A-A654-A1E4343046BB",
    "name": "s",
    "points": 0
}
```
7. Start a game session (admin) - http://127.0.0.1:8080/rooms/startGame/103C1E3C-9BE5-4184-843D-54BAA0B9B27A
8. Pause a game session (admin) - http://127.0.0.1:8080/rooms/pauseGame/103C1E3C-9BE5-4184-843D-54BAA0B9B27A
9. Change the number of teams (admin) - http://127.0.0.1:8080/teams/6CBAAB3C-E43F-46DB-89ED-1BFDDF9E304D

Delete all and start over apparently
10. Remove a player from a room/team (admin)

Room - http://127.0.0.1:8080/participants/fromRoom/F8DAF119-E146-467A-993D-D07DB712C46C

Team - http://127.0.0.1:8080/participants/fromTeam/F8DAF119-E146-467A-993D-D07DB712C46C

11. Give admin rights to a player (admin) - http://127.0.0.1:8080/participants/role
```
{
    "participant_id": "000",
    "role": "admin"
}
```
12. Delete a room (admin) - DELETE ROOM +
13. Join a team in a room - ENTER A TEAM +
14. Change the number of points awarded per round (room points) - CHANGE POINTS NUMBER +
15. Each team should play against every other team + (included in START GAME)

<h2 align="left">Secondary functions</h2>

1. Get a list of open rooms - GET ALL OPEN ROOMS +
2. Get a list of teams in a room - GET ALL TEAMS OF ROOM +
3. Get a list of users in a team - GET USERS OF TEAM +
4. Get words for the game +
5. Resume the game - RESUME GAME +
