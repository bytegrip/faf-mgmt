CREATE EXTENSION IF NOT EXISTS "pgcrypto";


CREATE TABLE IF NOT EXISTS "Initiatives" (
                                             "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "Title" VARCHAR(200) NOT NULL,
    "Description" VARCHAR(2000),
    "Qty" INT NOT NULL,
    "Goal" DECIMAL(18,2) NOT NULL,
    "Raised" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "Currency" TEXT NOT NULL,
    "Deadline" TIMESTAMP NOT NULL,
    "TargetType" TEXT NOT NULL,
    "TargetSubtype" VARCHAR(200),
    "Status" TEXT NOT NULL,
    "CreatedBy" VARCHAR(200) NOT NULL,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
    );


CREATE TABLE IF NOT EXISTS "Donations" (
                                           "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "InitiativeId" UUID NOT NULL,
    "UserId" VARCHAR(200) NOT NULL,
    "Amount" DECIMAL(18,2) NOT NULL,
    "Currency" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_initiative FOREIGN KEY("InitiativeId") REFERENCES "Initiatives"("Id") ON DELETE CASCADE
    );
DO $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM "Initiatives") THEN

    INSERT INTO "Initiatives" ("Id", "Title", "Description", "Qty", "Goal", "Raised", "Currency", "Deadline", "TargetType", "TargetSubtype", "Status", "CreatedBy", "CreatedAt", "UpdatedAt")
    SELECT gen_random_uuid(), 'New Teapot for FAF cab',
           'Raising funds to buy a big teapot and mugs so everyone in the FAF cab can share tea during breaks.',
           1, 50.00, 0, 'MDL', NOW() + INTERVAL '10 days', 'ASSET', 'Student Life', 'OPEN', 'seed_user', NOW(), NOW()
    WHERE NOT EXISTS (SELECT 1 FROM "Initiatives" WHERE "Title" = 'New Teapot for FAF cab');
    
    INSERT INTO "Initiatives" ("Id", "Title", "Description", "Qty", "Goal", "Raised", "Currency", "Deadline", "TargetType", "TargetSubtype", "Status", "CreatedBy", "CreatedAt", "UpdatedAt")
    SELECT gen_random_uuid(), 'Bean Bags for FAF cab',
           'Make the FAF cab more comfy with bean bags, pillows, and coffee tables.',
           10, 400.00, 0, 'MDL', NOW() + INTERVAL '20 days', 'ASSET', 'Bean Bags', 'OPEN', 'seed_user', NOW(), NOW()
    WHERE NOT EXISTS (SELECT 1 FROM "Initiatives" WHERE "Title" = 'Bean Bags for FAF cab');
    
    INSERT INTO "Initiatives" ("Id", "Title", "Description", "Qty", "Goal", "Raised", "Currency", "Deadline", "TargetType", "TargetSubtype", "Status", "CreatedBy", "CreatedAt", "UpdatedAt")
    SELECT gen_random_uuid(), 'Hackathon Snacks',
           'Provide snacks, energy drinks, and pizza for the upcoming 24h FAF hackathon.',
           50, 250.00, 0, 'MDL', NOW() + INTERVAL '7 days', 'CONSUMABLE', 'Student Events', 'OPEN', 'seed_user', NOW(), NOW()
    WHERE NOT EXISTS (SELECT 1 FROM "Initiatives" WHERE "Title" = 'Hackathon Snacks');

END IF;
END $$;
DO $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM "Donations") THEN

INSERT INTO "Donations" ("Id", "InitiativeId", "UserId", "Amount", "Currency", "CreatedAt")
SELECT gen_random_uuid(), i."Id", 'student_alex', 5.00, 2, NOW()
FROM "Initiatives" i
WHERE i."Title" = 'New Teapot for FAF cab'
AND NOT EXISTS (SELECT 1 FROM "Donations" WHERE "UserId" = 'student_alex' AND "Amount" = 5.00);

INSERT INTO "Donations" ("Id", "InitiativeId", "UserId", "Amount", "Currency", "CreatedAt")
SELECT gen_random_uuid(), i."Id", 'student_vlad', 10.00, 1, NOW()
FROM "Initiatives" i
WHERE i."Title" = 'Hackathon Snacks'
AND NOT EXISTS (SELECT 1 FROM "Donations" WHERE "UserId" = 'student_vlad' AND "Amount" = 10.00);
END IF;
END $$;