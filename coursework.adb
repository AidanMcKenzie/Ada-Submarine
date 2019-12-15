with Ada.Text_IO; use Ada.Text_IO;
package body coursework with SPARK_mode is

   procedure openDoor (thisDoor : in out Door; otherDoor : in Door; thisDepth : in Depth) is
   begin
      if (thisDoor.lock = Unlocked and thisDoor.door = Closed and otherDoor.door = Closed and thisDepth = 0) then
         thisDoor.door := Open;
      end if;
   end openDoor;  
   
   procedure closeDoor (thisDoor : in out Door) is
   begin 
      if (thisDoor.door = Open) then
         thisDoor.door := Closed;
      end if;
   end closeDoor; 
   
   procedure unlockDoor (thisDoor : in out Door; thisDepth : in Depth) is
   begin 
      if (thisDoor.door = Closed and thisDoor.lock = Locked and thisDepth = 0) then
         thisDoor.lock := Unlocked;
      end if;
   end unlockDoor;
   
   procedure lockDoor (thisDoor : in out Door) is
   begin 
      if (thisDoor.door = Closed and thisDoor.lock = Unlocked) then
         thisDoor.lock := Locked;
      end if;
   end lockDoor;
   
   procedure dive (curDepth : in out Depth; goalDepth : in Depth; doorOne : in Door; doorTwo : in Door) is
   begin 
      if (goalDepth <= Depth'Last and doorOne.lock = Locked and doorOne.door = Closed and doorTwo.door = Closed
         and doortwo.lock = Locked and goalDepth /= curDepth) then
         curDepth := goalDepth;
      end if;
      
   end dive;
   
   procedure checkOxygen (oxyLevel : in out OxygenLevel; curDepth : in out Depth; 
                          doorOne : in Door; 
                          doorTwo : in Door) is
   begin
      if (oxyLevel = 0) then
         -- Surface the submarine
         dive(curDepth, 0, doorOne, doorTwo);
         oxyLevel := 100;
      end if;
   end checkOxygen;
   
   function oxygenWarning (oxyLevel : in OxygenLevel; curDepth : in Depth; 
                           doorOne : in Door; 
                           doorTwo : in Door) return Boolean is
   begin
      if (oxyLevel < 30 and curDepth > Depth'First and doorOne.lock = Locked and doorOne.door = Closed and doorTwo.door = Closed
          and doortwo.lock = Locked) then
         return True;
      end if;
      return False;
   end oxygenWarning;
  
   procedure checkTemperature (temp : in out ReactorTemp; oxyLevel : in out OxygenLevel;
                               curDepth : in out Depth; doorOne : in Door; 
                               doorTwo : in Door) is
   begin
      if (temp >= 350) then
         -- Surface the submarine
         dive(curDepth, 0, doorOne, doorTwo);
         temp := 275;
         oxyLevel := 100;
      end if;
   end checkTemperature;
        
   procedure storeTorpedo is
   begin
      if (torpedoCollection(currentTorpedo) = Empty and curDepth = 0) then
         torpedoCollection(currentTorpedo) := Stored;
      end if;    
   end storeTorpedo;
   
   procedure loadTorpedo is
   begin
      if (torpedoCollection(currentTorpedo) = Stored and curDepth > Depth'First 
          and D1.lock = Locked and D1.door = Closed and D2.door = Closed
          and D2.lock = Locked) then
         torpedoCollection(currentTorpedo) := Loaded;
      end if;
   end loadTorpedo;
      
   procedure fireTorpedo is
   begin
      if (torpedoCollection(currentTorpedo) = Loaded and curDepth > Depth'First 
          and D1.lock = Locked and D1.door = Closed and D2.door = Closed
          and D2.lock = Locked) then
         torpedoCollection(currentTorpedo) := Empty;
      end if;
   end fireTorpedo;
   
   procedure selectTorpedo(selectedChamber : in torpedoChamber) is
   begin
      currentTorpedo := selectedChamber;
   end selectTorpedo;
   
end coursework;
