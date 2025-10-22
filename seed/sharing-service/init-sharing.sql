CREATE TABLE IF NOT EXISTS "Objects" (
                                         "Id" UUID PRIMARY KEY,
                                         "Name" TEXT NOT NULL,
                                         "Type" TEXT NOT NULL,
                                         "OwnerType" TEXT NOT NULL,        
                                         "OwnerUserId" TEXT,              
                                         "Condition" TEXT NOT NULL,        
                                         "Notes" TEXT,
                                         "ActiveRentalId" UUID,            
                                         "CreatedBy" TEXT,
                                         "CreatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
    );

CREATE TABLE IF NOT EXISTS "Rentals" (
                                         "Id" UUID PRIMARY KEY,
                                         "ObjectId" UUID NOT NULL,
                                         "RenterId" TEXT NOT NULL,
                                         "Status" TEXT NOT NULL,          
                                         "DueAt" TIMESTAMP NOT NULL,
                                         "CreatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "CheckedOutAt" TIMESTAMP,
    "ReturnedAt" TIMESTAMP,
    CONSTRAINT fk_object FOREIGN KEY("ObjectId") REFERENCES "Objects"("Id")
    );

CREATE TABLE IF NOT EXISTS "DamageReports" (
                                               "Id" UUID PRIMARY KEY,
                                               "ObjectId" UUID NOT NULL,
                                               "ReportedBy" TEXT NOT NULL,
                                               "Description" TEXT NOT NULL,
                                               "Severity" TEXT NOT NULL, 
                                               "ReportedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_damage_object FOREIGN KEY("ObjectId") REFERENCES "Objects"("Id")
    );

INSERT INTO "Objects" ("Id", "Name", "Type", "OwnerType", "Condition", "CreatedBy", "CreatedAt", "UpdatedAt")
SELECT gen_random_uuid(), 'Drill', 'Tool', 'PERSONAL', 'Good', 'seed_user', NOW(), NOW()
    WHERE NOT EXISTS (SELECT 1 FROM "Objects");

INSERT INTO "Objects" ("Id", "Name", "Type", "OwnerType", "Condition", "CreatedBy", "CreatedAt", "UpdatedAt")
SELECT gen_random_uuid(), 'Ladder', 'Tool', 'PERSONAL', 'Good', 'seed_user', NOW(), NOW()
    WHERE NOT EXISTS (SELECT 1 FROM "Objects");

INSERT INTO "Rentals" ("Id", "ObjectId", "RenterId", "Status", "DueAt", "CreatedAt")
SELECT gen_random_uuid(), (SELECT "Id" FROM "Objects" LIMIT 1), 'test_user', 'PENDING', NOW() + INTERVAL '7 days', NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Rentals");

INSERT INTO "DamageReports" ("Id", "ObjectId", "ReportedBy", "Description", "Severity", "ReportedAt")
SELECT gen_random_uuid(), o."Id", 'student_alex',
       'Ladder is slightly bent after use in the workshop.', 'MINOR', NOW()
FROM "Objects" o
WHERE o."Name" = 'Ladder'
  AND NOT EXISTS (SELECT 1 FROM "DamageReports" WHERE "Description" LIKE 'Ladder is slightly bent%');

INSERT INTO "DamageReports" ("Id", "ObjectId", "ReportedBy", "Description", "Severity", "ReportedAt")
SELECT gen_random_uuid(), (SELECT "Id" FROM "Objects" WHERE "Name" = 'Drill' LIMIT 1), 'student_maria',
       'Drill bit is missing and motor overheats.', 'MAJOR', NOW()
WHERE NOT EXISTS (SELECT 1 FROM "DamageReports" WHERE "Description" LIKE 'Drill bit is missing%');
