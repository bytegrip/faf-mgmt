@echo off
setlocal

set BASE_URL=%1
if "%BASE_URL%"=="" set BASE_URL=http://localhost:7777

echo Seeding Lost Found Service at %BASE_URL%
echo.

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-001" ^
  -d "{\"type\": 0, \"title\": \"Lost iPhone 14 Pro\", \"description\": \"Black iPhone 14 Pro with cracked screen protector. Has a blue case with my initials 'JD' on it. Lost around the university library second floor near the study pods.\", \"itemCategory\": 0, \"location\": \"University Library, 2nd Floor Study Area\", \"contactInfo\": \"john.doe@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-002" ^
  -d "{\"type\": 0, \"title\": \"Lost Black Leather Wallet\", \"description\": \"Small black leather wallet containing driver license, credit cards, and some cash. Last seen at the campus cafeteria during lunch time.\", \"itemCategory\": 4, \"location\": \"Campus Cafeteria, Main Dining Hall\", \"contactInfo\": \"sarah.smith@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-003" ^
  -d "{\"type\": 0, \"title\": \"Lost Red Backpack\", \"description\": \"Medium-sized red Nike backpack with laptop compartment. Contains textbooks for Computer Science classes and a water bottle. Lost near the engineering building.\", \"itemCategory\": 1, \"location\": \"Engineering Building, East Entrance\", \"contactInfo\": \"mike.johnson@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-007" ^
  -d "{\"type\": 0, \"title\": \"Lost Car Keys\", \"description\": \"Silver Toyota car keys with black leather keychain. Has a small flashlight attached. Lost somewhere between parking lot C and the main building.\", \"itemCategory\": 4, \"location\": \"Parking Lot C to Main Building\", \"contactInfo\": \"alex.taylor@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-008" ^
  -d "{\"type\": 0, \"title\": \"Lost Blue Hoodie\", \"description\": \"Navy blue university hoodie, size Large. Has my name embroidered on the left chest. Lost in the student lounge area.\", \"itemCategory\": 2, \"location\": \"Student Lounge, Main Floor\", \"contactInfo\": \"emma.wilson@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-009" ^
  -d "{\"type\": 0, \"title\": \"Lost Prescription Glasses\", \"description\": \"Black framed prescription glasses in a brown leather case. Very important as I can't see without them. Lost near the chemistry lab.\", \"itemCategory\": 4, \"location\": \"Chemistry Building, Lab Area\", \"contactInfo\": \"robert.jones@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-010" ^
  -d "{\"type\": 0, \"title\": \"Lost Laptop Charger\", \"description\": \"MacBook Pro charger with USB-C connector. 67W power adapter with white cable. Left it in the library computer lab.\", \"itemCategory\": 0, \"location\": \"University Library, Computer Lab\", \"contactInfo\": \"jessica.martinez@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-004" ^
  -d "{\"type\": 1, \"title\": \"Found White AirPods\", \"description\": \"Found white Apple AirPods in charging case near the gym entrance. Case has some scratches but AirPods appear to be in good condition.\", \"itemCategory\": 0, \"location\": \"Campus Gym, Main Entrance\", \"contactInfo\": \"lisa.brown@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-005" ^
  -d "{\"type\": 1, \"title\": \"Found Gold Ring\", \"description\": \"Small gold ring with initials engraved inside. Found in the library restroom on the first floor. Looks like it might be a wedding ring or class ring.\", \"itemCategory\": 3, \"location\": \"University Library, 1st Floor Restroom\", \"contactInfo\": \"david.wilson@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-006" ^
  -d "{\"type\": 1, \"title\": \"Found Blue Baseball Cap\", \"description\": \"Navy blue baseball cap with university logo. Found on bench outside the student union building. Cap is in good condition, appears to be recently dropped.\", \"itemCategory\": 2, \"location\": \"Student Union Building, Outside Benches\", \"contactInfo\": \"amy.davis@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-011" ^
  -d "{\"type\": 1, \"title\": \"Found Black Umbrella\", \"description\": \"Large black umbrella with wooden handle. Found outside the administration building after yesterday's rain. Still in good working condition.\", \"itemCategory\": 4, \"location\": \"Administration Building, Front Steps\", \"contactInfo\": \"chris.anderson@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-012" ^
  -d "{\"type\": 1, \"title\": \"Found Silver Watch\", \"description\": \"Men's silver wristwatch with black leather strap. Digital display, looks like a fitness tracker. Found in the gym locker room.\", \"itemCategory\": 3, \"location\": \"Campus Gym, Men's Locker Room\", \"contactInfo\": \"michelle.garcia@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-013" ^
  -d "{\"type\": 1, \"title\": \"Found Green Water Bottle\", \"description\": \"Insulated green water bottle with stickers from various hiking trails. Found on a table in the outdoor eating area.\", \"itemCategory\": 4, \"location\": \"Outdoor Dining Area, Table 12\", \"contactInfo\": \"kevin.lee@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-014" ^
  -d "{\"type\": 1, \"title\": \"Found Purple Scarf\", \"description\": \"Long purple wool scarf, very soft and warm. Found hanging on a chair in the mathematics building classroom 205.\", \"itemCategory\": 2, \"location\": \"Mathematics Building, Room 205\", \"contactInfo\": \"natalie.thompson@university.edu\"}"

curl -X POST "%BASE_URL%/api/lfs/posts" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: user-015" ^
  -d "{\"type\": 1, \"title\": \"Found USB Drive\", \"description\": \"Small blue USB flash drive, 32GB capacity. Found plugged into a computer in the computer science lab. Appears to contain student assignments.\", \"itemCategory\": 0, \"location\": \"Computer Science Building, Lab 101\", \"contactInfo\": \"daniel.rodriguez@university.edu\"}"

echo.
echo Seeding completed! 15 posts have been created.
echo 8 Lost items and 7 Found items added to the system.

pause