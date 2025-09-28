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
    }
}
