class ank.utils.MouseEvents
{
   function MouseEvents()
   {
   }
   static function addListener(oListener)
   {
      Mouse.addListener(oListener);
      ank.utils.MouseEvents.garbageCollector();
   }
   static function garbageCollector()
   {
      // En AS2, no podemos acceder a Mouse._listeners directamente
      // Esta función se mantiene por compatibilidad pero sin funcionalidad
      // var _loc2_ = Mouse._listeners; // No accesible en AS2
      // En su lugar, podríamos mantener nuestro propio array de listeners si fuera necesario
   }
}
