// ARCHIVO DE COMPATIBILIDAD DE CLASSPATH
// Este archivo ayuda a resolver problemas de compilación en Flash CS
// relacionados con el orden y acceso a clases

// Pre-declaraciones para ayudar al compilador
import dofus.datacenter.Alignment;
import dofus.utils.nameChecker.rules.NameCheckerCharacterNameRules;
import dofus.utils.nameChecker.rules.NameCheckerGuildNameRules;
import dofus.utils.criterions.subareaCriterion.SubareaCriterionAlignment;
import dofus.utils.criterions.basicCriterion.BasicCriterionEpisod;
import dofus.graphics.gapi.ui.bigstore.BigStoreSellFilter;

// Clase helper para resolver problemas de classpath
class dofus.ClasspathHelper
{
    // Referencias estáticas para forzar la carga de clases
    static var alignmentRef:dofus.datacenter.Alignment;
    static var nameCheckerCharRef:dofus.utils.nameChecker.rules.NameCheckerCharacterNameRules;
    static var nameCheckerGuildRef:dofus.utils.nameChecker.rules.NameCheckerGuildNameRules;
    static var subareaRef:dofus.utils.criterions.subareaCriterion.SubareaCriterionAlignment;
    static var basicRef:dofus.utils.criterions.basicCriterion.BasicCriterionEpisod;
    static var bigStoreRef:dofus.graphics.gapi.ui.bigstore.BigStoreSellFilter;
    
    function ClasspathHelper()
    {
        // Constructor vacío
    }
    
    // Método para verificar que todas las clases están disponibles
    static function verifyClasses():Boolean
    {
        try {
            // Forzar la carga de todas las clases problemáticas
            alignmentRef = dofus.datacenter.Alignment;
            nameCheckerCharRef = dofus.utils.nameChecker.rules.NameCheckerCharacterNameRules;
            nameCheckerGuildRef = dofus.utils.nameChecker.rules.NameCheckerGuildNameRules;
            subareaRef = dofus.utils.criterions.subareaCriterion.SubareaCriterionAlignment;
            basicRef = dofus.utils.criterions.basicCriterion.BasicCriterionEpisod;
            bigStoreRef = dofus.graphics.gapi.ui.bigstore.BigStoreSellFilter;
            return true;
        } catch (e) {
            return false;
        }
    }
}