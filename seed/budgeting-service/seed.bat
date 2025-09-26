@echo off
setlocal

set BASE_URL=%1
if "%BASE_URL%"=="" set BASE_URL=http://localhost:7778

echo Seeding Budgeting Service at %BASE_URL%
echo.

echo Creating income transactions...
echo.

curl -X POST "%BASE_URL%/api/bs/transactions/income" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 5000.00, \"currency\": \"Mdl\", \"source\": \"FafDonation\", \"description\": \"Monthly donation from FAF alumni association\", \"fundTarget\": \"FafCab\", \"referenceId\": \"DON-2024-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/income" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 2500.00, \"currency\": \"Mdl\", \"source\": \"PartnerDonation\", \"description\": \"Corporate sponsorship from local tech company\", \"fundTarget\": \"FafNgo\", \"referenceId\": \"CORP-2024-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/income" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 1200.00, \"currency\": \"Mdl\", \"source\": \"Fundraising\", \"description\": \"Charity event fundraising - bake sale and raffle\", \"fundTarget\": \"FafCab\", \"referenceId\": \"FUND-2024-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/income" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 800.00, \"currency\": \"Mdl\", \"source\": \"Other\", \"description\": \"Equipment rental fee from external organization\", \"fundTarget\": \"FafNgo\", \"referenceId\": \"RENT-2024-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/income" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 3000.00, \"currency\": \"Mdl\", \"source\": \"FafDonation\", \"description\": \"End of year donation from FAF board members\", \"fundTarget\": \"FafCab\", \"referenceId\": \"DON-2024-002\"}"

echo.
echo Creating expense transactions...
echo.

curl -X POST "%BASE_URL%/api/bs/transactions/expense" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 450.00, \"currency\": \"Mdl\", \"category\": \"Consumables\", \"description\": \"Office supplies - paper, pens, printer ink\", \"fundSource\": \"FafCab\", \"receiptUrl\": \"https://receipts.example.com/office-supplies-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/expense" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 1200.00, \"currency\": \"Mdl\", \"category\": \"Equipment\", \"description\": \"New projector for meeting room\", \"fundSource\": \"FafNgo\", \"receiptUrl\": \"https://receipts.example.com/projector-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/expense" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 350.00, \"currency\": \"Mdl\", \"category\": \"Utilities\", \"description\": \"Monthly internet and phone bill\", \"fundSource\": \"FafCab\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/expense" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 750.00, \"currency\": \"Mdl\", \"category\": \"Maintenance\", \"description\": \"Computer lab equipment maintenance and cleaning\", \"fundSource\": \"FafNgo\", \"receiptUrl\": \"https://receipts.example.com/maintenance-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/expense" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 300.00, \"currency\": \"Mdl\", \"category\": \"Other\", \"description\": \"Student event refreshments and snacks\", \"fundSource\": \"FafCab\", \"receiptUrl\": \"https://receipts.example.com/refreshments-001\"}"

curl -X POST "%BASE_URL%/api/bs/transactions/expense" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"amount\": 200.00, \"currency\": \"Mdl\", \"category\": \"Consumables\", \"description\": \"Cleaning supplies for office and labs\", \"fundSource\": \"FafNgo\"}"

echo.
echo Creating debt entries...
echo.

curl -X POST "%BASE_URL%/api/bs/debt" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"userId\": \"student-001\", \"amount\": 150.00, \"currency\": \"Mdl\", \"reason\": \"Damage\", \"description\": \"Accidentally spilled coffee on lab keyboard\", \"itemId\": \"KB-LAB-001\"}"

curl -X POST "%BASE_URL%/api/bs/debt" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"userId\": \"student-002\", \"amount\": 75.00, \"currency\": \"Mdl\", \"reason\": \"LostItem\", \"description\": \"Lost USB cable from computer lab\", \"itemId\": \"USB-C-002\"}"

curl -X POST "%BASE_URL%/api/bs/debt" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"userId\": \"student-003\", \"amount\": 300.00, \"currency\": \"Mdl\", \"reason\": \"Damage\", \"description\": \"Broke projector screen during presentation setup\", \"itemId\": \"PROJ-SCR-001\"}"

curl -X POST "%BASE_URL%/api/bs/debt" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"userId\": \"student-004\", \"amount\": 50.00, \"currency\": \"Mdl\", \"reason\": \"Overuse\", \"description\": \"Exceeded printing quota by 200 pages\", \"itemId\": \"PRINT-001\"}"

curl -X POST "%BASE_URL%/api/bs/debt" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"userId\": \"student-005\", \"amount\": 100.00, \"currency\": \"Mdl\", \"reason\": \"LostItem\", \"description\": \"Lost loaner laptop charger\", \"itemId\": \"CHRG-LAP-003\"}"

curl -X POST "%BASE_URL%/api/bs/debt" ^
  -H "Content-Type: application/json" ^
  -H "X-User-Id: admin-001" ^
  -H "X-User-Role: admin" ^
  -d "{\"userId\": \"student-006\", \"amount\": 25.00, \"currency\": \"Mdl\", \"reason\": \"Other\", \"description\": \"Late return fee for borrowed equipment\", \"itemId\": \"CAM-001\"}"

echo.
echo Seeding completed!
echo.
echo Summary:
echo - 5 income transactions created (total: 12,500 MDL)
echo - 6 expense transactions created (total: 3,250 MDL)
echo - 6 debt entries created (total: 700 MDL pending)
echo - Net balance should be: 9,250 MDL
echo.
echo Check balances at: %BASE_URL%/api/bs/balance

pause