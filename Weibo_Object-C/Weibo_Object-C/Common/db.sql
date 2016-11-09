-- 创建表 --
CREATE TABLE IF NOT EXISTS "T_Status" (
    "statusid" INTEGER NULL,
    "status" TEXT,
    "userid" INTEGER NOT NULL,
    "createtime" TEXT DEFAULT (datetime('now','localtime')),
    PRIMARY KEY("statusid","userid")
);

-- 创建图书表 --
CREATE TABLE IF NOT EXISTS "T_Book" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "bookName" TEXT
);
