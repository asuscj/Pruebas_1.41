interface dofus.utils.nameChecker.rules.INameCheckerRules
{
   function getMinNameLength():Number;
   function getMaxNameLength():Number;
   function getNumberOfAllowedDashes():Number;
   function getIsAllowingSpaces():Boolean;
   function getNoDashesOnTheseIndexes():Array;
   function getIfFirstCharMustBeUppercase():Boolean;
   function getIfNoCharAfterTheFirstMustBeUppercase():Boolean;
   function getCharAllowingUppercase():Array;
   function getIfCannotEndWithUppercase():Boolean;
   function getStrictlyEqualsProhibedWords():Array;
}
