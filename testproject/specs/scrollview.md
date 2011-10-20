Specification Document for: scrollView (widget)
===============================================

## Example:

The options table below is completely optional. Example shows all possible keys it can hold.

---

	local options = {
	    width = number,     	-- default display.contentWidth
	    height = number,    	-- default display.contentHeight - top
	    mask = string,      	-- asset filename for bitmap mask (used for clipping boundaries)
	    maskBaseDir = dir,  	-- can be: system.ResourceDirectory, system.DocumentsDirectory, system.TemporaryDirectory
	    left = number,      	-- default 0
	    top = number,       	-- default 0
		topPadding = number		-- default 0
		bottomPadding = number	-- default 0
		bgColor = table,		-- { r(0-255), g(0-255), b(0-255), a(0-255) }; default { 255, 255, 255, 255 }
	}

	local scrollView = widget.create( "scrollView", options )

---	

## CHANGES FROM PREVIOUS WIDGET IMPLEMENTATION:

* No more shortcut properties (such as setting x/y of widget), with an exception of the removeSelf() method. All other changes to widget's display object must be done to it's ._view property

* Display object is accessed via scrollView._view property rather than scrollView.view