package coursework with SPARK_mode is

   -- Airlock Door types
   type openClose is (Open, Closed);
   type lockUnlock is (Locked, Unlocked);
   type Door is record
      door : OpenClose;
      lock : lockUnlock;
   end record;
   
   -- Torpedo functionality
   type torpedoState is (Loaded, Stored, Empty);
   type torpedoChamber is range 1..10;
   type torpedos is array (torpedoChamber) of torpedoState;
   
   -- Measured in metres (m)
   subtype Depth is Integer range 0..500;
   
   -- Measured as a percent (%) of 100
   subtype OxygenLevel is Integer range 0..100;
   
   -- Measured in degrees celsius (°C)
   subtype ReactorTemp is Integer range 0..400;
   
   -- Set door status
   D1 : Door := (lock => Locked, door => Closed);
   D2 : Door := (lock => Locked, door => Closed);
   
   -- Set the starting depth (surfaced)
   curDepth : Depth := 0;
   
   -- Set the starting state for the torpedoes
   torpedoCollection : torpedos := (Loaded, Loaded, Loaded, Loaded, Loaded, 
                                    Loaded, Loaded, Loaded, Loaded, Loaded);
   -- Set the selected torpedo
   currentTorpedo : torpedoChamber := 1;
   
   
   -- Invariants
   
   -- Both airlock doors are closed and locked
   function AirlocksClosed (firstDoor : in Door; secondDoor : in Door) return Boolean is
     (firstDoor.door = Closed and firstDoor.lock = Locked and 
        secondDoor.door = Closed and secondDoor.lock = Locked);
   
   -- Submarine is submerged
   function Submerged return Boolean is
      (curDepth > Depth'First and curDepth < Depth'Last);
   
   
   -- Functionality to open airlock door
   procedure openDoor (thisDoor : in out Door; otherDoor : in Door; thisDepth : in Depth) with
     Pre => thisDoor.door = Closed and thisDoor.lock = Unlocked and otherDoor.door = Closed and thisDepth = 0,
     Post => thisDoor.door = Open and thisDoor.lock = Unlocked;
   
   -- Functionality to close airlock door
   procedure closeDoor (thisDoor : in out Door) with
     Pre => thisDoor.door = Open,
     Post => thisDoor.door = Closed;
   
   -- Functionality to unlock airlock door
   procedure unlockDoor (thisDoor : in out Door; thisDepth : in Depth) with
     Pre => thisDoor.door = Closed and thisDoor.lock = Locked and thisDepth = 0,
     Post => thisDoor.door = Closed and thisDoor.lock = Unlocked;
   
   -- Functionality to lock airlock door
   procedure lockDoor (thisDoor : in out Door) with
     Pre => thisDoor.door = Closed and thisDoor.lock = Unlocked,
     Post => thisDoor.door = Closed and thisDoor.lock = Locked;
   
   
   -- Functionality to set the depth of the submarine
   procedure dive (curDepth : in out Depth; goalDepth : in Depth; doorOne : in Door; doorTwo : in Door) with
     Pre => AirlocksClosed(firstDoor => doorOne, secondDoor => doorTwo) and goalDepth <= Depth'Last and goalDepth >= Depth'First,
     Post => AirlocksClosed(firstDoor => doorOne, secondDoor => doorTwo) and curDepth <= Depth'Last and curDepth >= Depth'First and curDepth = goalDepth;
   
   
   -- Functionality to check the current oxygen level, and surface the submarine in certain conditions
   procedure checkOxygen (oxyLevel : in out OxygenLevel; curDepth : in out Depth; 
                          doorOne : in Door; 
                          doorTwo : in Door) with
     Pre => Submerged and AirlocksClosed(firstDoor => doorOne,
                                         secondDoor => doorTwo),
    Post => (if oxyLevel = 0 then curDepth = 0);
   
   -- Functionality to display a warning when oxygen runs low
   function oxygenWarning (oxyLevel : in OxygenLevel; curDepth : in Depth; 
                           doorOne : in Door; 
                           doorTwo : in Door) return Boolean with
     Pre => oxyLevel < 30 and Submerged and AirlocksClosed(firstDoor => doorOne,
                                         secondDoor => doorTwo);
     
   -- Functionality to check the current reactor temperature, and surface the submarine in certain conditions
   procedure checkTemperature (temp : in out ReactorTemp; oxyLevel : in out OxygenLevel; 
                               curDepth : in out Depth; doorOne : in Door; 
                               doorTwo : in Door) with
     Pre => Submerged and AirlocksClosed(firstDoor => doorOne,
                                         secondDoor => doorTwo),
     Post => (if temp >= 350 then curDepth = 0);
   
   -- Functionality to store a torpedo
   procedure storeTorpedo with
   Pre => torpedoCollection(currentTorpedo) = Empty and curDepth = 0,
   Post => torpedoCollection(currentTorpedo) = Stored;
 
   -- Functionality to load a torpedo into a chamber
   procedure loadTorpedo with
     Pre => torpedoCollection(currentTorpedo) = Stored and Submerged and AirlocksClosed(firstDoor => D1, secondDoor => D2),
     Post => torpedoCollection(currentTorpedo) = Loaded;
   
   -- Functionality to fire a torpedo
   procedure fireTorpedo with
     Pre => torpedoCollection(currentTorpedo) = Loaded and Submerged and AirlocksClosed(firstDoor => D1, secondDoor => D2),
     Post => torpedoCollection(currentTorpedo) = Empty and 
     (for all a in torpedoCollection'Range => 
        (if a /= currentTorpedo then 
             torpedoCollection(a) = torpedoCollection'Old(a)));
   
   -- Functionality to select a torpedo
   procedure selectTorpedo(selectedChamber : in torpedoChamber) with
     Pre => AirlocksClosed(firstDoor => D1, secondDoor => D2),
     Post => currentTorpedo = selectedChamber;

end coursework;
