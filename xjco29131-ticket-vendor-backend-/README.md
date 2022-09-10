## Backend
***
This repository is the back-end management system of the ticketing system, based on the node.js.

### Dependencies
|name|version|
|--------|-------|
| node | 12.16.2 |
| express | 4.16.40 |
| sqlite3  | 5.0.2 |

**File Directory**

```
│  .gitignore
│  app.js
│  readme.md
│
├─bin
│      www
│
├─db
│      movie.db
│
├─public
│  ├─images
│  ├─javascripts
│  └─stylesheets
│          style.css
│
├─routes
│      admin.js
│      index.js
│      users.js
│
└─views
        error.pug
        index.pug
        layout.pug
```

**Run this system**

to run this project, run node app.js