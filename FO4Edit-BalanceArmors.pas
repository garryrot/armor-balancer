{
  Script for FO4Edit to balance armor mods based on body-part (biped slot)
  ------------------------------------------------------------------------

  Modders are usually all over the place when creating custom armors, some
  go completely overpowered, making the armors basically a cheat, or
  they create purely cosmetic things that do not have combat properties at all,
  while taking up an armor slot.

  If you enjoy a balanced game this script automatically adapts all 
  selected armors according to the following rules:
  
  - Give items that take up armor-slots (Torso, L/R Hand/Leg) armor-like stats (weight and armor rating)
  - Remove all armor stats from all remaining items and make them weightless

  How it works:
  - Select any amount of armors in FO4Edit
  - Right-click and "apply script"
  - Copy-paste this entire script
  - Adapt the values to your liking
  - Apply the script

  Caveats:
  - Right now it does not touch/adapt radiation or energy resistance
}

unit userscript;

function HasBipedFlag(e: IInterface; bitIndex: Integer): Boolean;
var
  flags: string;
begin
  Result := False;
  flags := GetElementEditValues(e, 'BOD2\First Person Flags');

  if (Length(flags) >= bitIndex + 1) and (flags[bitIndex + 1] = '1') then
    Result := True;
end;

function ChangeArmorForBiped(e: IInterface; biped: Integer; armorRating: String; weightRating: String): Boolean;
begin
    Result := False;
    if HasBipedFlag(e, biped) then
    begin
        Result := True;
        AddMessage('Biped(' + IntToStr(biped) + ') Match. Setting armor rating to ' + armorRating);
        SetElementEditValues(e, 'FNAM - FNAM\Armor Rating', armorRating);
        SetElementEditValues(e, 'DATA - DATA\Weight', weightRating); 
    end;
end;

function Process(e: IInterface): integer;
var
  bipedElement: IInterface;
  armorRatingElement: IInterface;

  defaultArmor: String;
  torsoArmor: String;
  armArmor: String;
  legArmor: String;

begin
  Result := 0;
  AddMessage('Processing ' + Name(e));
  
  armorRatingElement := ElementByPath(e, 'FNAM\Armor Rating');
  if Assigned(armorRatingElement) then
  begin

    // default for everything that is not an armor slot
    SetElementEditValues(e, 'FNAM - FNAM\Armor Rating', '0'); 
    SetElementEditValues(e, 'DATA - DATA\Weight', '0.1');
    
    // armor slots
    ChangeArmorForBiped(e, 12, '7', '2.0');  // 'L Arm'
    ChangeArmorForBiped(e, 13, '7', '2.0');  // 'R Arm'
    ChangeArmorForBiped(e, 14, '7', '2.0');  // 'L Leg',
    ChangeArmorForBiped(e, 15, '7', '2.0');  // 'R Leg',
    ChangeArmorForBiped(e, 11, '12', '4.0'); // 'Torso', 
  end;
end;
end.
