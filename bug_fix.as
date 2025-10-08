This file contains the necessary code changes to fix the graphic sequence bug where the Dofus loader fails to hide after the loading process is complete. The changes are annotated to explain the purpose of each modification.

```actionscript
class dofus.DofusLoader extends ank.utils.QueueEmbedMovieClip
{
   // ... (existing code) ...

   // Fix: Add a new public static function to hide the loader
   public static function hide():Void
   {
      if (_root._loader != undefined)
      {
         _root._loader.removeMovieClip();
      }
      if (_root._loaderBorder != undefined)
      {
         _root._loaderBorder.removeMovieClip();
      }
   }

   function onCoreDisplayed()
   {
      this.launchBannerAnim(false);
      this.showBanner(false);

      // Fix: Call the hide() function to ensure the loader is removed
      DofusLoader.hide();

      // this.showLoader(false); // This line is now redundant
   }

   // ... (existing code) ...
}
```

### Explanation of Changes

1.  **`hide()` function**:
    *   A new public static function `hide()` has been added to the `DofusLoader` class.
    *   This function is responsible for removing the loader's `MovieClip` instances (`_loader` and `_loaderBorder`) from the root timeline.
    *   Using `removeMovieClip()` instead of setting `_visible = false` ensures that the loader is completely removed from the display stack and no longer consumes any resources.

2.  **`onCoreDisplayed()` modification**:
    *   The `onCoreDisplayed()` function is called when the main game core has been initialized and is ready to be displayed.
    *   The original `this.showLoader(false)` call has been replaced with a call to the new `DofusLoader.hide()` function.
    *   This ensures that the loader is reliably hidden at the correct point in the loading sequence, preventing it from blocking other game interfaces.