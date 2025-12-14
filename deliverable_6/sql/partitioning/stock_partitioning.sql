CREATE TABLE Stock (
    HID INT,
    MID INT,
    StockTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice >= 0),
    Qty INT DEFAULT 0 CHECK (Qty >= 0),
    ReorderLevel INT DEFAULT 10 CHECK (ReorderLevel >= 0),
    PRIMARY KEY (HID, MID, StockTimestamp), --HID is already part of the primary key
    FOREIGN KEY (HID) REFERENCES Hospital(HID),
    FOREIGN KEY (MID) REFERENCES Medication(MID))
--the part where we partition (part of the stock table):
PARTITION BY HASH (HID)
PARTITIONS 16; -- depending on the size of the database we chose an adequate power of two value
