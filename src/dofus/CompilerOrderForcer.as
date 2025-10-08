// ORDEN DE COMPILACIÓN FORZADO PARA RESOLVER ERRORES DE DEPENDENCIAS
// Este archivo debe incluirse PRIMERO en la compilación de Flash CS

// 1. Importar todas las interfaces primero
import com.ankamagames.interfaces.IComparable;
import com.ankamagames.interfaces.IDisposable;
import dofus.utils.criterions.ICriterion;
import dofus.utils.nameChecker.rules.INameCheckerRules;
import dofus.graphics.gapi.controls.inventoryviewer.IInventoryFilter;

// 2. Importar clases base
import dofus.utils.ApiElement;

// 3. Importar clases principales que causan problemas
import dofus.datacenter.Alignment;
import dofus.sounds.AudioElement;
import dofus.graphics.gapi.ui.bigstore.BigStoreSellFilter;
import dofus.utils.nameChecker.rules.NameCheckerCharacterNameRules;
import dofus.utils.nameChecker.rules.NameCheckerGuildNameRules;
import dofus.utils.criterions.subareaCriterion.SubareaCriterionAlignment;
import dofus.utils.criterions.basicCriterion.BasicCriterionEpisod;

// Clase para forzar la compilación en orden correcto
class dofus.CompilerOrderForcer
{
    function CompilerOrderForcer()
    {
        // Constructor vacío - solo fuerza la carga de dependencias
    }
    
    // Método para verificar que todas las clases están cargadas
    static function forceLoadingOrder():Void
    {
        // Esta función fuerza la evaluación de todas las clases en orden
        trace("CompilerOrderForcer: Forzando orden de carga de clases...");
    }
}